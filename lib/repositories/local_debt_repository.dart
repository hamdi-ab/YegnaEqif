import '../models/debt.dart';

class LocalDebtRepository {
  // Initialize with some sample data
  List<Debt> _borrowOrDebtList = [
    Debt(
      id: '1',
      personName: 'Person 1',
      remainingAmount: 75.0,
      totalAmount: 150.0,
      bankType: 'cash',
      dueDate: DateTime(2025, 4, 5),
      progress: 0.33,
      transactionType: 'lent',
    ),
    Debt(
      id: '2',
      personName: 'Person 2',
      remainingAmount: 50.0,
      totalAmount: 100.0,
      bankType: 'cash',
      dueDate: DateTime(2025, 5, 5),
      progress: 0.50,
      transactionType: 'borrowed',
    ),
    Debt(
      id: '3',
      personName: 'Person 3',
      remainingAmount: 125.0,
      totalAmount: 200.0,
      bankType: 'cash',
      dueDate: DateTime(2025, 4, 6),
      progress: 0.75,
      transactionType: 'lent',
    ),
  ];

  List<Debt> fetchTransactions() {
    return _borrowOrDebtList;
  }

  Debt fetchTransactionById(String id) {
    return _borrowOrDebtList.firstWhere((transaction) => transaction.id == id);
  }

  void addTransaction(Debt transaction) {
    _borrowOrDebtList.add(transaction);
  }

  void removeTransaction(String id) {
    _borrowOrDebtList.removeWhere((transaction) => transaction.id == id);
  }

  void updateTransaction(String id, Debt updatedTransaction) {
    final index = _borrowOrDebtList.indexWhere((transaction) => transaction.id == id);
    if (index != -1) {
      _borrowOrDebtList[index] = updatedTransaction;
    }
  }
}
