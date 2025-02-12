import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/debt.dart';
import '../services/firestore_service.dart';
import 'auth_provider.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

final borrowOrDebtProvider = StateNotifierProvider<BorrowOrDebtNotifier, List<Debt>>((ref) {
  final currentUser = ref.watch(firebaseAuthProvider).currentUser;
  return BorrowOrDebtNotifier(ref: ref, firestoreService: ref.watch(firestoreServiceProvider), userId: currentUser?.uid ?? '');
});

class BorrowOrDebtNotifier extends StateNotifier<List<Debt>> {
  final Ref ref;
  final FirestoreService firestoreService;
  final String userId;

  BorrowOrDebtNotifier({required this.ref, required this.firestoreService, required this.userId}) : super([]) {
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    final transactions = await firestoreService.fetchDebts(userId); // Replace 'userId' with the actual user ID
    state = transactions;
  }

  Future<void> addTransaction(Debt transaction) async {
    await firestoreService.addDebt(userId, transaction); // Replace 'userId' with the actual user ID
    state = await firestoreService.fetchDebts(userId); // Refresh state after addition
  }

  Future<void> removeTransaction(String id) async {
    await firestoreService.removeDebt(userId, id); // Replace 'userId' with the actual user ID
    state = await firestoreService.fetchDebts(userId); // Refresh state after removal
  }

  Future<void> updateTransaction(String id, Debt updatedTransaction) async {
    await firestoreService.updateDebt(userId, id, updatedTransaction); // Replace 'userId' with the actual user ID
    state = await firestoreService.fetchDebts(userId); // Refresh state after update
  }

  Future<void> updateDebtAmount(String debtId, double amountPaid) async {
    try {
      for (final debt in state) {
        if (debt.id == debtId) {
          final newRemainingAmount = debt.remainingAmount - amountPaid;
          final newProgress = (debt.totalAmount - newRemainingAmount) / debt.totalAmount;
          final updatedDebt = debt.copyWith(remainingAmount: newRemainingAmount, progress: newProgress);

          // Update Firebase
          await firestoreService.updateDebt(userId, debtId, updatedDebt); // Replace 'userId' with the actual user ID

          // Update local state
          state = [
            for (final debt in state)
              if (debt.id == debtId)
                updatedDebt
              else
                debt,
          ];
        }
      }
    } catch (e) {
      print('Error updating debt amount: $e');
    }
  }

}
