import '../models/budget.dart';

class LocalBudgetRepository {
  List<Budget> _budgets = [
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
      allocatedAmount: 1500.00,
      spentAmount: 1200.00,
      date: DateTime(2025, 25, 1),
    ),
    Budget(
      id: '3',
      categoryId: '3',
      allocatedAmount: 300.00,
      spentAmount: 250.00,
      date: DateTime(2025, 1, 1),
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
