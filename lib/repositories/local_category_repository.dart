import '../models/category.dart';
import 'package:flutter/material.dart';

class LocalCategoryRepository {
  final List<Category> _categories = [
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
    Category(
      id: '4',
      name: 'Transport',
      icon: Icons.directions_car,
      color: Colors.orange,
    ),
    Category(
      id: '5',
      name: 'Entertainment',
      icon: Icons.movie,
      color: Colors.purple,
    ),
    Category(
      id: '6',
      name: 'Health',
      icon: Icons.medical_services,
      color: Colors.red,
    ),
    Category(
      id: '7',
      name: 'Education',
      icon: Icons.school,
      color: Colors.teal,
    ),
    Category(
      id: '8',
      name: 'Shopping',
      icon: Icons.shopping_bag,
      color: Colors.pink,
    ),
  ];

  Future<List<Category>> fetchCategories() async {
    print('Returning categories: $_categories'); // Debug log
    return _categories;
  }

  Future<void> addCategory(Category category) async {
    _categories.add(category);
  }
}
