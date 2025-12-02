import 'package:flutter/foundation.dart';
import 'package:yegna_eqif_new/models/category.dart'
    as app_category; // Avoid conflict with Flutter's Category
import 'package:yegna_eqif_new/features/category/service/category_service.dart';

class CategoryViewModel extends ChangeNotifier {
  final CategoryService _service = CategoryService();

  List<app_category.Category> _categories = [];
  bool _isLoading = false;
  String? _error;
  bool _disposed = false;

  List<app_category.Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetch categories from Firebase
  Future<void> fetchCategories() async {
    _isLoading = true;
    _error = null;
    _safeNotifyListeners();

    try {
      _categories = await _service.fetchCategories();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _categories = [];
    } finally {
      _isLoading = false;
      _safeNotifyListeners();
    }
  }

  void _safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  /// Add a new category
  Future<void> addCategory(app_category.Category category) async {
    try {
      await _service.addCategory(category);
      _categories.add(category);
      _safeNotifyListeners();
    } catch (e) {
      _error = e.toString();
      _safeNotifyListeners();
      rethrow;
    }
  }

  /// Delete a category
  Future<void> deleteCategory(String categoryId) async {
    try {
      await _service.deleteCategory(categoryId);
      _categories.removeWhere((cat) => cat.id == categoryId);
      _safeNotifyListeners();
    } catch (e) {
      _error = e.toString();
      _safeNotifyListeners();
      rethrow;
    }
  }

  /// Update a category
  Future<void> updateCategory(app_category.Category category) async {
    try {
      await _service.updateCategory(category);
      final index = _categories.indexWhere((cat) => cat.id == category.id);
      if (index != -1) {
        _categories[index] = category;
        _safeNotifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      _safeNotifyListeners();
      rethrow;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
