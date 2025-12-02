import 'package:flutter/material.dart';
import '../core/icon_utils.dart';

class Category {
  final String? id;
  final String name;
  final IconData icon;
  final Color color;

  Category({
    this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  // From Map factory
  factory Category.fromMap(Map<String, dynamic> map, String id) {
    return Category(
      id: id,
      name: map['name'],
      icon: convertStringToIcon(map['icon']),
      color: Color(int.parse('0x${map['color']}')),
    );
  }

  // To Map method
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'icon': convertIconToString(icon),
      'color': color.value.toRadixString(16),
    };
  }
}
