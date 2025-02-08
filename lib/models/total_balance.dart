import 'dart:ui';

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

  factory TotalBalanceCardModel.fromMap(Map<String, dynamic> data) {
    return TotalBalanceCardModel(
      totalBalance: data['totalBalance'],
      income: data['income'],
      expense: data['expense'],
      cardColor: Color(data['cardColor']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalBalance': totalBalance,
      'income': income,
      'expense': expense,
      'cardColor': cardColor.value,
    };
  }

  TotalBalanceCardModel copyWith({
    double? totalBalance,
    double? income,
    double? expense,
    Color? cardColor,
  }) {
    return TotalBalanceCardModel(
      totalBalance: totalBalance ?? this.totalBalance,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      cardColor: cardColor ?? this.cardColor,
    );
  }
}
