import 'dart:ui';

class CashCardModel {
  final double balance;
  final Color cardColor;

  CashCardModel({required this.balance, required this.cardColor});

  factory CashCardModel.fromMap(Map<String, dynamic> data) {
    return CashCardModel(
      balance: data['balance'],
      cardColor: Color(data['cardColor']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'balance': balance,
      'cardColor': cardColor.value,
    };
  }

  CashCardModel copyWith({
    double? balance,
    Color? cardColor,
  }) {
    return CashCardModel(
      balance: balance ?? this.balance,
      cardColor: cardColor ?? this.cardColor,
    );
  }
}
