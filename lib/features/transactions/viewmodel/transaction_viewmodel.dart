import 'package:flutter/material.dart';
import '../model/transaction.dart';
import '../service/local_transaction_repository.dart';

class TransactionViewModel extends ChangeNotifier {
  final LocalTransactionRepository _transactionRepository =
      LocalTransactionRepository();

  List<Transaction> _transactions = [];
  List<Transaction> get transactions => _transactions;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  bool _disposed = false;

  TransactionViewModel() {
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    _isLoading = true;
    _error = null;
    _safeNotifyListeners();

    try {
      _transactions = await _transactionRepository.fetchTransactions();
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

  Future<void> addTransaction(Transaction transaction) async {
    try {
      await _transactionRepository.addTransaction(transaction);
      await loadTransactions(); // Refresh the list
    } catch (e) {
      _error = e.toString();
      _safeNotifyListeners();
    }
  }

  Future<void> updateTransaction(String id, Transaction transaction) async {
    try {
      await _transactionRepository.updateTransaction(id, transaction);
      await loadTransactions(); // Refresh the list
    } catch (e) {
      _error = e.toString();
      _safeNotifyListeners();
    }
  }

  Future<void> removeTransaction(String id) async {
    try {
      await _transactionRepository.removeTransaction(id);
      await loadTransactions(); // Refresh the list
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
