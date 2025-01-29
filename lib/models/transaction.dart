import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  final String id;
  final String type;
  final String bankType;
  final String category;
  final double amount;
  final DateTime date;

  Transaction({
    required this.id,
    required this.type,
    required this.bankType,
    required this.category,
    required this.amount,
    required this.date,
  });

  factory Transaction.fromMap(Map<String, dynamic> data, String documentId) {
    return Transaction(
      id: documentId,
      type: data['type'],
      bankType: data['bankType'],
      category: data['category'],
      amount: data['amount'],
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'bankType': bankType,
      'category': category,
      'amount': amount,
      'date': date,
    };
  }
}
