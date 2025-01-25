import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yegna_eqif_new/data/data.dart';
import 'package:yegna_eqif_new/screens/reports_screen.dart';
import 'package:fl_chart/fl_chart.dart';

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
          IconButton(onPressed: (){}, icon: const Icon(Icons.calendar_month))
        ],
      ),
      body:  SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const TimePeriodToggle(),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.only(top: 8.0, bottom: 18.0, left: 16.0, right: 16.0),
                margin:const EdgeInsets.symmetric(horizontal: 16.0) ,
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
                child: const Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Total Balance', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54),),
                      subtitle: Text('\$50,000', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),),
                      trailing: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.wallet),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: SummaryCard(
                            title: 'Income',
                            amount: '\$ 45,520',
                            color: Color(0xFFE1F5FE), // Light Blue Accent
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: SummaryCard(
                            title: 'Expense',
                            amount: '\$ 44,520',
                            color: Color(0xFFF8BBD0), // Pink Accent
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text('Income & Expense', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              WeeklyNetIncomeCard(),
              SizedBox(height: 20),
              IncomeExpenseBreakdownCard(title: 'Income', totalValue: 45000.0,categoryData: incomeCategoryData),
              IncomeExpenseBreakdownCard(title: 'Expense', totalValue: 39875.0, categoryData: expenseCategoryData)
            ],
          ),
        ),
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


class IncomeExpenseBreakdownCard extends StatelessWidget {
  final String title; // "Income" or "Expense"
  final double totalValue; // Total value like $45,500 or $12,300
  final List<Map<String, dynamic>> categoryData;

  IncomeExpenseBreakdownCard({
    required this.title,
    required this.totalValue,
    required this.categoryData,
  });

  @override
  Widget build(BuildContext context) {
    bool isIncome = title == 'Income'; // Determines if it's income or expense

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
                    color: data['color'],
                    value: data['value'].toDouble(),
                    title: '${data['percent']}%',
                    radius: data['isHovered'] ? 60 : 50,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
                sectionsSpace: 4,
                centerSpaceRadius: 40,
                pieTouchData: PieTouchData(
                  touchCallback: (event, pieTouchResponse) {
                    if (pieTouchResponse != null &&
                        pieTouchResponse.touchedSection != null) {
                      // Handle hover/interaction logic here.
                    }
                  },
                ),
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
                      backgroundColor: category['color'],
                      child: Icon(category['icon'], color: Colors.white),
                    ),
                    title: Text(
                      category['name'],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${category['amount']}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${category['percent']}%',
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
                          color: category['color'].withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      // Filled progress bar
                      Container(
                        height: 8,
                        width: MediaQuery.of(context).size.width * category['percent'] / 100,
                        decoration: BoxDecoration(
                          color: category['color'],
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





