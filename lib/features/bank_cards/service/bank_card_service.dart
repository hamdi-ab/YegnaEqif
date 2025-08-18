
import 'package:flutter/material.dart';
import '../model/card_model.dart';

class BankCardService {
  final List<BankCard> _bankCards = [
    BankCard(
      id: '1',
      accountName: 'Bank of Wonderland',
      accountNumber: '12345678',
      balance: 8000.00,
      cardColor: Colors.black,
    ),
  ];

  Future<List<BankCard>> getBankCards() async {
    // In a real app, you would fetch this from a database or API
    return Future.value(_bankCards);
  }

  Future<void> addBankCard(BankCard card) async {
    // In a real app, you would save this to a database or API
    _bankCards.add(card);
  }

  Future<void> removeBankCard(String id) async {
    // In a real app, you would delete this from a database or API
    _bankCards.removeWhere((card) => card.id == id);
  }
}
