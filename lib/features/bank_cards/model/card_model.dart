
import 'package:flutter/material.dart';

class BankCard {
  final String id;
  final String accountName;
  final String accountNumber;
  final double balance;
  final Color cardColor;

  BankCard({
    required this.id,
    required this.accountName,
    required this.accountNumber,
    required this.balance,
    required this.cardColor,
  });
}
