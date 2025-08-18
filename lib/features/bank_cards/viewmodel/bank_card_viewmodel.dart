
import 'package:flutter/material.dart';
import '../model/card_model.dart';
import '../service/bank_card_service.dart';

class BankCardViewModel extends ChangeNotifier {
  final BankCardService _bankCardService = BankCardService();

  List<BankCard> _bankCards = [];
  List<BankCard> get bankCards => _bankCards;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  BankCardViewModel() {
    loadBankCards();
  }

  Future<void> loadBankCards() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _bankCards = await _bankCardService.getBankCards();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addBankCard(BankCard card) async {
    try {
      await _bankCardService.addBankCard(card);
      await loadBankCards();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> removeBankCard(String id) async {
    try {
      await _bankCardService.removeBankCard(id);
      await loadBankCards();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
