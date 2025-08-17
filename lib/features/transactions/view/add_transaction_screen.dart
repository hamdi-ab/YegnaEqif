
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:yegna_eqif_new/features/budget/viewmodel/budget_viewmodel.dart';
import 'package:yegna_eqif_new/features/transactions/viewmodel/transaction_viewmodel.dart';
import 'package:yegna_eqif_new/models/category.dart';
import 'package:yegna_eqif_new/features/transactions/model/transaction.dart';

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  Category? selectedCategory;
  final TextEditingController noteController = TextEditingController();
  String _enteredAmount = "";
  String _selectedBank = "Cash";
  String _incomeExpense = "Income";
  DateTime? _selectedDate;
  bool isCategorySelected = false;

  void _saveTransaction() async {
    if (_formKey.currentState!.validate() && isCategorySelected) {
      final transaction = Transaction(
        id: UniqueKey().toString(),
        type: _incomeExpense,
        name: noteController.text,
        bankType: _selectedBank,
        category: selectedCategory!.name,
        amount: double.parse(_enteredAmount),
        date: _selectedDate ?? DateTime.now(),
      );

      context.read<TransactionViewModel>().addTransaction(transaction);

      if (transaction.type == 'Expense') {
        final budgetViewModel = context.read<BudgetViewModel>();
        final budgetToUpdate = budgetViewModel.budgets.firstWhere(
          (b) => b.category == transaction.category,
        );
        final updatedBudget = Budget(
          id: budgetToUpdate.id,
          category: budgetToUpdate.category,
          allocatedAmount: budgetToUpdate.allocatedAmount,
          spentAmount: budgetToUpdate.spentAmount + transaction.amount,
          startDate: budgetToUpdate.startDate,
          endDate: budgetToUpdate.endDate,
        );
        budgetViewModel.updateBudget(updatedBudget);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaction Saved')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter all required fields.')),
      );
    }
  }

  void _updateSelectedBank(String bank) {
    setState(() {
      _selectedBank = bank;
    });
  }

  void _updateAmount(String amount) {
    setState(() {
      _enteredAmount = amount;
    });
  }

  void _updateIncomeExpense(String type) {
    setState(() {
      _incomeExpense = type;
    });
  }

  void _updateCategory(Category category) {
    setState(() {
      selectedCategory = category;
      isCategorySelected = true;
    });
  }

  void _updateDueDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transactions'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20),
                Toggle(onToggle: _updateIncomeExpense, labels: ["Income", "Expense"]),
                SizedBox(height: 20),
                // BankCardDropdown(onBankSelected: _updateSelectedBank), // TODO: Refactor
                SizedBox(height: 16),
                ContainerWIthBoxShadow(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
                  child: TextFormField(
                    controller: noteController,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(fontWeight: FontWeight.bold),
                      hintText: 'Enter Name',
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                ),
                // EnterAmountTile(onAmountSaved: _updateAmount), // TODO: Refactor
                ContainerWIthBoxShadow(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => CategoryListPage(
                      //       onCategorySelected: _updateCategory,
                      //       userId: 'user123',
                      //     ),
                      //   ),
                      // );
                    },
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: selectedCategory != null ? selectedCategory!.color.withOpacity(0.2) : Colors.grey.shade300,
                        child: Icon(
                          selectedCategory != null ? selectedCategory!.icon : Icons.category,
                          color: selectedCategory != null ? selectedCategory!.color : Colors.black54,
                        ),
                      ),
                      title: Text(
                        selectedCategory != null ? selectedCategory!.name : 'Select Category',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                    ),
                  ),
                ),
                // SelectDateWidget(label: 'Set Date', firstDay: DateTime(2000), lastDay: DateTime.now(), onDateSelected: _updateDueDate), // TODO: Refactor
                SizedBox(height: 20),
                SaveButton(
                  isValid: (_formKey.currentState?.validate() ?? false) &&
                      isCategorySelected &&
                      _enteredAmount.isNotEmpty,
                  onSave: _saveTransaction,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SaveButton extends StatelessWidget {
  final bool isValid;
  final VoidCallback onSave;

  SaveButton({required this.isValid, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextButton(
        onPressed: isValid ? onSave : null,
        style: TextButton.styleFrom(
          backgroundColor: isValid ? Colors.blue : Colors.grey,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          minimumSize: Size(double.infinity, 50),
        ),
        child: const Text(
          'Save',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class Toggle extends StatefulWidget {
  final Function(String) onToggle;
  final List<String> labels;

  const Toggle({required this.onToggle, Key? key, required this.labels}) : super(key: key);

  @override
  _ToggleState createState() => _ToggleState();
}

class _ToggleState extends State<Toggle> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: List.generate(widget.labels.length, (index) {
          final isSelected = index == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
                widget.onToggle(widget.labels[index]);
              },
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.labels[index],
                  style: TextStyle(
                    fontSize: 16,
                    color: isSelected ? Colors.white : Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class ContainerWIthBoxShadow extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final EdgeInsetsGeometry? padding;

  const ContainerWIthBoxShadow({
    Key? key,
    required this.child,
    this.margin,
    this.width,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      padding: padding,
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
      child: child,
    );
  }
}
