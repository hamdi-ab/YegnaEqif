import 'package:flutter/foundation.dart';
import 'package:yegna_eqif_new/models/category.dart'
    as app_category; // Avoid conflict with Flutter's Category

class CategoryViewModel extends ChangeNotifier {
  final List<app_category.Category> _categories = [];

  List<app_category.Category> get categories => _categories;

  void addCategory(app_category.Category category) {
    _categories.add(category);
    notifyListeners();
  }

  // TODO: Implement other category-related state and logic here, e.g., fetching from a service
}
