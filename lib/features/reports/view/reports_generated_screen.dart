import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yegna_eqif_new/features/reports/model/report_model.dart';
import 'package:yegna_eqif_new/features/reports/viewmodel/report_viewmodel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:yegna_eqif_new/features/reports/view/reports_screen.dart';
import 'package:yegna_eqif_new/shared/widgets/forms/container_with_box_shadow.dart';

class ReportsGeneratedScreen extends StatelessWidget {
  const ReportsGeneratedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reportViewModel = context.watch<ReportViewModel>();

    if (reportViewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (reportViewModel.error != null) {
      return Center(child: Text('Error: ${reportViewModel.error}'));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Report',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.calendar_month))
        ],
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              // TimePeriodToggle(), // TODO: Refactor
              SizedBox(height: 16),
              TotalBalanceContainer(),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text('Income & Expense',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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

class TotalBalanceContainer extends StatelessWidget {
  const TotalBalanceContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final reportViewModel = context.watch<ReportViewModel>();
    final totalIncome = reportViewModel.reportModel?.totalIncome ?? 0;
    final totalExpense = reportViewModel.reportModel?.totalExpense ?? 0;
    final totalBalance = totalIncome - totalExpense;

    return ContainerWithBoxShadow(
        padding: const EdgeInsets.only(
            top: 8.0, bottom: 18.0, left: 16.0, right: 16.0),
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Total Balance',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54)),
              subtitle: Text('${totalBalance.toStringAsFixed(2)} Br.',
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold)),
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

class WeeklyNetIncomeCard extends StatelessWidget {
  const WeeklyNetIncomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final reportViewModel = context.watch<ReportViewModel>();
    final netIncome = (reportViewModel.reportModel?.totalIncome ?? 0) -
        (reportViewModel.reportModel?.totalExpense ?? 0);

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
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _buildChart(
                reportViewModel.reportModel?.categoryBreakdowns ?? []),
          ),
          const SizedBox(height: 16),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildChart(List<CategoryBreakdown> categoryBreakdowns) {
    return BarChart(_buildChartData(categoryBreakdowns));
  }

  BarChartData _buildChartData(List<CategoryBreakdown> categoryBreakdowns) {
    final barGroups = categoryBreakdowns.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(toY: data.amount, color: data.color),
        ],
      );
    }).toList();

    return BarChartData(
      barGroups: barGroups,
      gridData: const FlGridData(
        show: true,
        drawVerticalLine: false,
        drawHorizontalLine: true,
      ),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              return Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(categoryBreakdowns[value.toInt()].categoryName,
                    style: const TextStyle(fontSize: 12)),
              );
            },
            reservedSize: 30,
          ),
        ),
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
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      maxY: _calculateMaxY(barGroups),
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
}

class IncomeExpenseBreakdownCard extends StatelessWidget {
  final String title; // "Income" or "Expense"

  const IncomeExpenseBreakdownCard({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final reportViewModel = context.watch<ReportViewModel>();
    final isIncome = title == 'Income';
    final categoryData = reportViewModel.reportModel?.categoryBreakdowns ?? [];
    final totalValue = isIncome
        ? reportViewModel.reportModel?.totalIncome ?? 0
        : reportViewModel.reportModel?.totalExpense ?? 0;

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
                  const Text(
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
                    color: data.color,
                    value: data.amount,
                    title: '${data.percent.toStringAsFixed(1)}%',
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
                      backgroundColor: category.color,
                      child: Icon(category.icon, color: Colors.white),
                    ),
                    title: Text(
                      category.categoryName,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${category.totalTransaction.toString()} Transactions ',
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${category.amount.toStringAsFixed(2)} Br.',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${category.percent.toStringAsFixed(1)}%',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black54),
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
                          color: category.color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      // Filled progress bar
                      Container(
                        height: 8,
                        width: MediaQuery.of(context).size.width *
                            category.percent /
                            100,
                        decoration: BoxDecoration(
                          color: category.color,
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
