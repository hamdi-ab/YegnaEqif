import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yegna_eqif_new/data/data.dart';
import 'package:yegna_eqif_new/providers/category_provider.dart';
import 'package:yegna_eqif_new/screens/reports_screen.dart';
import 'package:fl_chart/fl_chart.dart';

import '../models/transaction.dart';
import '../providers/time_period_provider.dart';
import '../providers/transaction_provider.dart';

class ReportsGeneratedScreen extends StatelessWidget {
  const ReportsGeneratedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Report', style: TextStyle(fontWeight: FontWeight.w500),),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){

          }, icon: const Icon(Icons.calendar_month))
        ],
      ),
      body:  SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              TimePeriodToggle(),
              const SizedBox(height: 16),
              TotalBalanceContainer(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text('Income & Expense', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              WeeklyNetIncomeCard(),
              SizedBox(height: 20),
              IncomeExpenseBreakdownCard(title: 'Income'),
              IncomeExpenseBreakdownCard(title: 'Expense')
            ],
          ),
        ),
      ),
    );
  }
}

class TotalBalanceContainer extends ConsumerWidget {
  const TotalBalanceContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionProvider);

    // Calculate total balance
    final double totalBalance = transactions.fold(0, (sum, transaction) {
      if (transaction['transaction'].type == 'Income') {
        return sum + transaction['transaction'].amount;
      } else if (transaction['transaction'].type == 'Expense') {
        return sum - transaction['transaction'].amount;
      }
      return sum;
    });

    return Container(
      padding: const EdgeInsets.only(top: 8.0, bottom: 18.0, left: 16.0, right: 16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          // Bottom shadow for elevation
          BoxShadow(
            color: Colors.black.withOpacity(0.15), // Subtle shadow
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, 4), // Bottom shadow
          ),
          // Light top shadow for visibility
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            spreadRadius: -1,
            offset: const Offset(0, -2), // Top shadow
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Total Balance', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54)),
            subtitle: Text('\$${totalBalance.toStringAsFixed(2)}', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            trailing: const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.account_balance_wallet, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          const SummaryCardContainer(),
        ],
      ),
    );
  }
}


class WeeklyNetIncomeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300, // Compact card height
      margin: const EdgeInsets.all(16.0),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Net Income',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            '\$980.50',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BarChart(
              BarChartData(
                barGroups: weeklyBarData, // Use the extracted data
                gridData: const FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  drawHorizontalLine: true, // Adjusted for better spacing
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(days[value.toInt()], style: const TextStyle(fontSize: 12)),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(
                            '${(value / 1000).toInt()}k',
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                maxY: 16000,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('Income'),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('Expense'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class IncomeExpenseBreakdownCard extends ConsumerWidget {
  final String title; // "Income" or "Expense"

  IncomeExpenseBreakdownCard({
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionProvider);
    final selectedTimePeriod = ref.watch(timePeriodProvider);
    final categories = ref.watch(categoryProvider);
    final isIncome = title == 'Income';

    // Filter the transactions based on the selected time period
    final filteredTransactions = transactions.where((transactionData) {
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
    }).map((transactionData) => transactionData['transaction'] as Transaction).toList();

    // Filter transactions based on type (Income or Expense)
    final filteredByType = filteredTransactions.where((transaction) => transaction.type == (isIncome ? 'Income' : 'Expense')).toList();

    // Calculate total value
    final double totalValue = filteredByType.fold(0, (sum, transaction) => sum + transaction.amount);

    // Calculate category data
    final categoryData = categories.map((category) {
      final double categoryTotal = filteredByType
          .where((transaction) => transaction.category == category.name)
          .fold(0, (sum, transaction) => sum + transaction.amount);

      final double percent = totalValue != 0 ? (categoryTotal / totalValue) * 100 : 0;

      return {
        'name': category.name,
        'amount': categoryTotal,
        'percent': percent,
        'color': category.color,
        'icon': category.icon,
      };
    }).where((data) => (data['amount'] as double) > 0).toList();

    return Container(
      margin: const EdgeInsets.all(16.0),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with dynamic Income/Expense title and Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isIncome ? Colors.green : Colors.red,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${totalValue.toStringAsFixed(2)}', // Dynamic total value
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isIncome ? Colors.green : Colors.red,
                    ),
                  ),
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Pie Chart Section
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: categoryData.map((data) {
                  return PieChartSectionData(
                    color: data['color'] as Color,
                    value: data['amount'] as double,
                    title: '${(data['percent'] as double).toStringAsFixed(1)}%',
                    radius: 50,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
                sectionsSpace: 4,
                centerSpaceRadius: 40,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Categories List with Progress Bars
          Column(
            children: List.generate(categoryData.length, (index) {
              final category = categoryData[index];
              return Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: category['color'] as Color,
                      child: Icon(category['icon'] as IconData , color: Colors.white),
                    ),
                    title: Text(
                      category['name'] as String,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${(category['amount'] as double) .toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${(category['percent'] as double).toStringAsFixed(1)}%',
                          style: const TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  // Progress Bar for each category
                  Stack(
                    children: [
                      // Full width transparent background
                      Container(
                        height: 8,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: (category['color'] as Color).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      // Filled progress bar
                      Container(
                        height: 8,
                        width: MediaQuery.of(context).size.width * (category['percent'] as double) / 100,
                        decoration: BoxDecoration(
                          color: category['color'] as Color,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}






