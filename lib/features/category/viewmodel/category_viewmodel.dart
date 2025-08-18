import 'package:flutter/foundation.dart';
import 'package:yegna_eqif_new/models/category.dart'; // Assuming Category model is available

class CategoryViewModel extends ChangeNotifier {
  final List<Category> _categories = [];

  List<Category> get categories => _categories;

  void addCategory(Category category) {
    _categories.add(category);
    notifyListeners();
  }

  // TODO: Implement other category-related state and logic here, e.g., fetching from a service
}