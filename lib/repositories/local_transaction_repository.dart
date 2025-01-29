import '../models/transaction.dart';

class LocalTransactionRepository {
  List<Transaction> _transactions = [
    Transaction(
      id: '1',
      type: 'Expense',
      bankType: 'Credit Card',
      category: 'Groceries',
      amount: 50.00,
      date: DateTime(2023, 4, 1),
    ),
    Transaction(
      id: '2',
      type: 'Income',
      bankType: 'Bank Transfer',
      category: 'Salary',
      amount: 2000.00,
      date: DateTime(2023, 4, 1),
    ),
    Transaction(
      id: '3',
      type: 'Expense',
      bankType: 'Debit Card',
      category: 'Utilities',
      amount: 75.00,
      date: DateTime(2023, 4, 2),
    ),
    // Add more transactions as needed
  ];

  Future<List<Transaction>> fetchTransactions() async {
    return _transactions;
  }

  Future<void> addTransaction(Transaction transaction) async {
    _transactions.add(transaction);
  }
}
