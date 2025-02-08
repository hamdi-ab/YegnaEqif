import 'dart:ui';

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

  factory BankAccountCardModel.fromMap(Map<String, dynamic> data) {
    return BankAccountCardModel(
      id: data['id'],
      accountName: data['accountName'],
      accountNumber: data['accountNumber'],
      balance: data['balance'],
      cardColor: Color(data['cardColor']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'accountName': accountName,
      'accountNumber': accountNumber,
      'balance': balance,
      'cardColor': cardColor.value,
    };
  }

  BankAccountCardModel copyWith({
    String? id,
    String? accountName,
    String? accountNumber,
    double? balance,
    Color? cardColor,
  }) {
    return BankAccountCardModel(
      id: id ?? this.id,
      accountName: accountName ?? this.accountName,
      accountNumber: accountNumber ?? this.accountNumber,
      balance: balance ?? this.balance,
      cardColor: cardColor ?? this.cardColor,
    );
  }
}
