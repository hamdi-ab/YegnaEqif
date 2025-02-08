import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yegna_eqif_new/providers/budget_provider.dart';
import 'package:yegna_eqif_new/providers/time_period_provider.dart';
import 'package:yegna_eqif_new/providers/transaction_provider.dart';
import 'package:yegna_eqif_new/screens/dashboard_screen.dart';
import 'package:yegna_eqif_new/screens/reports_generated_screen.dart';

import '../providers/total_balance_card_provider.dart';

class ReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align content to the start
            children: [
              const SizedBox(height: 30),
              const ProfileBalance(),
              const SizedBox(height: 30),
              TimePeriodToggle(),
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

class ProfileBalance extends ConsumerWidget {
  const ProfileBalance({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalBalanceCard = ref.watch(totalBalanceCardProvider);
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 12.0),
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
                  Text('Balance',
                      style: Theme.of(context).textTheme.bodyMedium),
                  Text('\$${totalBalanceCard.totalBalance}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class TimePeriodToggle extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTimePeriod = ref.watch(timePeriodProvider);

    final List<TimePeriod> periods = [
      TimePeriod.week,
      TimePeriod.month,
      TimePeriod.year
    ];
    final List<String> labels = ["This Week", "This Month", "This Year"];
    final int selectedIndex = periods.indexOf(selectedTimePeriod);

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final isSelected = index == selectedIndex;
          return Expanded(
            // Ensures buttons are evenly spaced
            child: GestureDetector(
              onTap: () {
                ref.read(timePeriodProvider.notifier).state = periods[index];
              },
              child: Container(
                height: 42,
                padding: const EdgeInsets.symmetric(
                    horizontal: 8), // Reduced padding
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  labels[index],
                  style: TextStyle(
                    fontSize: 16,
                    color: isSelected ? Colors.black : Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
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

class SummaryCardContainer extends ConsumerWidget {
  const SummaryCardContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsWithCategoryDetails = ref.watch(transactionProvider);
    final selectedTimePeriod = ref.watch(timePeriodProvider);

    // Filter the transactions based on the selected time period
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

    // Calculate total income and expenses
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
            amount: '\$${totalIncome.toStringAsFixed(2)}',
            color: const Color(0xFFE1F5FE), // Light Blue Accent
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: SummaryCard(
            title: 'Expense',
            amount: '\$${totalExpenses.toStringAsFixed(2)}',
            color: const Color(0xFFF8BBD0), // Pink Accent
          ),
        ),
      ],
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



class BudgetCard extends ConsumerWidget {
  const BudgetCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgets = ref.watch(budgetProvider);
    final selectedTimePeriod = ref.watch(timePeriodProvider);

    // Determine the title and days in the selected time period
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

    // Filter the budgets based on the selected time period
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

    // Calculate total allocated amount and total spent amount
    final double totalAllocatedAmount = filteredBudgets.fold(0, (sum, budget) => sum + budget.allocatedAmount);
    final double totalSpentAmount = filteredBudgets.fold(0, (sum, budget) => sum + budget.spentAmount);

    // Calculate progress
    final double progress = totalSpentAmount / (totalAllocatedAmount != 0 ? totalAllocatedAmount : 1);

    // Calculate daily budget
    final double dailyBudget = totalAllocatedAmount / daysInPeriod;

    // Example data (replace with dynamic data from your budget and categories state)
    final String totalExpense = totalSpentAmount.toStringAsFixed(2);
    final String totalBudget = totalAllocatedAmount.toStringAsFixed(2);

    Color progressColor;
    if (progress <= 0.5) {
      progressColor = Colors.red; // Red for less than 50%
    } else if (progress <= 0.8) {
      progressColor = Colors.blue; // Blue for 50-80%
    } else {
      progressColor = Colors.green; // Green for 80% and above
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
          '\$${dailyBudget.toStringAsFixed(2)}/Day',
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
              '\$${totalExpense} Exp',
              style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Of \$${totalBudget}',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

