import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/total_balance.dart';
import '../services/local_storage_service.dart';

final totalBalanceCardProvider = StateNotifierProvider<TotalBalanceCardNotifier, TotalBalanceCardModel>((ref) {
  return TotalBalanceCardNotifier(ref: ref);
});

class TotalBalanceCardNotifier extends StateNotifier<TotalBalanceCardModel> {
  final Ref ref;

  TotalBalanceCardNotifier({required this.ref})
      : super(TotalBalanceCardModel(totalBalance: 0.0, income: 0.0, expense: 0.0, cardColor: Color(0xFF0000FF))) {
    _loadTotalBalance();
  }

  Future<void> _loadTotalBalance() async {
    // Load the total balance, income, expense, and card color from local storage or initialize with default values.
    final totalBalance = await LocalStorageService.getTotalBalance();
    final colorHex = await LocalStorageService.getTotalBalanceColor();
    final cardColor = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));

    state = state.copyWith(totalBalance: totalBalance, cardColor: cardColor);
  }

  Future<void> updateTotalBalance(double amount, bool isIncome) async {
    final newIncome = isIncome ? state.income + amount : state.income;
    final newExpense = !isIncome ? state.expense + amount : state.expense;
    final newTotalBalance = state.totalBalance + amount;

    state = state.copyWith(income: newIncome, expense: newExpense, totalBalance: newTotalBalance);
    await LocalStorageService.saveTotalBalance(newTotalBalance);
  }

  Future<void> updateTotalBalanceColor(Color color) async {
    final colorHex = '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
    state = state.copyWith(cardColor: color);
    await LocalStorageService.saveTotalBalanceColor(colorHex);
  }
}
