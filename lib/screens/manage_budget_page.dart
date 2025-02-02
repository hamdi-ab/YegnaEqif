import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yegna_eqif_new/providers/category_provider.dart';
import '../models/budget.dart';
import '../models/category.dart';
import '../providers/budget_provider.dart';

class ManageBudgetPage extends ConsumerWidget {
  const ManageBudgetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgets = ref.watch(budgetProvider);
    final categories = ref.watch(categoryProvider);

    Category getCategoryDetails(String categoryId) {
      return categories.firstWhere(
            (cat) => cat.id == categoryId,
        orElse: () => Category(id: '', name: 'Unknown', icon: Icons.category, color: Colors.grey),
      );
    }

    void _addNewBudget() {
      showDialog(
        context: context,
        builder: (context) => _BudgetDialog(
          onSave: (categoryId, allocatedAmount) {
            ref.read(budgetProvider.notifier).addBudget(
              Budget(
                id: DateTime.now().toString(),
                categoryId: categoryId,
                allocatedAmount: allocatedAmount,
                spentAmount: 0,
                startDate: DateTime.now(),
                endDate: DateTime.timestamp()
              ),
            );
          },
        ),
      );
    }

    void _editBudget(Budget budget) {
      showDialog(
        context: context,
        builder: (context) => _BudgetDialog(
          initialCategoryId: budget.categoryId,
          initialAllocatedAmount: budget.allocatedAmount.toString(),
          onSave: (categoryId, allocatedAmount) {
            ref.read(budgetProvider.notifier).updateBudget(
              Budget(
                id: budget.id,
                categoryId: categoryId,
                allocatedAmount: allocatedAmount,
                spentAmount: budget.spentAmount,
                startDate: budget.startDate,
                endDate: budget.endDate
              ),
            );
          },
        ),
      );
    }

    void _deleteBudget(String id) {
      ref.read(budgetProvider.notifier).deleteBudget(id);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Budget'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Add additional settings functionality
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: budgets.length,
        itemBuilder: (context, index) {
          final budget = budgets[index];
          final category = getCategoryDetails(budget.categoryId);
          final double progress = budget.spentAmount / budget.allocatedAmount;

          return Dismissible(
            key: Key(budget.id),
            background: Container(
              margin: EdgeInsets.symmetric(vertical: 6.0),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(16)
                ),
              child: Icon(Icons.delete, color: Colors.white,),
            ),
            confirmDismiss: (direction) async {
              return await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Budget'),
                  content: Text('Are you sure you want to delete this budget for ${budget.categoryId}?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
            onDismissed: (direction) => _deleteBudget(budget.id),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15), // Subtle shadow
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, 4), // Bottom shadow
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05), // Lighter top shadow
                    blurRadius: 8,
                    spreadRadius: -1,
                    offset: const Offset(0, -2), // Top shadow
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon and Label Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: category.color.withOpacity(0.2),
                            child: Icon(
                              category.icon,
                              color: category.color,
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
                                '\$${budget.allocatedAmount.toStringAsFixed(0)} total',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(width: 16,),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () => _editBudget(budget),
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
                            category.color,
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
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: _addNewBudget,
        tooltip: 'Add New Budget',
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress < 0.5) return Colors.green;
    if (progress < 0.8) return Colors.orange;
    return Colors.red;
  }
}

class _BudgetDialog extends StatefulWidget {
  final String? initialCategoryId;
  final String? initialAllocatedAmount;
  final Function(String, double) onSave;

  const _BudgetDialog({
    this.initialCategoryId,
    this.initialAllocatedAmount,
    required this.onSave,
  });

  @override
  __BudgetDialogState createState() => __BudgetDialogState();
}

class __BudgetDialogState extends State<_BudgetDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _categoryIdController;
  late TextEditingController _allocatedAmountController;

  @override
  void initState() {
    super.initState();
    _categoryIdController = TextEditingController(text: widget.initialCategoryId);
    _allocatedAmountController = TextEditingController(text: widget.initialAllocatedAmount);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialCategoryId == null ? 'New Budget' : 'Edit Budget'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _categoryIdController,
              decoration: const InputDecoration(
                labelText: 'Category ID',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a category ID';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _allocatedAmountController,
              decoration: const InputDecoration(
                labelText: 'Allocated Amount',
                border: OutlineInputBorder(),
                prefixText: '\$',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an allocated amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveForm,
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(
        _categoryIdController.text,
        double.parse(_allocatedAmountController.text),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _categoryIdController.dispose();
    _allocatedAmountController.dispose();
    super.dispose();
  }
}
