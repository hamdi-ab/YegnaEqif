import 'package:flutter/foundation.dart';
import 'package:yegna_eqif_new/models/debt.dart'; // Assuming Debt model is available

class DebtViewModel extends ChangeNotifier {
  final List<Debt> _debts = [];
  bool _disposed = false;

  List<Debt> get debts => _debts;

  List<Debt> get lentDebts =>
      _debts.where((debt) => debt.transactionType == 'lent').toList();
  List<Debt> get borrowedDebts =>
      _debts.where((debt) => debt.transactionType == 'borrowed').toList();

  double get totalLentAmount =>
      lentDebts.fold(0.0, (sum, debt) => sum + debt.totalAmount);
  double get totalOwedAmount =>
      borrowedDebts.fold(0.0, (sum, debt) => sum + debt.totalAmount);

  int get lentPeopleCount => lentDebts.length;
  int get borrowedPeopleCount => borrowedDebts.length;

  void addDebt(Debt debt) {
    _debts.add(debt);
    _safeNotifyListeners();
  }

  void _safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  void removeDebt(String debtId) {
    _debts.removeWhere((debt) => debt.id == debtId);
    _safeNotifyListeners();
  }

  void updateDebt(String debtId, Debt updatedDebt) {
    final debtIndex = _debts.indexWhere((debt) => debt.id == debtId);
    if (debtIndex != -1) {
      _debts[debtIndex] = updatedDebt;
      _safeNotifyListeners();
    }
  }

  Future<void> adjustDebtWhenSomeonePays(String debtId, double amount) async {
    final debtIndex = _debts.indexWhere((debt) => debt.id == debtId);
    if (debtIndex != -1) {
      _debts[debtIndex] = _debts[debtIndex].copyWith(
        remainingAmount: _debts[debtIndex].remainingAmount - amount,
      );
      _safeNotifyListeners();
    }
  }

  Future<void> adjustDebtWhenYouPay(String debtId, double amount) async {
    final debtIndex = _debts.indexWhere((debt) => debt.id == debtId);
    if (debtIndex != -1) {
      _debts[debtIndex] = _debts[debtIndex].copyWith(
        remainingAmount: _debts[debtIndex].remainingAmount - amount,
      );
      _safeNotifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  // TODO: Implement other debt-related state and logic here, e.g., fetching from a service
}
