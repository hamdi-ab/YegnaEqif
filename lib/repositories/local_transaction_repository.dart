import '../models/transaction.dart';

class LocalTransactionRepository {
  final List<Transaction> _transactions = [
    // Groceries
    Transaction(
      id: '1',
      type: 'Expense',
      bankType: 'Credit Card',
      category: 'Groceries',
      amount: 50.00,
      date: DateTime(2024, 6, 1),
    ),
    Transaction(
      id: '2',
      type: 'Expense',
      bankType: 'Debit Card',
      category: 'Groceries',
      amount: 30.00,
      date: DateTime(2025, 1, 5),
    ),

    // Salary
    Transaction(
      id: '3',
      type: 'Income',
      bankType: 'Bank Transfer',
      category: 'Salary',
      amount: 2000.00,
      date: DateTime(2025, 1, 24),
    ),
    Transaction(
      id: '4',
      type: 'Income',
      bankType: 'Bank Transfer',
      category: 'Salary',
      amount: 2100.00,
      date: DateTime(2024, 12, 24),
    ),

    // Utilities
    Transaction(
      id: '5',
      type: 'Expense',
      bankType: 'Debit Card',
      category: 'Utilities',
      amount: 75.00,
      date: DateTime(2025, 1, 4),
    ),
    Transaction(
      id: '6',
      type: 'Expense',
      bankType: 'Debit Card',
      category: 'Utilities',
      amount: 80.00,
      date: DateTime(2024, 12, 4),
    ),

    // Transport
    Transaction(
      id: '7',
      type: 'Expense',
      bankType: 'Credit Card',
      category: 'Transport',
      amount: 20.00,
      date: DateTime(2024, 3, 5),
    ),
    Transaction(
      id: '8',
      type: 'Expense',
      bankType: 'Debit Card',
      category: 'Transport',
      amount: 25.00,
      date: DateTime(2024, 4, 5),
    ),

    // Entertainment
    Transaction(
      id: '9',
      type: 'Expense',
      bankType: 'Credit Card',
      category: 'Entertainment',
      amount: 40.00,
      date: DateTime(2024, 5, 10),
    ),
    Transaction(
      id: '10',
      type: 'Expense',
      bankType: 'Debit Card',
      category: 'Entertainment',
      amount: 50.00,
      date: DateTime(2024, 6, 10),
    ),
  ];

  Future<List<Transaction>> fetchTransactions() async {
    return _transactions;
  }

  Future<void> addTransaction(Transaction transaction) async {
    _transactions.add(transaction);
  }
}
