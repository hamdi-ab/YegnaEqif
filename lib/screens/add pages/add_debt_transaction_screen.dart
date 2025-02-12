import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yegna_eqif_new/models/debt.dart';
import 'package:yegna_eqif_new/screens/add%20pages/add_transaction_screen.dart';
import 'package:yegna_eqif_new/screens/dashboard/dashboard_screen.dart';
import '../../providers/debt_provider.dart';
import '../../utils/transaction_handler.dart';

class AddDebtTransactionScreen extends ConsumerStatefulWidget {
  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends ConsumerState<AddDebtTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  String _personName = '';
  double _totalAmount = 0.0;
  DateTime? _selectedDate;
  String _transactionType = 'lent';
  String _selectedBank = "Cash";

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newTransaction = Debt(
        id: UniqueKey().toString(), // Generate a unique ID
        personName: _personName,
        remainingAmount: _totalAmount,
        totalAmount: _totalAmount,
        bankType: _selectedBank,
        dueDate: _selectedDate ?? DateTime.now().add(Duration(days: 30)),
        progress: 0.0, // Default progress
        transactionType: _transactionType,
      );

      ref
          .read(borrowOrDebtProvider.notifier)
          .addTransaction(newTransaction);

      final transactionHandler = TransactionHandler(ref: ref);

      if (_transactionType == 'lent') {
        transactionHandler.handleLendingAndBorrowing(_selectedBank, _totalAmount, true);
      } else if (_transactionType == 'borrowed') {
        transactionHandler.handleLendingAndBorrowing(_selectedBank, _totalAmount, false);

      }

      Navigator.of(context).pop(); // Go back to the previous screen
    }
  }

  void _updateAmount(String amount) {
    setState(() {
      _totalAmount = double.parse(amount);
    });
  }

  void _updateIncomeExpense(String type) {
    setState(() {
      _transactionType = type;
    });
  }

  void _updateSelectedBank(String bank) {
    setState(() {
      _selectedBank = bank;
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
        title: Text('Add Debt'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Toggle(onToggle: _updateIncomeExpense, labels: ["Lent", "borrowed"]),
              SizedBox(height: 20),
              BankCardDropdown(onBankSelected: _updateSelectedBank),
              SizedBox(height: 20.0),
              ContainerWIthBoxShadow(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Person Name',
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _personName = value!;
                  },
                ),
              ),
              SizedBox(height: 16),
              EnterAmountTile(onAmountSaved: _updateAmount),
              SizedBox(height: 16),
              SelectDateWidget(label: 'Select Date', firstDay: DateTime.now(), lastDay: DateTime(2050), onDateSelected: _updateDueDate),
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextButton(
                  onPressed: _submitForm,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue, // Change color based on validation
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    minimumSize: Size(double.infinity, 50), // Make the button cover the full width
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension StringCasingExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }
}



