import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction.dart';
import '../services/firestore_service.dart';
import 'category_provider.dart';

final transactionProvider = StateNotifierProvider<TransactionNotifier, List<Transaction>>((ref) {
  return TransactionNotifier(ref: ref, firestoreService: ref.watch(firestoreServiceProvider));
});

class TransactionNotifier extends StateNotifier<List<Transaction>> {
  final Ref ref;
  final FirestoreService firestoreService;

  TransactionNotifier({required this.ref, required this.firestoreService}) : super([]) {
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    final transactions = await firestoreService.fetchTransactions('userId'); // Replace 'userId' with the actual user ID
    state = transactions;
  }

  Future<void> addTransaction(Transaction transaction) async {
    await firestoreService.addTransaction('userId', transaction); // Replace 'userId' with the actual user ID
    state = await firestoreService.fetchTransactions('userId'); // Refresh state after addition
  }

  Future<void> removeTransaction(String id) async {
    await firestoreService.removeTransaction('userId', id); // Replace 'userId' with the actual user ID
    state = await firestoreService.fetchTransactions('userId'); // Refresh state after removal
  }

  Future<void> updateTransaction(String id, Transaction updatedTransaction) async {
    await firestoreService.updateTransaction('userId', id, updatedTransaction); // Replace 'userId' with the actual user ID
    state = await firestoreService.fetchTransactions('userId'); // Refresh state after update
  }
}
