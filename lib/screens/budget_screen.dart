import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yegna_eqif_new/providers/budget_provider.dart';
import 'package:yegna_eqif_new/providers/time_period_provider.dart';
import 'package:yegna_eqif_new/screens/add_category_screen.dart';
import 'package:yegna_eqif_new/screens/dashboard_screen.dart';
import 'package:yegna_eqif_new/screens/manage_budget_page.dart';
import 'package:yegna_eqif_new/screens/reports_screen.dart';
import 'package:yegna_eqif_new/providers/category_provider.dart';

import '../models/category.dart';

class BudgetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              TimePeriodToggle(),
              SizedBox(height: 40),
              CircularProgressBar(),
              SizedBox(height: 20),
              SectionWithHeader(
                title: 'Budget Summary',
                leftText: 'Manage budget',
                viewAllCallback: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ManageBudgetPage()));
                },
                child: BudgetOverview(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text('Category List',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              CategoriesGrid(),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text('Category Budget',
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 16),
              MonthlyBudget(),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoriesGrid extends ConsumerWidget {
  const CategoriesGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryProvider);

    return ContainerWIthBoxShadow(margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),child: categories.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: categories.length + 1,
          itemBuilder: (context, index) {
            if (index == categories.length) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  AddCategoryPage()),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      child: const Icon(Icons.add, color: Colors.black, size: 20),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Add',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              );
            }

            final category = categories[index];

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: category.color.withOpacity(0.1),
                  child: Icon(
                    category.icon,
                    color: category.color,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  category.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            );
          },
        ));
  }
}



class CircularProgressBar extends ConsumerWidget {
  const CircularProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgets = ref.watch(budgetProvider);
    final selectedTimePeriod = ref.watch(timePeriodProvider);

    // Filter the budgets based on the selected time period
    final filteredBudgets = budgets.where((budget) {
      final now = DateTime.now();
      switch (selectedTimePeriod) {
        case TimePeriod.week:
          return budget.startDate.isAfter(now.subtract(Duration(days: 7)));
        case TimePeriod.month:
          return budget.startDate.isAfter(now.subtract(Duration(days: 30)));
        case TimePeriod.year:
          return budget.startDate.isAfter(now.subtract(Duration(days: 365)));
        default:
          return true;
      }
    }).toList();

    // Calculate total allocated amount and total spent amount
    final double totalAllocatedAmount = filteredBudgets.fold(0, (sum, budget) => sum + budget.allocatedAmount);
    final double totalSpentAmount = filteredBudgets.fold(0, (sum, budget) => sum + budget.spentAmount);

    // Calculate progress
    final double progress = totalSpentAmount / totalAllocatedAmount;

    // Determine color based on progress
    Color progressColor;
    if (progress <= 0.5) {
      progressColor = Colors.red; // Red for less than 50%
    } else if (progress <= 0.8) {
      progressColor = Colors.yellow; // Yellow for 50-80%
    } else {
      progressColor = Colors.green; // Green for 80% and above
    }

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Circle
          SizedBox(
            width: 200,
            height: 200,
            child: CircularProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              strokeWidth: 15,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              backgroundColor: Colors.black12,
            ),
          ),
          // Inner content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Progress percentage
              Text(
                '${(progress * 100).toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              // Current and Total amount
              Text(
                '\$${totalSpentAmount.toStringAsFixed(0)} of \$${totalAllocatedAmount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
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
            (cat) => cat.name == categoryId,
        orElse: () => Category(id: '', name: 'Unknown', icon: Icons.question_mark, color: Colors.grey),
      );
    }

    return SizedBox(
      // Adjust the height as needed
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: budgets.length,
        itemBuilder: (context, index) {
          final budget = budgets[index];
          final double dailyBudget = budget.allocatedAmount / 7;
          final category = getCategoryDetails(budget.category);
          final double progress = budget.spentAmount / budget.allocatedAmount;
          final Color progressColor = category.color;

          // Determine the status and indicator properties
          String statusText;
          IconData statusIcon;
          Color statusColor;

          if (progress < 0.7) {
            statusText = 'Your spending is still on track';
            statusIcon = Icons.check_circle;
            statusColor = Colors.green;
          } else if (progress < 1.0) {
            statusText = 'You are almost exceeding your budget';
            statusIcon = Icons.error_outline;
            statusColor = Colors.yellow[700]!;
          } else {
            statusText = 'You have exceeded your budget';
            statusIcon = Icons.error;
            statusColor = Colors.red;
          }

          return ContainerWIthBoxShadow(margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon and Label Row
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: category.color.withOpacity(0.2),
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
                            '\$${dailyBudget.toStringAsFixed(2)}/Day',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
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
                                '\$${budget.spentAmount.toStringAsFixed(0)}',
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
                                '\$${budget.allocatedAmount.toStringAsFixed(0)}',
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
                  const SizedBox(height: 16),
                  // Status Indicator
                  Row(
                    children: [
                      Icon(
                        statusIcon,
                        color: statusColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ));
        },
      ),
    );
  }
}

class BudgetOverview extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgets = ref.watch(budgetProvider);
    final selectedTimePeriod = ref.watch(timePeriodProvider);

    // Filter the budgets based on the selected time period
    final filteredBudgets = budgets.where((budget) {
      final now = DateTime.now();
      switch (selectedTimePeriod) {
        case TimePeriod.week:
          return budget.startDate.isAfter(now.subtract(Duration(days: 7)));
        case TimePeriod.month:
          return budget.startDate.isAfter(now.subtract(Duration(days: 30)));
        case TimePeriod.year:
          return budget.startDate.isAfter(now.subtract(Duration(days: 365)));
        default:
          return true;
      }
    }).toList();

    // Calculate total allocated amount and total spent amount
    final double totalAllocatedAmount = filteredBudgets.fold(0, (sum, budget) => sum + budget.allocatedAmount);
    final double totalSpentAmount = filteredBudgets.fold(0, (sum, budget) => sum + budget.spentAmount);

    // Calculate remaining budget and savings percentage
    final double remainingBudget = totalAllocatedAmount - totalSpentAmount;
    final double savingPercentage = totalAllocatedAmount != 0 ? (remainingBudget / totalAllocatedAmount) * 100 : 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ContainerWIthBoxShadow(padding: const EdgeInsets.all(16.0), child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: Colors.green.withOpacity(0.1),
                    radius: 22,
                    child: Icon(Icons.attach_money, color: Colors.green, size: 22),
                  ),
                  title: const Text('Total Budget', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
                  subtitle: Text('\$${totalAllocatedAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              Expanded(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: Colors.red.withOpacity(0.1),
                    radius: 22,
                    child: Icon(Icons.money_off, color: Colors.red, size: 22),
                  ),
                  title: const Text('Budget Spent', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
                  subtitle: Text('\$${totalSpentAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    radius: 22,
                    child: Icon(Icons.account_balance_wallet, color: Colors.blue, size: 22),
                  ),
                  title: const Text('Remaining Budget', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
                  subtitle: Text('\$${remainingBudget.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              Expanded(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: Colors.purple.withOpacity(0.1),
                    radius: 22,
                    child: Icon(Icons.percent, color: Colors.purple, size: 22),
                  ),
                  title: const Text('Saving Percentage', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
                  subtitle: Text('${savingPercentage.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),),
    );
  }
}









