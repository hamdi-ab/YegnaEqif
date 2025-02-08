import 'package:flutter/material.dart';
import '../utils/icon_utils.dart'; // Assuming you have a utility file for converting icons

class Category {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  // Assuming you'll need to convert data to/from a map for Firebase
  factory Category.fromMap(Map<String, dynamic> data) {
    return Category(
      id: data['id'],
      name: data['name'],
      icon: convertStringToIcon(data['icon']),
      color: Color(data['color']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': convertIconToString(icon),
      'color': color.value,
    };
  }

  Category copyWith({
    String? id,
    String? name,
    IconData? icon,
    Color? color,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }
}
