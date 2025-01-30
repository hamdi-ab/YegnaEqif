import '../models/budget.dart';

class LocalBudgetRepository {
  final List<Budget> _budgets = [
    // Groceries
    Budget(
      id: '1',
      categoryId: '1',
      allocatedAmount: 200.00,
      spentAmount: 150.00,
      date: DateTime(2024, 5, 8),
    ),
    Budget(
      id: '2',
      categoryId: '2',
      allocatedAmount: 250.00,
      spentAmount: 200.00,
      date: DateTime(2025, 1, 6),
    ),

    // Salary
    Budget(
      id: '3',
      categoryId: '3',
      allocatedAmount: 1500.00,
      spentAmount: 1200.00,
      date: DateTime(20212, 1, 25),
    ),
    Budget(
      id: '4',
      categoryId: '4',
      allocatedAmount: 1600.00,
      spentAmount: 1400.00,
      date: DateTime(2024, 2, 25),
    ),

    // Utilities
    Budget(
      id: '5',
      categoryId: '5',
      allocatedAmount: 300.00,
      spentAmount: 250.00,
      date: DateTime(2024, 1, 1),
    ),
    Budget(
      id: '6',
      categoryId: '6',
      allocatedAmount: 320.00,
      spentAmount: 280.00,
      date: DateTime(2024, 2, 1),
    ),

    // Transport
    Budget(
      id: '7',
      categoryId: '7',
      allocatedAmount: 100.00,
      spentAmount: 80.00,
      date: DateTime(2024, 3, 1),
    ),
    Budget(
      id: '8',
      categoryId: '8',
      allocatedAmount: 120.00,
      spentAmount: 90.00,
      date: DateTime(2024, 4, 1),
    ),
  ];

  Future<List<Budget>> fetchBudgets() async {
    print('Returning budgets: $_budgets');
    return _budgets;
  }

  Future<void> addBudget(Budget budget) async {
    _budgets.add(budget);
  }

  Future<void> updateBudget(Budget budget) async {
    int index = _budgets.indexWhere((b) => b.id == budget.id);
    if (index != -1) {
      _budgets[index] = budget;
    }
  }

  Future<void> deleteBudget(String id) async {
    _budgets.removeWhere((b) => b.id == id);
  }
}
