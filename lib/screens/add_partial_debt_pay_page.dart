import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/transaction_handler.dart';
import 'add_transaction_screen.dart';
import 'dashboard_screen.dart';

class AddPartialDebtPayPage extends ConsumerStatefulWidget {
  const AddPartialDebtPayPage({required this.debtId, required this.transactionType, required this.personName, required this.remainingAmount, super.key});
  final String debtId;
  final String transactionType;
  final String personName;
  final double remainingAmount;

  @override
  _AddPartialDebtPayPageState createState() => _AddPartialDebtPayPageState();
}

class _AddPartialDebtPayPageState extends ConsumerState<AddPartialDebtPayPage> {

  final _formKey = GlobalKey<FormState>();
  double _totalAmount = 0.0;
  String _selectedBank = "Cash";

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final transactionHandler = TransactionHandler(ref: ref);

      if (widget.transactionType == 'lent') {
        await transactionHandler.adjustDebtWhenSomeonePays(widget.debtId, _totalAmount);
        transactionHandler.handleLendingAndBorrowing(_selectedBank, _totalAmount, false);
      } else if (widget.transactionType == 'borrowed') {
        await transactionHandler.adjustDebtWhenYouPay(widget.debtId, _totalAmount);
        transactionHandler.handleLendingAndBorrowing(_selectedBank, _totalAmount, true);

      }

      Navigator.of(context).pop(); // Go back to the previous screen
    }
  }

  void _updateAmount(String amount) {
    setState(() {
      _totalAmount = double.parse(amount);
    });
  }


  void _updateSelectedBank(String bank) {
    setState(() {
      _selectedBank = bank;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pay Back'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              BankCardDropdown(onBankSelected: _updateSelectedBank),
              SizedBox(height: 20.0),
              ContainerWIthBoxShadow(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                child: Text('${widget.personName}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              ),
              SizedBox(height: 16),
              ContainerWIthBoxShadow(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Remaining Amount:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    Text('${widget.remainingAmount} Br.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
                  ],
                ),
              ),
              SizedBox(height: 16),
              EnterAmountTile(onAmountSaved: _updateAmount),
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
