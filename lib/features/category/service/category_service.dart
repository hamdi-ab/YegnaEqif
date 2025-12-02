import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yegna_eqif_new/core/firebase_constants.dart';
import 'package:yegna_eqif_new/models/category.dart' as app_category;

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Fetch all categories for the current user
  Future<List<app_category.Category>> fetchCategories() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final snapshot = await _firestore
          .collection(FirebaseCollections.categories)
          .where(FirebaseFields.userId, isEqualTo: user.uid)
          .get();

      return snapshot.docs
          .map((doc) => app_category.Category.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  /// Add a new category
  Future<void> addCategory(app_category.Category category) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      await _firestore
          .collection(FirebaseCollections.categories)
          .doc(category.id)
          .set(category.toMap());
    } catch (e) {
      throw Exception('Failed to add category: $e');
    }
  }

  /// Delete a category
  Future<void> deleteCategory(String categoryId) async {
    try {
      await _firestore
          .collection(FirebaseCollections.categories)
          .doc(categoryId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }

  /// Update a category
  Future<void> updateCategory(app_category.Category category) async {
    try {
      await _firestore
          .collection(FirebaseCollections.categories)
          .doc(category.id)
          .update(category.toMap());
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }
}
