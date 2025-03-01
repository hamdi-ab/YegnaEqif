import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/budget.dart';
import '../services/firestore_service.dart';
import 'auth_provider.dart';
import 'debt_provider.dart';

final budgetProvider = StateNotifierProvider<BudgetNotifier, List<Budget>>((ref) {
  final currentUser = ref.watch(firebaseAuthProvider).currentUser;
  return BudgetNotifier(userId: currentUser?.uid ?? '' ,ref: ref, firestoreService: ref.watch(firestoreServiceProvider));
});

class BudgetNotifier extends StateNotifier<List<Budget>> {
  final Ref ref;
  final FirestoreService firestoreService;
  final String userId;

  BudgetNotifier({required this.userId, required this.ref, required this.firestoreService}) : super([]) {
    _fetchBudgets();
  }

  Future<void> _fetchBudgets() async {
    final budgets = await firestoreService.fetchBudgets(userId); // Replace 'userId' with the actual user ID
    state = budgets;
  }

  Future<void> addBudget(Budget budget) async {
    await firestoreService.addBudget(userId, budget); // Replace 'userId' with the actual user ID
    state = await firestoreService.fetchBudgets(userId); // Refresh state after addition
  }
  Future<void> updateSpentAmount(String category, double amount) async {
    try {
      for (final budget in state) {
        if (budget.category == category) {
          final updatedBudget = budget.copyWith(
              spentAmount: budget.spentAmount + amount);
          await firestoreService.updateBudget(userId, budget.id ?? '',
              updatedBudget); // Replace 'userId' with the actual user ID
        }
      }
      // Refresh state after update
      state = await firestoreService.fetchBudgets(userId);
    } catch (e) {
      // Handle errors if any
      print('Error updating spent amount: $e');
    }
  }

    Future<void> removeBudget(String id) async {
    await firestoreService.removeBudget(userId, id); // Replace 'userId' with the actual user ID
    state = await firestoreService.fetchBudgets(userId); // Refresh state after removal
  }

  Future<void> updateBudget(Budget updatedBudget) async {
    await firestoreService.updateBudget(userId, updatedBudget.id ?? '', updatedBudget); // Replace 'userId' with the actual user ID
    state = await firestoreService.fetchBudgets(userId); // Refresh state after update
  }

  Future<void> deleteBudget(String id) async {
    await firestoreService.removeBudget(userId, id); // Replace 'userId' with the actual user ID
    state = await firestoreService.fetchBudgets(userId); // Refresh state after deletion
  }
}
