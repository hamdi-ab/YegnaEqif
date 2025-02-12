import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bank_account.dart';
import '../services/firestore_service.dart';
import 'auth_provider.dart';
import 'debt_provider.dart';

final bankAccountProvider = StateNotifierProvider<BankAccountNotifier, List<BankAccountCardModel>>((ref) {
  final currentUser = ref.watch(firebaseAuthProvider).currentUser;
  return BankAccountNotifier(ref: ref, firestoreService: ref.watch(firestoreServiceProvider), userId: currentUser?.uid ?? '');
});

class BankAccountNotifier extends StateNotifier<List<BankAccountCardModel>> {
  final Ref ref;
  final FirestoreService firestoreService;
  final String userId;


  BankAccountNotifier({required this.ref, required this.firestoreService, required this.userId}) : super([]) {
    _fetchBankAccounts();
  }

  Future<void> _fetchBankAccounts() async {
    final bankAccounts = await firestoreService.fetchBankAccounts(userId); // Replace 'userId' with the actual user ID
    state = bankAccounts;
  }

  Future<void> addBankAccount(BankAccountCardModel bankAccount) async {
    await firestoreService.addBankAccount(userId, bankAccount); // Replace 'userId' with the actual user ID
    state = await firestoreService.fetchBankAccounts(userId); // Refresh state after addition
  }

  Future<void> removeBankAccount(String id) async {
    await firestoreService.removeBankAccount(userId, id); // Replace 'userId' with the actual user ID
    state = await firestoreService.fetchBankAccounts(userId); // Refresh state after removal
  }

  Future<void> updateBankAccount(String id, BankAccountCardModel updatedBankAccount) async {
    await firestoreService.updateBankAccount(userId, id, updatedBankAccount); // Replace 'userId' with the actual user ID
    state = await firestoreService.fetchBankAccounts(userId); // Refresh state after update
  }

  // Methods to handle transactions
  void handleLentTransaction(String accountName, double amount) {
    updateBalance(accountName, amount, true); // Treat lent as income
  }

  void handleBorrowedTransaction(String accountName, double amount) {
    updateBalance(accountName, amount, false); // Treat borrowed as expense
  }

  void updateBalance(String accountName, double amount, bool isIncome) async {
    try {
      for (final card in state) {
        if (card.accountName == accountName) {
          final newBalance = card.balance + amount;
          final updatedCard = card.copyWith(balance: newBalance);

          // Update Firebase
          await firestoreService.updateBankAccount(userId, card.id ?? '', updatedCard); // Replace 'userId' with the actual user ID

          // Update local state
          state = [
            for (final card in state)
              if (card.accountName == accountName)
                updatedCard
              else
                card,
          ];
        }
      }
    } catch (e) {
      print('Error updating balance: $e');
    }
  }
}
