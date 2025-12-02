import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/budget.dart';
import '../../../services/firestore_service.dart';
import 'package:yegna_eqif_new/core/utils/app_logger.dart';

// Provider for FirestoreService
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

final budgetProvider =
    StateNotifierProvider<BudgetNotifier, List<Budget>>((ref) {
  final currentUser = FirebaseAuth.instance.currentUser;
  return BudgetNotifier(
      userId: currentUser?.uid ?? '',
      ref: ref,
      firestoreService: ref.watch(firestoreServiceProvider));
});

class BudgetNotifier extends StateNotifier<List<Budget>> {
  final Ref ref;
  final FirestoreService firestoreService;
  final String userId;

  BudgetNotifier(
      {required this.userId, required this.ref, required this.firestoreService})
      : super([]) {
    _fetchBudgets();
  }

  Future<void> _fetchBudgets() async {
    final budgets = await firestoreService.fetchBudgets(userId);
    state = budgets;
  }

  Future<void> addBudget(Budget budget) async {
    await firestoreService.addBudget(userId, budget);
    state = await firestoreService.fetchBudgets(userId);
  }

  Future<void> updateSpentAmount(String category, double amount) async {
    try {
      for (final budget in state) {
        if (budget.category == category) {
          final updatedBudget =
              budget.copyWith(spentAmount: budget.spentAmount + amount);
          await firestoreService.updateBudget(userId, budget.id, updatedBudget);
        }
      }
      // Refresh state after update
      state = await firestoreService.fetchBudgets(userId);
    } catch (e) {
      // Handle errors if any
      // ignore: avoid_print
      AppLogger.error('Error updating spent amount', e);
    }
  }

  Future<void> removeBudget(String id) async {
    await firestoreService.removeBudget(userId, id);
    state = await firestoreService.fetchBudgets(userId);
  }

  Future<void> updateBudget(Budget updatedBudget) async {
    await firestoreService.updateBudget(
        userId, updatedBudget.id, updatedBudget);
    state = await firestoreService.fetchBudgets(userId);
  }

  Future<void> deleteBudget(String id) async {
    await firestoreService.removeBudget(userId, id);
    state = await firestoreService.fetchBudgets(userId);
  }
}
