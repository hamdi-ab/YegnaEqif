import 'package:flutter/material.dart';
import 'package:yegna_eqif_new/features/transactions/model/transaction.dart';
import 'package:yegna_eqif_new/features/budget/model/budget.dart';
import 'package:yegna_eqif_new/models/debt.dart';
import 'package:yegna_eqif_new/models/category.dart';
import 'package:yegna_eqif_new/models/bank_account.dart';

/// Mock data builders for testing
class MockData {
  /// Creates a mock Transaction with default or custom values
  static Transaction mockTransaction({
    String? id,
    String type = 'Income',
    String name = 'Test Transaction',
    String bankType = 'Cash',
    String category = 'Salary',
    double amount = 100.0,
    DateTime? date,
  }) {
    return Transaction(
      id: id ?? 'test-transaction-${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      name: name,
      bankType: bankType,
      category: category,
      amount: amount,
      date: date ?? DateTime.now(),
    );
  }

  /// Creates a mock Budget with default or custom values
  static Budget mockBudget({
    String? id,
    String category = 'Food',
    double allocatedAmount = 1000.0,
    double spentAmount = 500.0,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Budget(
      id: id ?? 'test-budget-${DateTime.now().millisecondsSinceEpoch}',
      category: category,
      allocatedAmount: allocatedAmount,
      spentAmount: spentAmount,
      startDate: startDate ?? DateTime.now(),
      endDate: endDate ?? DateTime.now().add(const Duration(days: 30)),
    );
  }

  /// Creates a mock Debt with default or custom values
  static Debt mockDebt({
    String? id,
    String personName = 'John Doe',
    double totalAmount = 500.0,
    double remainingAmount = 300.0,
    String bankType = 'Cash',
    DateTime? dueDate,
    double progress = 0.4,
    String transactionType = 'lent',
  }) {
    return Debt(
      id: id ?? 'test-debt-${DateTime.now().millisecondsSinceEpoch}',
      personName: personName,
      totalAmount: totalAmount,
      remainingAmount: remainingAmount,
      bankType: bankType,
      dueDate: dueDate ?? DateTime.now().add(const Duration(days: 30)),
      progress: progress,
      transactionType: transactionType,
    );
  }

  /// Creates a mock Category with default or custom values
  static Category mockCategory({
    String? id,
    String name = 'Test Category',
    IconData icon = Icons.category,
    Color color = Colors.blue,
  }) {
    return Category(
      id: id ?? 'test-category-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      icon: icon,
      color: color,
    );
  }

  /// Creates a mock BankAccountCardModel with default or custom values
  static BankAccountCardModel mockBankAccount({
    String? id,
    String accountName = 'Test Bank',
    String accountNumber = '1234567890',
    double balance = 5000.0,
    Color cardColor = Colors.green,
  }) {
    return BankAccountCardModel(
      id: id ?? 'test-account-${DateTime.now().millisecondsSinceEpoch}',
      accountName: accountName,
      accountNumber: accountNumber,
      balance: balance,
      cardColor: cardColor,
    );
  }

  /// Creates a list of mock transactions
  static List<Transaction> mockTransactionList({int count = 5}) {
    return List.generate(
      count,
      (index) => mockTransaction(
        id: 'transaction-$index',
        type: index % 2 == 0 ? 'Income' : 'Expense',
        amount: 100.0 * (index + 1),
        name: 'Transaction $index',
      ),
    );
  }

  /// Creates a list of mock budgets
  static List<Budget> mockBudgetList({int count = 3}) {
    final categories = ['Food', 'Transport', 'Entertainment'];
    return List.generate(
      count,
      (index) => mockBudget(
        id: 'budget-$index',
        category: categories[index % categories.length],
        allocatedAmount: 1000.0 * (index + 1),
        spentAmount: 500.0 * (index + 1),
      ),
    );
  }

  /// Creates a list of mock categories
  static List<Category> mockCategoryList({int count = 5}) {
    final names = [
      'Food',
      'Transport',
      'Entertainment',
      'Utilities',
      'Healthcare'
    ];
    final icons = [
      Icons.fastfood,
      Icons.directions_car,
      Icons.movie,
      Icons.home,
      Icons.local_hospital
    ];
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.purple,
      Colors.orange,
      Colors.green
    ];

    return List.generate(
      count,
      (index) => mockCategory(
        id: 'category-$index',
        name: names[index % names.length],
        icon: icons[index % icons.length],
        color: colors[index % colors.length],
      ),
    );
  }
}
