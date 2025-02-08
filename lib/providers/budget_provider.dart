import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/budget.dart';
import '../services/firestore_service.dart';
import 'debt_provider.dart';

final budgetProvider = StateNotifierProvider<BudgetNotifier, List<Budget>>((ref) {
  return BudgetNotifier(ref: ref, firestoreService: ref.watch(firestoreServiceProvider));
});

class BudgetNotifier extends StateNotifier<List<Budget>> {
  final Ref ref;
  final FirestoreService firestoreService;

  BudgetNotifier({required this.ref, required this.firestoreService}) : super([]) {
    _fetchBudgets();
  }

  Future<void> _fetchBudgets() async {
    final budgets = await firestoreService.fetchBudgets('userId'); // Replace 'userId' with the actual user ID
    state = budgets;
  }

  Future<void> addBudget(Budget budget) async {
    await firestoreService.addBudget('userId', budget); // Replace 'userId' with the actual user ID
    state = await firestoreService.fetchBudgets('userId'); // Refresh state after addition
  }
  Future<void> updateSpentAmount(String category, double amount) async {
    // First update Firebase
    for (final budget in state) {
      if (budget.category == category) {
        await firestoreService.updateBudget('userId', budget.id ,budget.copyWith(spentAmount: budget.spentAmount + amount));
      }
    }
    // Then refresh state
    state = await firestoreService.fetchBudgets('userId');
  }

  Future<void> removeBudget(String id) async {
    await firestoreService.removeBudget('userId', id); // Replace 'userId' with the actual user ID
    state = await firestoreService.fetchBudgets('userId'); // Refresh state after removal
  }

  Future<void> updateBudget(Budget updatedBudget) async {
    await firestoreService.updateBudget('userId', updatedBudget.id, updatedBudget); // Replace 'userId' with the actual user ID
    state = await firestoreService.fetchBudgets('userId'); // Refresh state after update
  }

  Future<void> deleteBudget(String id) async {
    await firestoreService.removeBudget('userId', id); // Replace 'userId' with the actual user ID
    state = await firestoreService.fetchBudgets('userId'); // Refresh state after deletion
  }
}
