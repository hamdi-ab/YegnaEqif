import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cash_card.dart';
import '../services/local_storage_service.dart';

final cashCardProvider = StateNotifierProvider<CashCardNotifier, CashCardModel>((ref) {
  return CashCardNotifier(ref: ref);
});

class CashCardNotifier extends StateNotifier<CashCardModel> {
  final Ref ref;

  CashCardNotifier({required this.ref})
      : super(CashCardModel(balance: 0.0, cardColor: Color(0x85bb65))) {
    _loadCashCard();
  }

  Future<void> _loadCashCard() async {
    final balance = await LocalStorageService.getCashCardBalance();
    final colorHex = await LocalStorageService.getCashCardColor();
    final cardColor = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
    state = CashCardModel(balance: balance, cardColor: cardColor);
  }

  Future<void> updateCashCardBalance(double amount) async {
    state = state.copyWith(balance: state.balance + amount);
    await LocalStorageService.saveCashCardBalance(state.balance);
  }

  Future<void> updateCashCardColor(Color color) async {
    final colorHex = '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
    state = state.copyWith(cardColor: color);
    await LocalStorageService.saveCashCardColor(colorHex);
  }
}
