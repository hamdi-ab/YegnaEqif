import 'dart:math';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yegna_eqif_new/features/dashboard/viewmodel/dashboard_viewmodel.dart';
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
  @override
  Widget build(BuildContext context) {
    final dashboardViewModel = context.watch<DashboardViewModel>();

    if (dashboardViewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (dashboardViewModel.error != null) {
      return Center(child: Text('Error: ${dashboardViewModel.error}'));
    }

    return SingleChildScrollView(
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
    );
  }
}

class ProfileBalance extends StatelessWidget {
  const ProfileBalance({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardViewModel = context.watch<DashboardViewModel>();
    final totalBudget = dashboardViewModel.dashboardModel?.totalBudget ?? 0;
    final totalSpent = dashboardViewModel.dashboardModel?.totalSpent ?? 0;

    final double progressInRation = (totalBudget != 0)
        ? totalSpent / totalBudget
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
    final dashboardViewModel = context.watch<DashboardViewModel>();
    // final categories = context.watch<CategoryProvider>().categories; // TODO: Refactor
    final categories = []; // Placeholder

    if (dashboardViewModel.dashboardModel == null || categories.isEmpty) {
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
        itemCount: 1, // Placeholder
        itemBuilder: (context, index) {
          final budget = dashboardViewModel.dashboardModel!;
          final category = getCategoryDetails('1'); // Placeholder
          final double progress = budget.totalBudget > 0 ? budget.totalSpent / budget.totalBudget : 0;
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
                          '${budget.totalBudget.toStringAsFixed(0)} Br. total',
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
                              '${(budget.totalSpent).toStringAsFixed(0)} Br.',
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
                              '${budget.totalBudget} Br.',
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
    final dashboardViewModel = context.watch<DashboardViewModel>();
    // final categories = context.watch<CategoryProvider>().categories; // TODO: Refactor
    final categories = []; // Placeholder
    // final selectedTimePeriod = context.watch<TimePeriodProvider>().selectedTimePeriod; // TODO: Refactor
    final selectedTimePeriod = TimePeriod.month; // Placeholder

    if (dashboardViewModel.dashboardModel == null) {
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
          itemCount: 1, // Placeholder
          itemBuilder: (context, dateIndex) {
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
                        DateFormat('yyyy-MM-dd').format(DateTime.now()),
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
              ],
            );
          },
        ),
      ],
    );
  }
}

// ... (rest of the file remains the same, with ConsumerWidgets that don't use budgetProvider)