import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../models/category.dart';  // Commented out - unused until refactored
// TODO: Refactor to use new ViewModels from features/ directory
// import '../../providers/category_provider.dart';
// import '../../providers/transaction_provider.dart';

// TODO: Refactor this widget to use new ViewModels from features/
class TopSpendingDetailPage extends ConsumerWidget {
  const TopSpendingDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Temporary placeholder until refactored to use new ViewModels
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Spending'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'This feature needs to be refactored to use new ViewModels',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );

    /* Original implementation - commented out until refactored
    final transactions = ref.watch(transactionProvider);
    final categories = ref.watch(categoryProvider);

    // Calculate spending by category and transaction count
    final Map<String, double> spendingByCategory = {};
    final Map<String, int> transactionsByCategory = {};

    for (var transaction in transactions) {
      if (transaction.type == 'Expense') {
        spendingByCategory.update(
          transaction.category,
              (value) => value + transaction.amount,
          ifAbsent: () => transaction.amount,
        );

        transactionsByCategory.update(
          transaction.category,
              (value) => value + 1,
          ifAbsent: () => 1,
        );
      }
    }

    // Sort categories by spending in descending order
    final sortedCategories = spendingByCategory.entries.map((entry) {
      final category = categories.firstWhere((category) => category.name == entry.key);
      final transactionCount = transactionsByCategory[entry.key] ?? 0;
      return {
        'category': category,
        'amount': entry.value,
        'transactionCount': transactionCount,
      };
    }).toList()
      ..sort((a, b) => (b['amount'] as double).compareTo(a['amount'] as double));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Spending'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: sortedCategories.length,
        itemBuilder: (context, index) {
          final item = sortedCategories[index];
          final category = item['category'] as Category;
          final amount = item['amount'] as double;
          final transactionCount = item['transactionCount'] as int;

          return ContainerWIthBoxShadow(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            padding: const EdgeInsets.all(16),
            child: ListTile(
              contentPadding: const EdgeInsets.all(0),
              leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: category.color,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    category.icon,
                    color: Colors.white,
                  ),
                ),
              title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          category.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Total Spent',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$transactionCount transactions',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          '${amount.toStringAsFixed(2)} Br.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
            ),
          );
        },
      ),
    );
    */
  }
}
