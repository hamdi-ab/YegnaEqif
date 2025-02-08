import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yegna_eqif_new/models/transaction.dart';
import '../models/debt.dart';
import '../services/firestore_service.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

final borrowOrDebtProvider = StateNotifierProvider<BorrowOrDebtNotifier, List<Debt>>((ref) {
  return BorrowOrDebtNotifier(ref: ref, firestoreService: ref.watch(firestoreServiceProvider));
});

class BorrowOrDebtNotifier extends StateNotifier<List<Debt>> {
  final Ref ref;
  final FirestoreService firestoreService;

  BorrowOrDebtNotifier({required this.ref, required this.firestoreService}) : super([]) {
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    final transactions = await firestoreService.fetchDebts('userId'); // Replace 'userId' with the actual user ID
    state = transactions;
  }

  Future<void> addTransaction(Debt transaction) async {
    await firestoreService.addDebt('userId', transaction); // Replace 'userId' with the actual user ID
    state = await firestoreService.fetchDebts('userId'); // Refresh state after addition
  }

  Future<void> removeTransaction(String id) async {
    await firestoreService.removeTransaction('userId', id); // Replace 'userId' with the actual user ID
    state = await firestoreService.fetchDebts('userId'); // Refresh state after removal
  }

  Future<void> updateTransaction(String id, Debt updatedTransaction) async {
    await firestoreService.updateTransaction('userId', id, updatedTransaction as Transaction); // Replace 'userId' with the actual user ID
    state = await firestoreService.fetchDebts('userId'); // Refresh state after update
  }
}
