import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/bank_account_provider.dart';
import '../providers/cash_card_provider.dart';
import '../providers/debt_provider.dart';
import '../providers/total_balance_card_provider.dart';

class TransactionHandler {
  final WidgetRef ref;

  TransactionHandler({required this.ref});

  void handleTransaction(String accountName, double amount, String type) async {
    // Determine if it's income or expense
    bool isIncome = type == 'Income';
    final amountToUpdate = isIncome ? amount : -amount;
    // Update cash card balance if the account name is 'Cash'
    if (accountName == 'Cash') {
      final cashCardNotifier = ref.read(cashCardProvider.notifier);
      await cashCardNotifier.updateCashCardBalance(amountToUpdate);
    } else {
      // Update bank account balance
      final bankCardNotifier = ref.read(bankAccountProvider.notifier);
      bankCardNotifier.updateBalance(accountName, amountToUpdate, isIncome);
    }

    // Update total balance
    final totalBalanceNotifier = ref.read(totalBalanceCardProvider.notifier);
    await totalBalanceNotifier.updateTotalBalance(amountToUpdate, isIncome);
  }

  void handleLendingAndBorrowing(String accountName, double amount, bool isLending) async {// Lending is an expense, borrowing is income
    handleTransaction(accountName, amount, isLending ? 'Expense' : 'Income');
  }

  // When someone pays you back
  Future<void> adjustDebtWhenSomeonePays(String debtId, double amountPaid) async {
    await ref.read(borrowOrDebtProvider.notifier).updateDebtAmount(debtId, amountPaid);
  }

// When you pay someone back
  Future<void> adjustDebtWhenYouPay(String debtId, double amountPaid) async {
    await ref.read(borrowOrDebtProvider.notifier).updateDebtAmount(debtId, amountPaid);
  }


}
