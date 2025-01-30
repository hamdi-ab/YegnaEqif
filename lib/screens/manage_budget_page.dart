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
                date: DateTime.now(),
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
                date: budget.date,
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
          return Dismissible(
            key: Key(budget.id),
            background: Container(color: Colors.red),
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
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  radius: 20,
                  backgroundColor: category.color,
                  child: Icon(
                    category.icon,color: Colors.white,
                  ),
                ),
                title: Text(
                  category.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: budget.spentAmount / budget.allocatedAmount,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getProgressColor(budget.spentAmount / budget.allocatedAmount),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Spent: \$${budget.spentAmount.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          'Limit: \$${budget.allocatedAmount.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _editBudget(budget),
                ),
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
