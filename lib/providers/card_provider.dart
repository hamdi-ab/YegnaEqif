import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/card.dart';
import '../repositories/local_card_repository.dart';

final cashCardProvider = StateProvider<CashCardModel>((ref) {
  return cashCard;
});

final totalBalanceCardProvider = StateProvider<TotalBalanceCardModel>((ref) {
  return totalBalanceCard;
});

final bankAccountCardsProvider = StateNotifierProvider<BankAccountCardsNotifier, List<BankAccountCardModel>>((ref) {
  return BankAccountCardsNotifier();
});

class BankAccountCardsNotifier extends StateNotifier<List<BankAccountCardModel>> {
  BankAccountCardsNotifier() : super(bankAccountCards);

  void addBankAccount(BankAccountCardModel bankAccount) {
    state = [...state, bankAccount];
  }
}
