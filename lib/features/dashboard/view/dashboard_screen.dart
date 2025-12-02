import 'dart:math';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:yegna_eqif_new/features/dashboard/viewmodel/dashboard_viewmodel.dart';
import 'package:yegna_eqif_new/features/category/viewmodel/category_viewmodel.dart';
import 'package:yegna_eqif_new/features/settings/view/profile_screen.dart';
import 'package:yegna_eqif_new/features/settings/view/settings_screen.dart';
import 'package:intl/intl.dart';
import '../../../models/category.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardViewModel = context.watch<DashboardViewModel>();

    if (dashboardViewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (dashboardViewModel.error != null) {
      return Center(child: Text('Error: ${dashboardViewModel.error}'));
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const ProfileBalance(),
            const SizedBox(height: 20),
            const TotalBalanceCard(),
            const SizedBox(height: 20),
            SectionWithHeader(
              title: 'Monthly Budget',
              leftText: 'View All',
              viewAllCallback: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const TopSpendingDetailPage(),
                //   ),
                // );
              },
              child: const MonthlyBudget(),
            ),
            const SizedBox(height: 20),
            SectionWithHeader(
              title: 'Recent Transactions',
              leftText: 'View All',
              viewAllCallback: () {},
              child: const RecentTransaction(),
            ),
            const SizedBox(height: 20),
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
    final dashboardViewModel = context.watch<DashboardViewModel>();
    final totalBudget = dashboardViewModel.dashboardModel?.totalBudget ?? 0;
    final totalSpent = dashboardViewModel.dashboardModel?.totalSpent ?? 0;

    final double progressInRation =
        (totalBudget != 0) ? totalSpent / totalBudget : 0.0;

    final double progress = (1 - progressInRation) * 100;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()),
                  );
                },
                child: ShadAvatar(
                  'assets/profile_picture.png',
                  placeholder: Container(
                    color: Colors.yellow[700],
                    child: Icon(
                      CupertinoIcons.person_fill,
                      color: Colors.yellow[900],
                    ),
                  ),
                  size: const Size(50, 50),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hamdi Abdulfetah',
                    style: ShadTheme.of(context).textTheme.large,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      'Progress: ${progress.toStringAsFixed(0)}%',
                      style: ShadTheme.of(context).textTheme.muted,
                    ),
                  ),
                ],
              )
            ],
          ),
          ShadButton.ghost(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            child: const Icon(Icons.settings),
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
    final categoryViewModel = context.watch<CategoryViewModel>();
    final categories = categoryViewModel.categories;

    if (dashboardViewModel.dashboardModel == null || categories.isEmpty) {
      return Center(
        child: Text(
          'No budgets or categories available.',
          style: ShadTheme.of(context).textTheme.muted,
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
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 1, // Placeholder
        itemBuilder: (context, index) {
          final budget = dashboardViewModel.dashboardModel!;
          final category = getCategoryDetails('1'); // Placeholder
          final double progress = budget.totalBudget > 0
              ? budget.totalSpent / budget.totalBudget
              : 0;
          final Color progressColor = category.color;

          return ShadCard(
            width: 230,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: progressColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        category.icon,
                        color: progressColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.name,
                            style: ShadTheme.of(context).textTheme.large,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${budget.totalBudget.toStringAsFixed(0)} Br. total',
                            style: ShadTheme.of(context).textTheme.muted,
                          ),
                        ],
                      ),
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

    if (dashboardViewModel.dashboardModel == null) {
      return Center(
        child: Text(
          'No recent transactions available.',
          style: ShadTheme.of(context).textTheme.muted,
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
            return ShadCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date:',
                    style: ShadTheme.of(context).textTheme.muted,
                  ),
                  Text(
                    DateFormat('yyyy-MM-dd').format(DateTime.now()),
                    style: ShadTheme.of(context).textTheme.p.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class TotalBalanceCard extends StatelessWidget {
  const TotalBalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardViewModel = context.watch<DashboardViewModel>();
    final totalBalance = dashboardViewModel.dashboardModel?.totalBalance ?? 0;
    final totalIncome = dashboardViewModel.dashboardModel?.totalIncome ?? 0;
    final totalExpense = dashboardViewModel.dashboardModel?.totalSpent ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ShadCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text('Total Balance', style: ShadTheme.of(context).textTheme.muted),
            const SizedBox(height: 8),
            Text('${totalBalance.toStringAsFixed(2)} Br.',
                style: ShadTheme.of(context).textTheme.h2),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_downward,
                              color: Colors.green, size: 16),
                        ),
                        const SizedBox(width: 8),
                        Text('Income',
                            style: ShadTheme.of(context).textTheme.muted),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('${totalIncome.toStringAsFixed(2)} Br.',
                        style: ShadTheme.of(context).textTheme.large),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_upward,
                              color: Colors.red, size: 16),
                        ),
                        const SizedBox(width: 8),
                        Text('Expense',
                            style: ShadTheme.of(context).textTheme.muted),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('${totalExpense.toStringAsFixed(2)} Br.',
                        style: ShadTheme.of(context).textTheme.large),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SectionWithHeader extends StatelessWidget {
  final String title;
  final String leftText;
  final VoidCallback viewAllCallback;
  final Widget child;

  const SectionWithHeader(
      {super.key,
      required this.title,
      required this.leftText,
      required this.viewAllCallback,
      required this.child});

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
                style: ShadTheme.of(context).textTheme.h4,
              ),
              ShadButton.ghost(
                onPressed: viewAllCallback,
                child: Text(
                  leftText,
                  style: TextStyle(
                      color: ShadTheme.of(context).colorScheme.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
