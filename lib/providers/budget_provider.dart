import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/budget.dart';
import '../repositories/local_budget_repository.dart';

final localBudgetRepositoryProvider = Provider<LocalBudgetRepository>((ref) {
  return LocalBudgetRepository();
});

final budgetProvider = StateNotifierProvider<BudgetNotifier, List<Budget>>((ref) {
  final repository = ref.read(localBudgetRepositoryProvider);
  return BudgetNotifier(repository);
});

class BudgetNotifier extends StateNotifier<List<Budget>> {
  final LocalBudgetRepository repository;

  BudgetNotifier(this.repository) : super([]) {
    fetchBudgets();
  }

  Future<void> fetchBudgets() async {
    print('Fetching budgets...');
    final budgets = await repository.fetchBudgets();
    print('Fetched budgets: $budgets');
    state = budgets;
  }

  Future<void> addBudget(Budget budget) async {
    await repository.addBudget(budget);
    state = [...state, budget];
    print('Added budget: $budget');
  }

  Future<void> updateBudget(Budget budget) async {
    await repository.updateBudget(budget);
    state = state.map((b) => b.id == budget.id ? budget : b).toList();
    print('Updated budget: $budget');
  }

  Future<void> deleteBudget(String id) async {
    await repository.deleteBudget(id);
    state = state.where((b) => b.id != id).toList();
    print('Deleted budget with id: $id');
  }
}
