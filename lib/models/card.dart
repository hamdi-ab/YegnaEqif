// import 'dart:ui';
//
// // CashCardModel
// class CashCardModel {
//   final double balance;
//   final Color cardColor;
//
//   CashCardModel({required this.balance, required this.cardColor});
//
//   CashCardModel copyWith({
//     double? balance,
//     Color? cardColor,
//   }) {
//     return CashCardModel(
//       balance: balance ?? this.balance,
//       cardColor: cardColor ?? this.cardColor,
//     );
//   }
// }
//
//
// // TotalBalanceCardModel
// class TotalBalanceCardModel {
//   final double totalBalance;
//   final double income;
//   final double expense;
//   final Color cardColor;
//
//   TotalBalanceCardModel({
//     required this.totalBalance,
//     required this.income,
//     required this.expense,
//     required this.cardColor,
//   });
//
//   TotalBalanceCardModel copyWith({
//     double? totalBalance,
//     double? income,
//     double? expense,
//     Color? cardColor,
//   }) {
//     return TotalBalanceCardModel(
//       totalBalance: totalBalance ?? this.totalBalance,
//       income: income ?? this.income,
//       expense: expense ?? this.expense,
//       cardColor: cardColor ?? this.cardColor,
//     );
//   }
// }
//
// // BankAccountCardModel
// class BankAccountCardModel {
//   final String id;
//   final String accountName;
//   final String accountNumber;
//   final double balance;
//   final Color cardColor;
//
//   BankAccountCardModel({
//     required this.id,
//     required this.accountName,
//     required this.accountNumber,
//     required this.balance,
//     required this.cardColor,
//   });
//
//   BankAccountCardModel copyWith({
//     String? id,
//     String? accountName,
//     String? accountNumber,
//     double? balance,
//     Color? cardColor,
//   }) {
//     return BankAccountCardModel(
//       id: id ?? this.id,
//       accountName: accountName ?? this.accountName,
//       accountNumber: accountNumber ?? this.accountNumber,
//       balance: balance ?? this.balance,
//       cardColor: cardColor ?? this.cardColor,
//     );
//   }
// }
//
