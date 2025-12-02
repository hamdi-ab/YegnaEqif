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

  TransactionViewModel() {
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _transactions = await _transactionRepository.fetchTransactions();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    try {
      await _transactionRepository.addTransaction(transaction);
      await loadTransactions(); // Refresh the list
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateTransaction(String id, Transaction transaction) async {
    try {
      await _transactionRepository.updateTransaction(id, transaction);
      await loadTransactions(); // Refresh the list
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> removeTransaction(String id) async {
    try {
      await _transactionRepository.removeTransaction(id);
      await loadTransactions(); // Refresh the list
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    // Clean up resources
    super.dispose();
  }
}
