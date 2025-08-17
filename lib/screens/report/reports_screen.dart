
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yegna_eqif_new/features/budget/viewmodel/budget_viewmodel.dart';
import 'package:yegna_eqif_new/features/transactions/viewmodel/transaction_viewmodel.dart';
import 'package:yegna_eqif_new/features/transactions/model/transaction.dart';
import 'package:yegna_eqif_new/models/category.dart';
import 'package:intl/intl.dart';

// import 'package:yegna_eqif_new/providers/time_period_provider.dart'; // TODO: Refactor
// import 'package:yegna_eqif_new/providers/total_balance_card_provider.dart'; // TODO: Refactor

class ReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              // const ProfileBalance(), // TODO: Refactor
              const SizedBox(height: 30),
              // TimePeriodToggle(), // TODO: Refactor
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    SummaryCardContainer(),
                    SizedBox(height: 16),
                    ReportsButton(),
                    SizedBox(height: 16),
                    BudgetCard(),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              SectionWithHeader(
                title: 'Recent Transaction',
                leftText: 'View All',
                viewAllCallback: () {},
                child: const RecentTransaction(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BudgetCard extends StatelessWidget {
  const BudgetCard({super.key});

  @override
  Widget build(BuildContext context) {
    final budgetViewModel = context.watch<BudgetViewModel>();
    final budgets = budgetViewModel.budgets;
    // final selectedTimePeriod = context.watch<TimePeriodProvider>().selectedTimePeriod; // TODO: Refactor
    final selectedTimePeriod = TimePeriod.month; // Placeholder

    String title;
    int daysInPeriod;
    switch (selectedTimePeriod) {
      case TimePeriod.week:
        title = "Weekly Budget";
        daysInPeriod = 7;
        break;
      case TimePeriod.month:
        title = "Monthly Budget";
        daysInPeriod = DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day;
        break;
      case TimePeriod.year:
        title = "Yearly Budget";
        daysInPeriod = 365;
        break;
      default:
        title = "Monthly Budget";
        daysInPeriod = DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day;
    }

    final filteredBudgets = budgets.where((budget) {
      final budgetDate = budget.startDate;
      final now = DateTime.now();
      switch (selectedTimePeriod) {
        case TimePeriod.week:
          return budgetDate.isAfter(now.subtract(Duration(days: 7)));
        case TimePeriod.month:
          return budgetDate.isAfter(now.subtract(Duration(days: 30)));
        case TimePeriod.year:
          return budgetDate.isAfter(now.subtract(Duration(days: 365)));
        default:
          return true;
      }
    }).toList();

    final double totalAllocatedAmount = filteredBudgets.fold(0, (sum, budget) => sum + budget.allocatedAmount);
    final double totalSpentAmount = filteredBudgets.fold(0, (sum, budget) => sum + budget.spentAmount);
    final double progress = totalAllocatedAmount > 0 ? totalSpentAmount / totalAllocatedAmount : 0;
    final double dailyBudget = totalAllocatedAmount > 0 ? totalAllocatedAmount / daysInPeriod : 0;

    final String totalExpense = totalSpentAmount.toStringAsFixed(2);
    final String totalBudget = totalAllocatedAmount.toStringAsFixed(2);

    Color progressColor;
    if (progress <= 0.5) {
      progressColor = Colors.red;
    } else if (progress <= 0.8) {
      progressColor = Colors.blue;
    } else {
      progressColor = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                strokeWidth: 4,
                color: progressColor,
                backgroundColor: Colors.green.withOpacity(0.2),
              ),
            ),
            const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.monetization_on, color: Colors.green),
            ),
          ],
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${dailyBudget.toStringAsFixed(2)} Br./Day',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${totalExpense} Br. Exp',
              style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Of ${totalBudget} Br.',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportsButton extends StatelessWidget {
  const ReportsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ReportsGeneratedScreen(),
            ),
          );
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'View report',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryCardContainer extends StatelessWidget {
  const SummaryCardContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transactionViewModel = context.watch<TransactionViewModel>();
    final transactionsWithCategoryDetails = transactionViewModel.transactions;
    // final selectedTimePeriod = context.watch<TimePeriodProvider>().selectedTimePeriod; // TODO: Refactor
    final selectedTimePeriod = TimePeriod.month; // Placeholder

    final filteredTransactions = transactionsWithCategoryDetails.where((transactionData) {
      final transaction = transactionData;
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
    }).map((transactionData) => transactionData).toList();

    final double totalIncome = filteredTransactions
        .where((transaction) => transaction.type == 'Income')
        .fold(0, (sum, transaction) => sum + transaction.amount);

    final double totalExpenses = filteredTransactions
        .where((transaction) => transaction.type == 'Expense')
        .fold(0, (sum, transaction) => sum + transaction.amount);

    return Row(
      children: [
        Expanded(
          child: SummaryCard(
            title: 'Income',
            amount: '${totalIncome.toStringAsFixed(2)} Br.',
            color: const Color(0xFFE1F5FE), // Light Blue Accent
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: SummaryCard(
            title: 'Expense',
            amount: '${totalExpenses.toStringAsFixed(2)} Br.',
            color: const Color(0xFFF8BBD0), // Pink Accent
          ),
        ),
      ],
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;

  const SummaryCard({
    Key? key,
    required this.title,
    required this.amount,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 175,
      height: 110,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              amount,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
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

class SectionWithHeader extends StatelessWidget {
  final String title;
  final String leftText;
  final VoidCallback viewAllCallback;
  final Widget child;

  const SectionWithHeader({Key? key, required this.title, required this.leftText, required this.viewAllCallback, required this.child}) : super(key: key);

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

class ContainerWIthBoxShadow extends StatelessWidget {
  const ContainerWIthBoxShadow(
      {super.key, this.width, required this.child, this.margin, this.padding});

  final Widget child;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.13), // Darker shadow
            blurRadius: 15, // Increased blur for smoother shadow edges
            spreadRadius: 2, // Slight spread for better visibility
            offset: const Offset(
                0, 4), // Adjust offset to balance top and bottom shadows
          ),
          BoxShadow(
            color: Colors.black
                .withOpacity(0.05), // Lighter shadow for subtle effect
            blurRadius: 10,
            spreadRadius: -1,
            offset: const Offset(
                0, -3), // Slight upward shadow to enhance the top edge
          ),
        ],
      ),
      child: child,
    );
  }
}

enum TimePeriod { week, month, year }
