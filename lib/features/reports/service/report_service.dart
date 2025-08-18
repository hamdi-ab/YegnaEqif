
import 'package:flutter/material.dart';
import 'package:yegna_eqif_new/features/reports/model/report_model.dart';

class ReportService {
  Future<ReportModel> getReportData() async {
    // In a real app, you would fetch this from other services
    return Future.value(
      ReportModel(
        totalIncome: 10000.0,
        totalExpense: 5000.0,
        categoryBreakdowns: [
          CategoryBreakdown(
            categoryName: 'Food',
            amount: 2000.0,
            percent: 40.0,
            color: Colors.red,
            icon: Icons.fastfood,
            totalTransaction: 10,
          ),
          CategoryBreakdown(
            categoryName: 'Transport',
            amount: 1000.0,
            percent: 20.0,
            color: Colors.blue,
            icon: Icons.directions_bus,
            totalTransaction: 5,
          ),
        ],
      ),
    );
  }
}
