import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category.dart';
import '../services/firestore_service.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

final categoryProvider = StateNotifierProvider<CategoryNotifier, List<Category>>((ref) {
  return CategoryNotifier(ref: ref, firestoreService: ref.watch(firestoreServiceProvider));
});

class CategoryNotifier extends StateNotifier<List<Category>> {
  final Ref ref;
  final FirestoreService firestoreService;

  CategoryNotifier({required this.ref, required this.firestoreService}) : super([]) {
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final categories = await firestoreService.fetchCategories('userId'); // Replace 'userId' with the actual user ID
    state = categories;
  }

  Future<void> addCategory(Category category) async {
    await firestoreService.addCategory('userId', category.name, category.icon, category.color); // Replace 'userId' with the actual user ID
    state = await firestoreService.fetchCategories('userId'); // Refresh state after addition
  }
}
