
import 'dart:math';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yegna_eqif_new/features/budget/viewmodel/budget_viewmodel.dart';
import 'package:yegna_eqif_new/features/transactions/viewmodel/transaction_viewmodel.dart';
// import 'package:yegna_eqif_new/providers/bank_account_provider.dart'; // TODO: Refactor
// import 'package:yegna_eqif_new/providers/cash_card_provider.dart'; // TODO: Refactor
// import 'package:yegna_eqif_new/providers/category_provider.dart'; // TODO: Refactor
// import 'package:yegna_eqif_new/providers/time_period_provider.dart'; // TODO: Refactor
// import 'package:yegna_eqif_new/providers/total_balance_card_provider.dart'; // TODO: Refactor
import 'package:yegna_eqif_new/screens/profile_page.dart';
import 'package:yegna_eqif_new/screens/setting_page.dart';
import 'package:intl/intl.dart';
import 'package:yegna_eqif_new/screens/dashboard/top_spending_detail_page.dart';
import '../../models/category.dart';
import 'package:yegna_eqif_new/features/transactions/model/transaction.dart';
// import '../../providers/debt_provider.dart'; // TODO: Refactor
import '../../utils/string_formater.dart';
import '../budget/budget_screen.dart';

class DashboardScreen extends StatelessWidget {
  final PageController _pageController = PageController(initialPage: 1);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          children: [
            ProfilePage(),
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  ProfileBalance(),
                  const SizedBox(height: 20),
                  // TotalBalanceCard(), // TODO: Refactor
                  const SizedBox(height: 20),
                  SectionWithHeader(
                    title: 'Top Spending',
                    leftText: 'View All',
                    viewAllCallback: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TopSpendingDetailPage(),
                        ),
                      );
                    },
                    child: const TopSpending(),
                  ),
                  SectionWithHeader(
                    title: 'Monthly Budget',
                    leftText: 'View All',
                    viewAllCallback: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BudgetScreen(scrollToMonthlyBudget: true),
                        ),
                      );
                    },
                    child: MonthlyBudget(),
                  ),
                  SectionWithHeader(
                    title: 'Lent',
                    leftText: 'View All',
                    viewAllCallback: () {},
                    child: PeopleList(isOwed: true),
                  ),
                  SectionWithHeader(
                    title: 'Borrowed',
                    leftText: 'View All',
                    viewAllCallback: () {},
                    child: PeopleList(isOwed: false),
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
          ],
        ),
      ),
    );
  }
}

class ProfileBalance extends StatelessWidget {
  const ProfileBalance({super.key});

  @override
  Widget build(BuildContext context) {
    final budgetViewModel = context.watch<BudgetViewModel>();
    final budgets = budgetViewModel.budgets;

    final double totalAllocatedAmount = budgets.fold(0, (sum, budget) => sum + budget.allocatedAmount);
    final double totalSpentAmount = budgets.fold(0, (sum, budget) => sum + budget.spentAmount);

    final double progressInRation = (totalAllocatedAmount != 0)
        ? totalSpentAmount / totalAllocatedAmount
        : 0.0;

    final double progress = (1 - progressInRation) * 100;

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.yellow[700],
                child: IconButton(
                  color: Colors.yellow[900],
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                  icon: Icon(CupertinoIcons.person_fill),
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
                      value: progress,
                      maxValue: 100,
                      label: "${progress.toStringAsFixed(0)} / 100",
                    ),
                  ),
                ],
              )
            ],
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}

class MonthlyBudget extends StatelessWidget {
  const MonthlyBudget({super.key});

  @override
  Widget build(BuildContext context) {
    final budgetViewModel = context.watch<BudgetViewModel>();
    final budgets = budgetViewModel.budgets;
    // final categories = context.watch<CategoryProvider>().categories; // TODO: Refactor
    final categories = []; // Placeholder

    if (budgets.isEmpty || categories.isEmpty) {
      return const Center(
        child: Text(
          'No budgets or categories available.',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      );
    }

    Category getCategoryDetails(String categoryId) {
      return categories.firstWhere(
            (cat) => cat.name == categoryId,
        orElse: () => Category(
          id: '',
          name: 'Unknown',
          icon: Icons.category,
          color: Colors.grey,
        ),
      );
    }

    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: budgets.length,
        itemBuilder: (context, index) {
          final budget = budgets[index];
          final category = getCategoryDetails(budget.category);
          final double progress = budget.allocatedAmount > 0 ? budget.spentAmount / budget.allocatedAmount : 0;
          final Color progressColor = category.color;

          return ContainerWIthBoxShadow(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10.0),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            width: 230,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${budget.allocatedAmount.toStringAsFixed(0)} Br. total',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Stack(
                  children: [
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
                    Positioned.fill(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              '${(budget.spentAmount).toStringAsFixed(0)} Br.',
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
                              '${budget.allocatedAmount} Br.',
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

class RecentTransaction extends StatelessWidget {
  const RecentTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionViewModel = context.watch<TransactionViewModel>();
    final transactions = transactionViewModel.transactions;
    // final categories = context.watch<CategoryProvider>().categories; // TODO: Refactor
    final categories = []; // Placeholder
    // final selectedTimePeriod = context.watch<TimePeriodProvider>().selectedTimePeriod; // TODO: Refactor
    final selectedTimePeriod = TimePeriod.month; // Placeholder

    final now = DateTime.now();
    final filteredTransactions = transactions.where((transaction) {
      switch (selectedTimePeriod) {
        case TimePeriod.week:
          return transaction.date.isAfter(now.subtract(const Duration(days: 7)));
        case TimePeriod.month:
          return transaction.date.isAfter(now.subtract(const Duration(days: 30)));
        case TimePeriod.year:
          return transaction.date.isAfter(now.subtract(const Duration(days: 365)));
        default:
          return true;
      }
    }).toList();

    final Map<String, List<Transaction>> groupedTransactions = {};
    for (var transaction in filteredTransactions) {
      final dateKey = DateFormat('yyyy-MM-dd').format(transaction.date);
      groupedTransactions.putIfAbsent(dateKey, () => []).add(transaction);
    }

    final sortedDates = groupedTransactions.keys.toList()
      ..sort((a, b) => DateTime.parse(b).compareTo(DateTime.parse(a)));

    if (transactions.isEmpty) {
      return const Center(
        child: Text(
          'No recent transactions available.',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sortedDates.length,
          itemBuilder: (context, dateIndex) {
            final dateKey = sortedDates[dateIndex];
            final transactionsOnDate = groupedTransactions[dateKey]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Date:',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        dateKey,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                ...transactionsOnDate.map((transaction) {
                  final category = categories.firstWhere((cat) => cat.name == transaction.category); // Placeholder
                  final amountColor = transaction.type == 'Income' ? Colors.green : Colors.red;

                  return ContainerWIthBoxShadow(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: category.color.withOpacity(0.2),
                        child: Icon(category.icon, color: category.color),
                      ),
                      title: Text(
                        transaction.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(category.name),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${transaction.amount.toStringAsFixed(2)} Br.',
                            style: TextStyle(color: amountColor, fontSize: 14),
                          ),
                          Text(
                            transaction.bankType,
                            style: const TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            );
          },
        ),
      ],
    );
  }
}

// ... (rest of the file remains the same, with ConsumerWidgets that don't use budgetProvider)

