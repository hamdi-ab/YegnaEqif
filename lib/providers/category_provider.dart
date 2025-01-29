import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category.dart';
import '../repositories/local_category_repository.dart';

final localCategoryRepositoryProvider = Provider<LocalCategoryRepository>((ref) {
  return LocalCategoryRepository();
});

final categoryProvider = StateNotifierProvider<CategoryNotifier, List<Category>>((ref) {
  final repository = ref.read(localCategoryRepositoryProvider);
  return CategoryNotifier(repository);
});

class CategoryNotifier extends StateNotifier<List<Category>> {
  final LocalCategoryRepository repository;

  CategoryNotifier(this.repository) : super([]) {
    fetchCategories(); // Fetch categories when the notifier is created
  }

  Future<void> fetchCategories() async {
    print('Fetching categories...');
    final categories = await repository.fetchCategories();
    print('Fetched categories: $categories');
    state = categories;
  }

  Future<void> addCategory(Category category) async {
    await repository.addCategory(category);
    state = [...state, category];
    print('Added category: $category');
  }
}






// final categoryProvider = StateNotifierProvider<CategoryNotifier, List<Category>>((ref) {
//   final firestoreService = FirestoreService();
//   return CategoryNotifier(firestoreService);
// });
//
// class CategoryNotifier extends StateNotifier<List<Category>> {
//   final FirestoreService firestoreService;
//
//   CategoryNotifier(this.firestoreService) : super([]);
//
//   // Add category
//   Future<void> addCategory(String userId, String name, IconData icon, Color color) async {
//     await firestoreService.addCategory(userId, name, icon, color);
//     state = [...state, Category(name: name, icon: icon, color: color)];
//   }
//
//   // Fetch categories
//   Future<void> fetchCategories(String userId) async {
//     try {
//       final categories = await firestoreService.fetchCategories(userId);
//       state = categories;
//     } catch (e) {
//       // Handle error (e.g., show a snackbar or set an error state)
//       debugPrint("Failed to fetch categories: $e");
//     }
//   }
// }
