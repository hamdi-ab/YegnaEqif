import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:yegna_eqif_new/screens/dashboard_screen.dart';

import '../models/bank_account.dart';
import '../providers/bank_account_provider.dart';

class AddBankCardPage extends ConsumerStatefulWidget {
  const AddBankCardPage({Key? key}) : super(key: key);

  @override
  _AddBankCardPageState createState() => _AddBankCardPageState();
}

class _AddBankCardPageState extends ConsumerState<AddBankCardPage> {
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _balanceController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Color _selectedColor = Colors.purple; // Default color

  void _selectColor(Color color) {
    setState(() {
      _selectedColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Bank Card'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ContainerWIthBoxShadow(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      child: SizedBox(
                        width: 250,
                        child: TextFormField(
                          controller: _accountNameController,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(fontWeight: FontWeight.bold),
                            hintText: 'Bank Account Name',
                            border: InputBorder.none,
                            errorStyle: TextStyle(color: Colors.red),
                          ),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Bank account name is required';
                            }
                            return null;
                          },
                        ),
                      )),
                  ContainerWIthBoxShadow(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      child: SizedBox(
                        width: 250,
                        child: TextFormField(
                          controller: _accountNumberController,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(fontWeight: FontWeight.bold),
                            hintText: 'Account Number',
                            border: InputBorder.none,
                            errorStyle: TextStyle(color: Colors.red),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Account number is required';
                            }
                            return null;
                          },
                        ),
                      )),
                  ContainerWIthBoxShadow(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      child: SizedBox(
                        width: 250,
                        child: TextFormField(
                          controller: _balanceController,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(fontWeight: FontWeight.bold),
                            hintText: 'Balance',
                            border: InputBorder.none,
                            errorStyle: TextStyle(color: Colors.red),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Balance is required';
                            }
                            return null;
                          },
                        ),
                      )),
                  ContainerWIthBoxShadow(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Select Color:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        trailing: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: BlockPicker(
                                    pickerColor: _selectedColor,
                                    onColorChanged: _selectColor,
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Select'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Icon(Icons.circle, color: _selectedColor),
                        ),
                      )),
                  const SizedBox(height: 24),
                  Center(
                    child: TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final String accountName =
                              _accountNameController.text;
                          final String accountNumber =
                              _accountNumberController.text;
                          final double balance =
                              double.parse(_balanceController.text);

                          final newBankCard = BankAccountCardModel(
                            id: UniqueKey().toString(), // Generate a unique ID
                            accountName: accountName,
                            accountNumber: accountNumber,
                            balance: balance,
                            cardColor: _selectedColor,
                          );

                          ref
                              .read(bankAccountProvider.notifier)
                              .addBankAccount(newBankCard);

                          Navigator.pop(context); // Close the page
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        minimumSize: Size(double.infinity,
                            50), // Make the button cover the full width
                      ),
                      child: const Text(
                        'Add Bank Card',
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
        ));
  }
}
