import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yegna_eqif_new/screens/add_partial_debt_pay_page.dart';

import '../models/debt.dart';
import '../providers/debt_provider.dart';

class DebtTrackerPage extends ConsumerStatefulWidget {
  @override
  _DebtTrackerPageState createState() => _DebtTrackerPageState();
}

class _DebtTrackerPageState extends ConsumerState<DebtTrackerPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(borrowOrDebtProvider);
    final lentTransactions = transactions
        .where((transaction) => transaction.transactionType == 'lent')
        .toList();
    final borrowedTransactions = transactions
        .where((transaction) => transaction.transactionType == 'borrowed')
        .toList();

    final double totalLentAmount = lentTransactions.fold(
        0.0, (sum, transaction) => sum + transaction.totalAmount);
    final double totalOwedAmount = borrowedTransactions.fold(
        0.0, (sum, transaction) => sum + transaction.totalAmount);
    final int lentPeopleCount = lentTransactions.length;
    final int borrowedPeopleCount = borrowedTransactions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Debt Tracker'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top card with two columns
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    spreadRadius: -1,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Money Lent',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${totalLentAmount.toStringAsFixed(2)} Br.',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Icon(Icons.person, color: Colors.grey, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'People: $lentPeopleCount',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Money Owed',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${totalOwedAmount.toStringAsFixed(2)} Br.',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.person, color: Colors.grey, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'People: $borrowedPeopleCount',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  // Add an icon
                  child: Text(
                    'Lent',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                ),
                Tab(
                  child: Text(
                    'Owed',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                ),
              ],
              labelColor: Colors.blue, // Color of selected tab
              unselectedLabelColor: Colors.grey, // Color of unselected tab
              indicatorColor:
                  Colors.blue, // Color of the indicator below the selected tab
              indicatorWeight: 6.0, // Thickness of the indicator
            ),

            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab view for "Lent"
                  ListView.builder(
                    itemCount: lentTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = lentTransactions[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 10,
                              spreadRadius: 1,
                              offset: const Offset(0, 4),
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              spreadRadius: -1,
                              offset: const Offset(0, -1),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(0),
                          leading: CircleAvatar(
                            backgroundColor: Colors.green.withOpacity(0.1),
                            radius: 24,
                            child: Icon(Icons.person, color: Colors.green, size: 24),
                          ),
                          title: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    transaction.personName,
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Remaining: ${transaction.remainingAmount.toStringAsFixed(2)} Br.',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Amount: ${transaction.totalAmount.toStringAsFixed(2)} Br.',
                                    style: TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                  Text(
                                    'Days Left: ${transaction.daysLeft}',
                                    style: TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: transaction.progress,
                                backgroundColor: Colors.grey[300],
                                color: Colors.green,
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            icon: Icon(Icons.more_vert),
                            onSelected: (value) async {
                              if (value == 'Edit') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditDebtPage(debt: transaction),
                                  ),
                                );
                              } else if (value == 'Delete') {
                                bool deleteConfirmed = await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Delete Debt'),
                                    content: Text('Are you sure you want to delete this debt for ${transaction.personName}?'),
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
                                if (deleteConfirmed) {
                                  ref.read(borrowOrDebtProvider.notifier).removeTransaction(transaction.id);
                                }
                              } else if (value == 'Pay') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddPartialDebtPayPage(
                                      debtId: transaction.id,
                                      transactionType: transaction.transactionType,
                                      personName: transaction.personName,
                                      remainingAmount: transaction.remainingAmount,
                                    ),
                                  ),
                                );
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem<String>(
                                  value: 'Edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, size: 18),
                                      SizedBox(width: 8),
                                      Text('Edit'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  value: 'Delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, size: 18),
                                      SizedBox(width: 8),
                                      Text('Delete'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  value: 'Pay',
                                  child: Row(
                                    children: [
                                      Icon(Icons.payments, size: 18),
                                      SizedBox(width: 8),
                                      Text('Pay'),
                                    ],
                                  ),
                                ),
                              ];
                            },
                          ),
                        ),
                      );
                    },
                  )
                  ,

                  // Tab view for "Owed"
                  ListView.builder(
                    itemCount: borrowedTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = borrowedTransactions[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 2),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 10,
                              spreadRadius: 1,
                              offset: const Offset(0, 4),
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              spreadRadius: -1,
                              offset: const Offset(0, -1),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(0),
                          leading: CircleAvatar(
                            backgroundColor: Colors.red.withOpacity(0.1),
                            radius: 24,
                            child:
                                Icon(Icons.person, color: Colors.red, size: 24),
                          ),
                          title: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    transaction.personName,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Remaining: ${transaction.remainingAmount.toStringAsFixed(2)} Br.',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Amount: ${transaction.totalAmount.toStringAsFixed(2)} Br.',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                  Text(
                                    'Days Left: ${transaction.daysLeft}',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: transaction.progress,
                                backgroundColor: Colors.grey[300],
                                color: Colors.red,
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            icon: Icon(Icons.more_vert),
                            onSelected: (value) async {
                              if (value == 'Edit') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditDebtPage(debt: transaction),
                                  ),
                                );
                              } else if (value == 'Delete') {
                                bool deleteConfirmed = await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Delete Debt'),
                                    content: Text('Are you sure you want to delete this debt for ${transaction.personName}?'),
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
                                if (deleteConfirmed) {
                                  ref.read(borrowOrDebtProvider.notifier).removeTransaction(transaction.id);
                                }
                              } else if (value == 'Pay') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddPartialDebtPayPage(
                                      debtId: transaction.id,
                                      transactionType: transaction.transactionType,
                                      personName: transaction.personName,
                                      remainingAmount: transaction.remainingAmount,
                                    ),
                                  ),
                                );
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem<String>(
                                  value: 'Edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, size: 18),
                                      SizedBox(width: 8),
                                      Text('Edit'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  value: 'Delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, size: 18),
                                      SizedBox(width: 8),
                                      Text('Delete'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  value: 'Pay',
                                  child: Row(
                                    children: [
                                      Icon(Icons.payments, size: 18),
                                      SizedBox(width: 8),
                                      Text('Pay'),
                                    ],
                                  ),
                                ),
                              ];
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class EditDebtPage extends ConsumerStatefulWidget {
  final Debt debt;

  const EditDebtPage({super.key, required this.debt});

  @override
  _EditDebtPageState createState() => _EditDebtPageState();
}

class _EditDebtPageState extends ConsumerState<EditDebtPage> {
  final _formKey = GlobalKey<FormState>();
  late String personName;
  late double remainingAmount;
  late double totalAmount;
  late String bankType;
  late DateTime dueDate;
  late String transactionType;

  @override
  void initState() {
    super.initState();
    personName = widget.debt.personName;
    remainingAmount = widget.debt.remainingAmount;
    totalAmount = widget.debt.totalAmount;
    bankType = widget.debt.bankType;
    dueDate = widget.debt.dueDate;
    transactionType = widget.debt.transactionType;
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != dueDate) {
      setState(() {
        dueDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final debtNotifier = ref.read(borrowOrDebtProvider.notifier);
      final updatedDebt = Debt(
        id: widget.debt.id,
        personName: personName,
        remainingAmount: remainingAmount,
        totalAmount: totalAmount,
        bankType: bankType,
        dueDate: dueDate,
        progress: (totalAmount - remainingAmount) / totalAmount,
        transactionType: transactionType,
      );
      debtNotifier.updateTransaction(widget.debt.id ,updatedDebt);
      Navigator.of(context).pop();  // Go back to the previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Debt'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: personName,
                decoration: InputDecoration(labelText: 'Person Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) {
                  personName = value!;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: remainingAmount.toString(),
                decoration: InputDecoration(labelText: 'Remaining Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || double.tryParse(value) == null) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
                onSaved: (value) {
                  remainingAmount = double.parse(value!);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: totalAmount.toString(),
                decoration: InputDecoration(labelText: 'Total Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || double.tryParse(value) == null) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
                onSaved: (value) {
                  totalAmount = double.parse(value!);
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: bankType,
                decoration: InputDecoration(labelText: 'Bank Type'),
                items: <String>['Cash', 'Credit Card', 'Debit Card'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    bankType = value!;
                  });
                },
                onSaved: (value) {
                  bankType = value!;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text('Due Date: ${dueDate.toLocal().toShortDateString()}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDueDate(context),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: transactionType,
                decoration: InputDecoration(labelText: 'Transaction Type'),
                items: <String>['lent', 'borrowed'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    transactionType = value!;
                  });
                },
                onSaved: (value) {
                  transactionType = value!;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension DateTimeExtension on DateTime {
  String toShortDateString() {
    return "${this.year}-${this.month.toString().padLeft(2, '0')}-${this.day.toString().padLeft(2, '0')}";
  }
}
