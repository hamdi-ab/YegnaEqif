import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../repositories/local_transaction_repository.dart';
import '../repositories/local_category_repository.dart';
import 'category_provider.dart';

final localTransactionRepositoryProvider = Provider<LocalTransactionRepository>((ref) {
  return LocalTransactionRepository();
});


final transactionProvider = StateNotifierProvider<TransactionNotifier, List<Map<String, dynamic>>>((ref) {
  final transactionRepository = ref.read(localTransactionRepositoryProvider);
  final categoryRepository = ref.read(localCategoryRepositoryProvider);
  return TransactionNotifier(transactionRepository, categoryRepository);
});

class TransactionNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final LocalTransactionRepository transactionRepository;
  final LocalCategoryRepository categoryRepository;

  TransactionNotifier(this.transactionRepository, this.categoryRepository) : super([]) {
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    print('Fetching transactions...');
    final transactions = await transactionRepository.fetchTransactions();
    final categories = await categoryRepository.fetchCategories();

    final updatedTransactions = transactions.map((transaction) {
      final categoryDetails = categories.firstWhere(
            (category) => category.name == transaction.category,
        orElse: () => Category(id: '', name: '', icon: Icons.category, color: Colors.grey),
      );

      return {
        'transaction': transaction,
        'icon': categoryDetails.icon,
        'color': categoryDetails.color,
      };
    }).toList();

    print('Fetched and updated transactions: $updatedTransactions');
    state = updatedTransactions;
  }

  Future<void> addTransaction(Transaction transaction) async {
    await transactionRepository.addTransaction(transaction);
    state = [...state, {
      'transaction': transaction,
      'icon': Icons.category, // Default icon
      'color': Colors.grey, // Default color
    }];
    print('Added transaction: $transaction');
  }
}
