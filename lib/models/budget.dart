import 'package:flutter/material.dart';

class Budget {
  final String id;
  final String categoryId;
  final double allocatedAmount;
  final double spentAmount;
  final DateTime date;

  Budget({
    required this.id,
    required this.categoryId,
    required this.allocatedAmount,
    required this.spentAmount,
    required this.date,
  });

  factory Budget.fromMap(Map<String, dynamic> data) {
    return Budget(
      id: data['id'],
      categoryId: data['categoryId'],
      allocatedAmount: data['allocatedAmount'],
      spentAmount: data['spentAmount'],
      date: DateTime.parse(data['date']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'allocatedAmount': allocatedAmount,
      'spentAmount': spentAmount,
      'date': date.toIso8601String(),
    };
  }
}
