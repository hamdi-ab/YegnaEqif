
import 'package:flutter/material.dart';

class ReportModel {
  final double totalIncome;
  final double totalExpense;
  final List<CategoryBreakdown> categoryBreakdowns;

  ReportModel({
    required this.totalIncome,
    required this.totalExpense,
    required this.categoryBreakdowns,
  });
}

class CategoryBreakdown {
  final String categoryName;
  final double amount;
  final double percent;
  final Color color;
  final IconData icon;
  final int totalTransaction;

  CategoryBreakdown({
    required this.categoryName,
    required this.amount,
    required this.percent,
    required this.color,
    required this.icon,
    required this.totalTransaction,
  });
}
