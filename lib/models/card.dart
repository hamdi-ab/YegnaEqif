import 'dart:ui';

class CashCardModel {
  final double balance;
  final Color cardColor;

  CashCardModel({required this.balance, required this.cardColor});
}

class TotalBalanceCardModel {
  final double totalBalance;
  final double income;
  final double expense;
  final Color cardColor;

  TotalBalanceCardModel({
    required this.totalBalance,
    required this.income,
    required this.expense,
    required this.cardColor,
  });
}

class BankAccountCardModel {
  final String id;
  final String accountName;
  final String accountNumber;
  final double balance;
  final Color cardColor;

  BankAccountCardModel({
    required this.id,
    required this.accountName,
    required this.accountNumber,
    required this.balance,
    required this.cardColor,
  });
}
