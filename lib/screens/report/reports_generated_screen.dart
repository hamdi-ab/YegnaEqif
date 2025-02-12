import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yegna_eqif_new/providers/category_provider.dart';
import 'package:yegna_eqif_new/screens/dashboard/dashboard_screen.dart';
import 'package:yegna_eqif_new/screens/report/reports_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/time_period_provider.dart';
import '../../providers/transaction_provider.dart';

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
      if (transaction.type == 'Income') {
        return sum + transaction.amount;
      } else if (transaction.type == 'Expense') {
        return sum - transaction.amount;
      }
      return sum;
    });

    return ContainerWIthBoxShadow(padding: const EdgeInsets.only(top: 8.0, bottom: 18.0, left: 16.0, right: 16.0),
        margin: const EdgeInsets.symmetric(horizontal: 16.0),child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Total Balance', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54)),
              subtitle: Text('${totalBalance.toStringAsFixed(2)} Br.', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              trailing: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.account_balance_wallet, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            const SummaryCardContainer(),
          ],
        ));
  }
}


class WeeklyNetIncomeCard extends ConsumerWidget {
  const WeeklyNetIncomeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionProvider);
    final selectedTimePeriod = ref.watch(timePeriodProvider);

    final groupedData = _calculateGroupedData(transactions, selectedTimePeriod);
    final netIncome = _calculateNetIncome(transactions, selectedTimePeriod);

    return Container(
      height: 300,
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
          Text(
            '${netIncome.toStringAsFixed(2)} Br.',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _buildChart(selectedTimePeriod, groupedData),
          ),
          const SizedBox(height: 16),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildChart(TimePeriod period, List<BarChartGroupData> groupedData) {
    if (period == TimePeriod.month) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 600,
          child: BarChart(_buildChartData(groupedData, period)), // Pass period here
        ),
      );
    }
    return BarChart(_buildChartData(groupedData, period)); // Pass period here
  }


  BarChartData _buildChartData(List<BarChartGroupData> groupedData, TimePeriod selectedTimePeriod) {
    return BarChartData(
      barGroups: groupedData,
      gridData: const FlGridData(
        show: true,
        drawVerticalLine: false,
        drawHorizontalLine: true,
      ),
      borderData: FlBorderData(show: false),// In the _buildChartData method, modify the titlesData section like this:
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              // Changed: Remove meta.axis check and use selectedTimePeriod parameter
              final period = selectedTimePeriod; // Use the period passed from parent
              switch (period) {
                case TimePeriod.week:
                  const weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                        weekDays[value.toInt() % 7],
                        style: const TextStyle(fontSize: 12)
                    ),
                  );
                case TimePeriod.month:
                  return Text(
                      'Week ${value.toInt() + 1}',
                      style: const TextStyle(fontSize: 12)
                  );
                case TimePeriod.year:
                  final months = ['Jan','Feb','Mar','Apr','May','Jun',
                    'Jul','Aug','Sep','Oct','Nov','Dec'];
                  return Text(
                      months[value.toInt()],
                      style: const TextStyle(fontSize: 12)
                  );
                default:
                  return const SizedBox();
              }
            },
            reservedSize: 30,
          ),
        ),
        // ... rest of the titlesData configuration
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) => Text(
              '${value.toInt()} Br.',
              style: const TextStyle(fontSize: 10),
            ),
            reservedSize: 40,
          ),
        ),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      maxY: _calculateMaxY(groupedData),
    );
  }

  double _calculateMaxY(List<BarChartGroupData> groups) {
    double max = 0;
    for (var group in groups) {
      for (var rod in group.barRods) {
        if (rod.toY > max) max = rod.toY;
      }
    }
    return max * 1.2; // Add 20% padding
  }

  List<BarChartGroupData> _calculateGroupedData(List transactions, TimePeriod period) {
    final incomeMap = <int, double>{};
    final expenseMap = <int, double>{};

    for (var transactionData in transactions) {
      final transaction = transactionData;
      final date = transaction.date;
      int groupKey;

      switch (period) {
        case TimePeriod.week:
          groupKey = date.weekday - 1; // 0-6 (Monday-Sunday)
          break;
        case TimePeriod.month:
        // Group by week of month (0-3), weeks starting on Monday
          final firstDayOfMonth = DateTime(date.year, date.month, 1);
          final firstMonday = firstDayOfMonth.weekday == DateTime.monday
              ? firstDayOfMonth
              : firstDayOfMonth.add(Duration(days: DateTime.monday - firstDayOfMonth.weekday));
          groupKey = ((date.difference(firstMonday).inDays) ~/ 7).clamp(0, 3);
          break;
        case TimePeriod.year:
          groupKey = date.month - 1; // 0-11 (Jan-Dec)
          break;
        default:
          groupKey = 0;
      }

      if (transaction.type == 'Income') {
        incomeMap[groupKey] = (incomeMap[groupKey] ?? 0) + transaction.amount;
      } else {
        expenseMap[groupKey] = (expenseMap[groupKey] ?? 0) + transaction.amount;
      }
    }

    final maxGroups = period == TimePeriod.week ? 7
        : period == TimePeriod.month ? 4
        : 12;

    return List.generate(maxGroups, (i) {
      final income = incomeMap[i] ?? 0;
      final expense = expenseMap[i] ?? 0;
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(toY: income, color: Colors.green),
          BarChartRodData(toY: expense, color: Colors.red),
        ],
      );
    });
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem(Colors.green, 'Income'),
        _buildLegendItem(Colors.red, 'Expense'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }

  double _calculateNetIncome(List transactions, TimePeriod period) {
    final now = DateTime.now();
    final filteredTransactions = transactions.where((transactionData) {
      final transaction = transactionData;
      final date = transaction.date;

      switch (period) {
        case TimePeriod.week:
          return date.isAfter(now.subtract(const Duration(days: 7)));
        case TimePeriod.month:
          final firstDayOfMonth = DateTime(now.year, now.month, 1);
          return date.isAfter(firstDayOfMonth);
        case TimePeriod.year:
          final firstDayOfYear = DateTime(now.year, 1, 1);
          return date.isAfter(firstDayOfYear);
        default:
          return true;
      }
    }).toList();

    double income = 0;
    double expense = 0;

    for (var transactionData in filteredTransactions) {
      final transaction = transactionData;
      if (transaction.type == 'Income') {
        income += transaction.amount;
      } else {
        expense += transaction.amount;
      }
    }

    return income - expense;
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

      final int totalTransaction = filteredByType
          .where((transaction) => transaction.category == category.name)
          .length;

      return {
        'name': category.name,
        'amount': categoryTotal,
        'percent': percent,
        'color': category.color,
        'icon': category.icon,
        'totalTransaction': totalTransaction,
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
                    '${totalValue.toStringAsFixed(2)} Br.', // Dynamic total value
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
                    subtitle: Text(
                      '${(category['totalTransaction'] as int).toString()} Transactions ',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${(category['amount'] as double) .toStringAsFixed(2)} Br.',
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






