// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import '../models/category.dart';
// import '../models/transaction.dart' as transaction;
// import '../utils/firebase_utils.dart';
// import '../utils/icon_utils.dart';
//
// class FirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<void> addCategory(String userId, String name, IconData icon, Color color) async {
//     final String iconString = convertIconToString(icon);
//     final String colorHex = convertColorToHex(color);
//
//     await _firestore
//         .collection('users')
//         .doc(userId)
//         .collection('categories')
//         .add({
//       'name': name,
//       'icon': iconString,
//       'color': colorHex,
//     });
//   }
//
//   Future<List<Category>> fetchCategories(String userId) async {
//     final snapshot = await _firestore
//         .collection('users')
//         .doc(userId)
//         .collection('categories')
//         .get();
//
//     return snapshot.docs.map((doc) {
//       final data = doc.data();
//       return Category(
//         name: data['name'],
//         icon: convertStringToIcon(data['icon']),
//         color: convertHexToColor(data['color']),
//       );
//     }).toList();
//   }
//
//   Future<void> addTransaction(String userId, transaction.Transaction transaction) async {
//     await _firestore
//         .collection('users')
//         .doc(userId)
//         .collection('transactions')
//         .add(transaction.toMap());
//   }
//
//   Future<List<transaction.Transaction>> fetchTransactions(String userId) async {
//     final snapshot = await _firestore
//         .collection('users')
//         .doc(userId)
//         .collection('transactions')
//         .get();
//
//     return snapshot.docs.map((doc) {
//       return transaction.Transaction.fromMap(doc.data(), doc.id);
//     }).toList();
//   }
// }
