import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yegna_eqif_new/data/data.dart';
import 'package:yegna_eqif_new/providers/budget_provider.dart';
import 'package:yegna_eqif_new/providers/category_provider.dart';
import 'package:yegna_eqif_new/providers/time_period_provider.dart';
import 'package:yegna_eqif_new/providers/transaction_provider.dart';

import '../models/category.dart';
import '../models/transaction.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              ProfileBalance(),
              const SizedBox(height: 20),
              TotalBalanceCard(data: totalBalanceData),
              const SizedBox(height: 20),
              SectionWithHeader(
                title: 'Top Spending',
                leftText: 'View All',
                viewAllCallback: () {},
                child: const TopSpending(),
              ),
              SectionWithHeader(
                title: 'Monthly Budget',
                leftText: 'View All',
                viewAllCallback: () {},
                child:  MonthlyBudget(),
              ),
              SectionWithHeader(
                title: 'People You Owe',
                leftText: 'View All',
                viewAllCallback: () {},
                child: PeopleList(data: peopleYouOweData, isOwed: false),
              ),
              SectionWithHeader(
                title: 'People Who Owe You',
                leftText: 'View All',
                viewAllCallback: () {},
                child: PeopleList(data: peopleWhoOweYou, isOwed: true),
              ),
              SectionWithHeader(
                title: 'Recent Transaction',
                leftText: 'View All',
                viewAllCallback: () {},
                child: const RecentTransaction(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileBalance extends StatelessWidget {
  final double health = 75.0;

  const ProfileBalance({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.yellow[700],
                child: Icon(
                  CupertinoIcons.person_fill,
                  color: Colors.yellow[900],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hamdi Abdulfetah',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: ProgressBar(
                      value: health,
                      maxValue: 100,
                      label: "${health.toStringAsFixed(0)}/100",
                    ),
                  ),
                ],
              )
            ],
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
        ],
      ),
    );
  }
}

class ProgressBar extends StatelessWidget {
  final double value;
  final double maxValue;
  final String label;

  const ProgressBar({super.key,
    required this.value,
    required this.maxValue,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 100,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(6),
          ),
          child: FractionallySizedBox(
            widthFactor: value / maxValue,
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: value > 50
                    ? Colors.green
                    : (value > 20 ? Colors.yellow : Colors.red),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class SectionWithHeader extends StatelessWidget {
  final String title;
  final String leftText;
  final VoidCallback viewAllCallback;
  final Widget child;

  const SectionWithHeader({super.key,
    required this.title,
    required this.viewAllCallback,
    required this.child, required this.leftText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              GestureDetector(
                onTap: viewAllCallback,
                child: Text(
                  leftText,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class PeopleList extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final bool isOwed;

  const PeopleList({super.key, required this.data, required this.isOwed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          return Container(
            width: 110,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.13), // Darker shadow
                  blurRadius: 15, // Increased blur for smoother shadow edges
                  spreadRadius: 2, // Slight spread for better visibility
                  offset: const Offset(0, 4), // Adjust offset to balance top and bottom shadows
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.05), // Lighter shadow for subtle effect
                  blurRadius: 10,
                  spreadRadius: -1,
                  offset: const Offset(0, -3), // Slight upward shadow to enhance the top edge
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: item['backgroundColor'],
                  child: Icon(
                    item['icon'],
                    color: item['color'],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item['name'],
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                Text(
                  isOwed
                      ? '+\$${item['amountOwed']}'
                      : '-\$${item['moneyOwed']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: isOwed ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class TotalBalanceCard extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const TotalBalanceCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.9, initialPage: 1),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
            child: CardWidget(
              totalBalance: item['totalBalance'],
              income: item['income'],
              expense: item['expense'],
              cardColor: item['color'],
            ),
          );
        },
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final double totalBalance;
  final double income;
  final double expense;
  final Color cardColor;

  const CardWidget({
    Key? key,
    required this.totalBalance,
    required this.income,
    required this.expense,
    required this.cardColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width / 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          colors: [
            cardColor.withOpacity(0.9),
            cardColor.withOpacity(0.7),
            cardColor,
          ],
          transform: const GradientRotation(pi / 4),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.grey.shade300,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Total Balance',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "\$${totalBalance.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoRow(
                  icon: CupertinoIcons.arrow_down,
                  label: 'Income',
                  value: income,
                  iconColor: Colors.green,
                ),
                _buildInfoRow(
                  icon: CupertinoIcons.arrow_up,
                  label: 'Expense',
                  value: expense,
                  iconColor: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required double value,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          width: 25,
          height: 25,
          decoration: const BoxDecoration(
            color: Colors.white30,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              icon,
              size: 12,
              color: iconColor,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              "\$${value.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}


class TopSpending extends ConsumerWidget {
  const TopSpending({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionProvider);
    final categories = ref.watch(categoryProvider);

    // Calculate spending by category
    final Map<String, double> spendingByCategory = {};

    for (var transactionData in transactions) {
      final transaction = transactionData['transaction'] as Transaction;
      if (transaction.type == 'Expense') {
        spendingByCategory.update(transaction.category, (value) => value + transaction.amount,
            ifAbsent: () => transaction.amount);
      }
    }

    // Sort categories by spending in descending order
    final sortedCategories = spendingByCategory.entries
        .map((entry) {
      final category = categories.firstWhere((category) => category.name == entry.key);
      return {
        'category': category,
        'amount': entry.value,
      };
    })
        .toList()
      ..sort((a, b) => (b['amount'] as double).compareTo(a['amount'] as double));

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: sortedCategories.length,
        itemBuilder: (context, index) {
          final item = sortedCategories[index];
          final category = item['category'] as Category;
          final amount = item['amount'] as double;

          return Container(
            width: 110,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12), // Darker shadow
                  blurRadius: 10, // Increased blur for smoother shadow edges
                  spreadRadius: 1, // Slight spread for better visibility
                  offset: const Offset(0, 4), // Adjust offset to balance top and bottom shadows
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.05), // Lighter shadow for subtle effect
                  blurRadius: 10,
                  spreadRadius: -1,
                  offset: const Offset(0, -2), // Slight upward shadow to enhance the top edge
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: category.color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    category.icon,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  category.name,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${amount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.red),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}



class MonthlyBudget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final budgets = ref.watch(budgetProvider);
    final categories = ref.watch(categoryProvider);

    // Helper function to get category details
    Category getCategoryDetails(String categoryId) {
      return categories.firstWhere(
            (cat) => cat.id == categoryId,
        orElse: () => Category(id: '', name: 'Unknown', icon: Icons.category, color: Colors.grey),
      );
    }

    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          final budget = budgets[index];
          final category = getCategoryDetails(budget.categoryId);
          final double progress = budget.spentAmount / budget.allocatedAmount;
          final Color progressColor = category.color;

          return Container(
            width: 230,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10.0),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12), // Darker shadow
                  blurRadius: 10, // Increased blur for smoother shadow edges
                  spreadRadius: 1, // Slight spread for better visibility
                  offset: const Offset(0, 4), // Adjust offset to balance top and bottom shadows
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.05), // Lighter shadow for subtle effect
                  blurRadius: 10,
                  spreadRadius: -1,
                  offset: const Offset(0, -2), // Slight upward shadow to enhance the top edge
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon and Label Row
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: progressColor.withOpacity(0.1),
                      child: Icon(
                        category.icon,
                        color: progressColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$${budget.allocatedAmount.toStringAsFixed(0)} total',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Progress Bar with Labels Inside
                Stack(
                  children: [
                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        minHeight: 24,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progressColor,
                        ),
                      ),
                    ),
                    // Labels Inside Progress Bar
                    Positioned.fill(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              '\$${(budget.spentAmount).toStringAsFixed(0)} ',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              '\$${budget.allocatedAmount}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class RecentTransaction extends ConsumerWidget {
  const RecentTransaction({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsWithCategoryDetails = ref.watch(transactionProvider);
    final selectedTimePeriod = ref.watch(timePeriodProvider);

    // Filter the transactions based on the selected time period
    final filteredTransactions = transactionsWithCategoryDetails.where((transactionData) {
      final transaction = transactionData['transaction'] as Transaction;
      final now = DateTime.now();
      switch (selectedTimePeriod) {
        case TimePeriod.week:
          return transaction.date.isAfter(now.subtract(Duration(days: 7)));
        case TimePeriod.month:
          return transaction.date.isAfter(now.subtract(Duration(days: 30)));
        case TimePeriod.year:
          return transaction.date.isAfter(now.subtract(Duration(days: 365)));
        default:
          return true;
      }
    }).toList();

    print('Rendering transactions: $filteredTransactions');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredTransactions.length,
          itemBuilder: (context, index) {
            final transactionData = filteredTransactions[index];
            final transaction = transactionData['transaction'] as Transaction;
            final categoryIcon = transactionData['icon'] as IconData;
            final categoryColor = transactionData['color'] as Color;
            final amountColor = transaction.type == 'Income' ? Colors.green : Colors.red;

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    spreadRadius: -1,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: categoryColor,
                  child: Icon(categoryIcon, color: Colors.white),
                ),
                title: Text(transaction.category),
                subtitle: Text(transaction.bankType),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '\$${transaction.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: amountColor,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${transaction.date.year}-${transaction.date.month}-${transaction.date.day}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}









