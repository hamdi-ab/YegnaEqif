import 'package:cloud_firestore/cloud_firestore.dart';

class Debt {
  final String id;
  final String personName;
  final double remainingAmount;
  final double totalAmount;
  final String bankType;
  final DateTime dueDate;
  final double progress;
  final String transactionType;

  Debt({
    required this.id,
    required this.personName,
    required this.remainingAmount,
    required this.totalAmount,
    required this.bankType,
    required this.dueDate,
    required this.progress,
    required this.transactionType,
  });

  int get daysLeft {
    final currentDate = DateTime.now();
    return dueDate.difference(currentDate).inDays;
  }

  factory Debt.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Debt(
      id: doc.id,
      personName: data['personName'],
      remainingAmount: data['remainingAmount'],
      totalAmount: data['totalAmount'],
      bankType: data['bankType'],
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      progress: data['progress'],
      transactionType: data['transactionType'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'personName': personName,
      'remainingAmount': remainingAmount,
      'totalAmount': totalAmount,
      'bankType': bankType,
      'dueDate': dueDate,
      'progress': progress,
      'transactionType': transactionType,
    };
  }

  Debt copyWith({
    String? id,
    String? personName,
    double? remainingAmount,
    double? totalAmount,
    String? bankType,
    DateTime? dueDate,
    double? progress,
    String? transactionType,
  }) {
    return Debt(
      id: id ?? this.id,
      personName: personName ?? this.personName,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      bankType: bankType ?? this.bankType,
      dueDate: dueDate ?? this.dueDate,
      progress: progress ?? this.progress,
      transactionType: transactionType ?? this.transactionType,
    );
  }
}
