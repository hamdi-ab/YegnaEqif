import 'package:flutter/material.dart';

class BudgetCategory {
  final String name;
  double limit;
  double spent;

  BudgetCategory({
    required this.name,
    required this.limit,
    this.spent = 0,
  });
}

class ManageBudgetPage extends StatefulWidget {
  @override
  _ManageBudgetPageState createState() => _ManageBudgetPageState();
}

class _ManageBudgetPageState extends State<ManageBudgetPage> {
  final List<BudgetCategory> _budgetCategories = [
    BudgetCategory(name: 'Groceries', limit: 500),
    BudgetCategory(name: 'Transport', limit: 200),
    BudgetCategory(name: 'Entertainment', limit: 300),
  ];

  void _addNewCategory() {
    showDialog(
      context: context,
      builder: (context) => _BudgetCategoryDialog(
        onSave: (name, limit) {
          setState(() {
            _budgetCategories.add(
              BudgetCategory(name: name, limit: limit),
            );
          });
        },
      ),
    );
  }

  void _editCategory(int index) {
    final category = _budgetCategories[index];
    showDialog(
      context: context,
      builder: (context) => _BudgetCategoryDialog(
        initialName: category.name,
        initialLimit: category.limit.toString(),
        onSave: (name, limit) {
          setState(() {
            _budgetCategories[index] = BudgetCategory(
              name: name,
              limit: limit,
              spent: category.spent,
            );
          });
        },
      ),
    );
  }

  void _deleteCategory(int index) {
    setState(() {
      _budgetCategories.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Budget'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Add additional settings functionality
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _budgetCategories.length,
        itemBuilder: (context, index) {
          final category = _budgetCategories[index];
          return Dismissible(
            key: Key(category.name),
            background: Container(color: Colors.red),
            confirmDismiss: (direction) async {
              return await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Delete Category'),
                  content: Text('Are you sure you want to delete ${category.name}?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
            onDismissed: (direction) => _deleteCategory(index),
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Icon(Icons.category, color: Colors.blue),
                ),
                title: Text(
                  category.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: category.spent / category.limit,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getProgressColor(category.spent / category.limit),
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Spent: \$${category.spent.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          'Limit: \$${category.limit.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.edit, size: 20),
                  onPressed: () => _editCategory(index),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addNewCategory,
        tooltip: 'Add New Category',
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress < 0.5) return Colors.green;
    if (progress < 0.8) return Colors.orange;
    return Colors.red;
  }
}

class _BudgetCategoryDialog extends StatefulWidget {
  final String? initialName;
  final String? initialLimit;
  final Function(String, double) onSave;

  const _BudgetCategoryDialog({
    this.initialName,
    this.initialLimit,
    required this.onSave,
  });

  @override
  __BudgetCategoryDialogState createState() => __BudgetCategoryDialogState();
}

class __BudgetCategoryDialogState extends State<_BudgetCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _limitController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _limitController = TextEditingController(text: widget.initialLimit);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialName == null ? 'New Category' : 'Edit Category'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Category Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a category name';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _limitController,
              decoration: InputDecoration(
                labelText: 'Monthly Limit',
                border: OutlineInputBorder(),
                prefixText: '\$',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a budget limit';
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
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveForm,
          child: Text('Save'),
        ),
      ],
    );
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(
        _nameController.text,
        double.parse(_limitController.text),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _limitController.dispose();
    super.dispose();
  }
}