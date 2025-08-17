import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yegna_eqif_new/features/budget/viewmodel/budget_viewmodel.dart';
// import 'package:yegna_eqif_new/providers/time_period_provider.dart'; // TODO: Refactor to ViewModel
// import 'package:yegna_eqif_new/providers/category_provider.dart'; // TODO: Refactor to ViewModel
import 'package:yegna_eqif_new/screens/add%20pages/add_category_screen.dart';
import 'package:yegna_eqif_new/screens/dashboard/dashboard_screen.dart';
import 'manage_budget_page.dart';
import 'package:yegna_eqif_new/screens/report/reports_screen.dart';
import 'package:yegna_eqif_new/models/category.dart';

class BudgetScreen extends StatefulWidget {
  final bool scrollToMonthlyBudget;

  BudgetScreen({this.scrollToMonthlyBudget = false});

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final GlobalKey _monthlyBudgetKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.scrollToMonthlyBudget) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToMonthlyBudget();
      });
    }
  }

  void _scrollToMonthlyBudget() {
    Scrollable.ensureVisible(
      _monthlyBudgetKey.currentContext!,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              // TimePeriodToggle(), // TODO: Refactor
              SizedBox(height: 40),
              CircularProgressBar(),
              SizedBox(height: 20),
              SectionWithHeader(
                title: 'Budget Summary',
                leftText: 'Manage budget',
                viewAllCallback: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ManageBudgetPage()));
                },
                child: BudgetOverview(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text('Category List',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              CategoriesGrid(),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text('Category Budget',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 16),
              MonthlyBudget(key: _monthlyBudgetKey),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoriesGrid extends StatelessWidget {
  const CategoriesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // final categories = context.watch<CategoryProvider>().categories; // TODO: Refactor to ViewModel
    final categories = []; // Placeholder

    return ContainerWIthBoxShadow(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      child: categories.isEmpty
          ? FutureBuilder(
        future: Future.delayed(Duration(seconds: 1)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Align(
              alignment: AlignmentDirectional.topStart,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddCategoryPage()),
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
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      )
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
                  MaterialPageRoute(builder: (context) => AddCategoryPage()),
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
      ),
    );
  }
}

class CircularProgressBar extends StatelessWidget {
  const CircularProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final budgetViewModel = context.watch<BudgetViewModel>();
    final budgets = budgetViewModel.budgets;
    // final selectedTimePeriod = context.watch<TimePeriodProvider>().selectedTimePeriod; // TODO: Refactor
    final selectedTimePeriod = TimePeriod.month; // Placeholder

    if (budgetViewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (budgetViewModel.error != null) {
      return Center(child: Text('Error: ${budgetViewModel.error}'));
    }

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

    final double totalAllocatedAmount = filteredBudgets.fold(0, (sum, budget) => sum + budget.allocatedAmount);
    final double totalSpentAmount = filteredBudgets.fold(0, (sum, budget) => sum + budget.spentAmount);
    final double progress = totalAllocatedAmount > 0 ? totalSpentAmount / totalAllocatedAmount : 0;

    Color progressColor;
    if (progress <= 0.5) {
      progressColor = Colors.red;
    } else if (progress <= 0.8) {
      progressColor = Colors.yellow;
    } else {
      progressColor = Colors.green;
    }

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${(progress * 100).toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${totalSpentAmount.toStringAsFixed(0)} Br. of ${totalAllocatedAmount.toStringAsFixed(0)} Br.',
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

class MonthlyBudget extends StatelessWidget {
  final Key? key;
  const MonthlyBudget({this.key}) : super(key: key);

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
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }

    Category getCategoryDetails(String categoryId) {
      return categories.firstWhere(
            (cat) => cat.name == categoryId,
        orElse: () => Category(
          id: '',
          name: 'Unknown',
          icon: Icons.question_mark,
          color: Colors.grey,
        ),
      );
    }

    return SizedBox(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: budgets.length,
        itemBuilder: (context, index) {
          final budget = budgets[index];
          final double dailyBudget = budget.allocatedAmount / 7;
          final category = getCategoryDetails(budget.category);
          final double progress = budget.allocatedAmount > 0 ? budget.spentAmount / budget.allocatedAmount : 0;
          final Color progressColor = category.color;

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

          return ContainerWIthBoxShadow(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                          '${dailyBudget.toStringAsFixed(2)} Br./Day',
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
                              '${budget.spentAmount.toStringAsFixed(0)} Br.',
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
                              '${budget.allocatedAmount.toStringAsFixed(0)} Br.',
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
            ),
          );
        },
      ),
    );
  }
}

class BudgetOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final budgetViewModel = context.watch<BudgetViewModel>();
    final budgets = budgetViewModel.budgets;
    // final selectedTimePeriod = context.watch<TimePeriodProvider>().selectedTimePeriod; // TODO: Refactor
    final selectedTimePeriod = TimePeriod.month; // Placeholder

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

    final double totalAllocatedAmount = filteredBudgets.fold(0, (sum, budget) => sum + budget.allocatedAmount);
    final double totalSpentAmount = filteredBudgets.fold(0, (sum, budget) => sum + budget.spentAmount);
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
                  subtitle: Text('${totalAllocatedAmount.toStringAsFixed(0)} Br.', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  subtitle: Text('${totalSpentAmount.toStringAsFixed(0)} Br.', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  subtitle: Text('${remainingBudget.toStringAsFixed(0)} Br.', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

// TODO: Define or import ContainerWIthBoxShadow, SectionWithHeader, TimePeriodToggle, TimePeriod
class ContainerWIthBoxShadow extends StatelessWidget {
  final Widget child;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  const ContainerWIthBoxShadow({Key? key, required this.child, this.width, this.margin, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: child,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              TextButton(onPressed: viewAllCallback, child: Text(leftText)),
            ],
          ),
        ),
        child,
      ],
    );
  }
}

enum TimePeriod { week, month, year }