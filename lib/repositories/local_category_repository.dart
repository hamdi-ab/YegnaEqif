import '../models/category.dart';
import 'package:flutter/material.dart';

class LocalCategoryRepository {
  List<Category> _categories = [
    Category(
      id: '1',
      name: 'Groceries',
      icon: Icons.shopping_cart,
      color: Colors.blue,
    ),
    Category(
      id: '2',
      name: 'Salary',
      icon: Icons.attach_money,
      color: Colors.green,
    ),
    Category(
      id: '3',
      name: 'Utilities',
      icon: Icons.lightbulb_outline,
      color: Colors.yellow,
    ),
    // Add more categories as needed
  ];

  Future<List<Category>> fetchCategories() async {
    print('Returning categories: $_categories'); // Debug log
    return _categories;
  }

  Future<void> addCategory(Category category) async {
    _categories.add(category);
  }
}
