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

  bool _disposed = false;

  BankCardViewModel() {
    loadBankCards();
  }

  Future<void> loadBankCards() async {
    _isLoading = true;
    _error = null;
    _safeNotifyListeners();

    try {
      _bankCards = await _bankCardService.getBankCards();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      _safeNotifyListeners();
    }
  }

  void _safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  Future<void> addBankCard(BankCard card) async {
    try {
      await _bankCardService.addBankCard(card);
      await loadBankCards();
    } catch (e) {
      _error = e.toString();
      _safeNotifyListeners();
    }
  }

  Future<void> removeBankCard(String id) async {
    try {
      await _bankCardService.removeBankCard(id);
      await loadBankCards();
    } catch (e) {
      _error = e.toString();
      _safeNotifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
