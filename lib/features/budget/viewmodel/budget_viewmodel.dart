import 'package:flutter/material.dart';
import '../model/budget.dart';
import '../service/local_budget_repository.dart';

class BudgetViewModel extends ChangeNotifier {
  final LocalBudgetRepository _budgetRepository = LocalBudgetRepository();

  List<Budget> _budgets = [];
  List<Budget> get budgets => _budgets;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  BudgetViewModel() {
    loadBudgets();
  }

  Future<void> loadBudgets() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _budgets = await _budgetRepository.fetchBudgets();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addBudget(Budget budget) async {
    try {
      await _budgetRepository.addBudget(budget);
      await loadBudgets(); // Refresh the list
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateBudget(Budget budget) async {
    try {
      await _budgetRepository.updateBudget(budget);
      await loadBudgets(); // Refresh the list
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteBudget(String id) async {
    try {
      await _budgetRepository.deleteBudget(id);
      await loadBudgets(); // Refresh the list
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    // Clean up resources
    super.dispose();
  }
}
