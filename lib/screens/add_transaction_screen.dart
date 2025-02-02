import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yegna_eqif_new/screens/add_bank_card_page.dart';
import 'package:yegna_eqif_new/screens/add_category_screen.dart';

import '../models/category.dart';
import '../providers/card_provider.dart';
import '../providers/category_provider.dart';
import '../services/firestore_service.dart';


class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> selectedCategory = {
    "label": "Select Category",
    "icon": Icons.category,
    "backgroundColor": Colors.grey.shade300
  };
  final TextEditingController noteController = TextEditingController();
  String _enteredAmount = "";
  String _selectedBank = "CBE";
  String _incomeExpense = "Income"; // Default toggle value
  DateTime? _selectedDate;
  bool isCategorySelected = false;

  void _saveTransaction() {
    if (_formKey.currentState!.validate() && isCategorySelected) {
      final transactionData = {
        "type": _incomeExpense,
        "category": selectedCategory['label'],
        "bank": _selectedBank,
        "date": _selectedDate != null
            ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
            : "No Date Selected",
        "amount": _enteredAmount,
        "note": noteController.text.isNotEmpty ? noteController.text : null,
      };

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaction Saved: $transactionData')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter all required fields.')),
      );
    }
  }

  void _updateAmount(String amount) {
    setState(() {
      _enteredAmount = amount;
    });
  }

  void _updateCategory(category) {
    setState(() {
      selectedCategory = category;
      isCategorySelected = true;
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
                IncomeExpenseToggle(),
                SizedBox(height: 20),
                BankCardDropdown(),
                SizedBox(height: 16),
                // EnterAmountTile calls _updateAmount when an amount is entered
                EnterAmountTile(onAmountSaved: _updateAmount),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryListPage(
                            onCategorySelected: _updateCategory,
                            userId: 'user123',
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: selectedCategory['backgroundColor'],
                        child: Icon(
                          selectedCategory['icon'],
                          color: selectedCategory['color'],
                        ),
                      ),
                      title: Text(
                        selectedCategory['label'],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.grey.shade300,
                        child: const Icon(
                          Icons.edit,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        width: 14,
                      ),
                      SizedBox(
                        width: 270,
                        child: TextFormField(
                          controller: noteController,
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(fontWeight: FontWeight.bold),
                            hintText: 'Write Note',
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ],
                  ),
                ),
                SelectDateWidget(),
                SizedBox(height: 20),
                // SaveButton validates if all inputs are provided
                SaveButton(
                  isValid: _formKey.currentState?.validate() ?? false && isCategorySelected && _enteredAmount.isNotEmpty,
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
        onPressed: isValid ? onSave : null, // Disable button if not valid
        style: TextButton.styleFrom(
          backgroundColor: isValid ? Colors.blue : Colors.grey, // Change color based on validation
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
    );
  }
}


class IncomeExpenseToggle extends StatefulWidget {
  const IncomeExpenseToggle({super.key});

  @override
  _IncomeExpenseToggleState createState() => _IncomeExpenseToggleState();
}

class _IncomeExpenseToggleState extends State<IncomeExpenseToggle> {
  int selectedIndex = 0; // Tracks the selected option

  final List<String> labels = ["Income", "Expense"]; // Toggle labels

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade300, // Background color for the toggle
        borderRadius: BorderRadius.circular(16), // Rounded corners
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final isSelected =
              index == selectedIndex; // Check if this is selected
          return Expanded(
            // Ensures buttons are evenly spaced
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index; // Update selected index on tap
                });
              },
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.blue
                      : Colors.transparent, // Active tab background color
                  borderRadius:
                      BorderRadius.circular(12), // Rounded corners for tabs
                ),
                alignment: Alignment.center,
                child: Text(
                  labels[index],
                  style: TextStyle(
                    fontSize: 16,
                    color: isSelected
                        ? Colors.white
                        : Colors.black54, // Text color
                    fontWeight: FontWeight.w600, // Slightly bolder font
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


class EnterAmountTile extends StatefulWidget {
  final Function(String) onAmountSaved;

  EnterAmountTile({required this.onAmountSaved});

  @override
  _EnterAmountTileState createState() => _EnterAmountTileState();
}

class _EnterAmountTileState extends State<EnterAmountTile> {
  String _enteredAmount = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddPage(initialAmount: _enteredAmount)),
        );
        if (result != null) {
          setState(() {
            _enteredAmount = result;
          });
          widget.onAmountSaved(_enteredAmount); // Call the callback
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 17),
        decoration: BoxDecoration(
          color: Colors.white, // White background for each transaction
          borderRadius: BorderRadius.circular(16), // Rounded corners
          boxShadow: [
            // Bottom shadow for elevation
            BoxShadow(
              color: Colors.black.withOpacity(0.15), // Subtle shadow
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 4), // Bottom shadow
            ),
            // Light top shadow for visibility
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              spreadRadius: -1,
              offset: const Offset(0, -2), // Top shadow
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(
            "Enter amount",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          trailing: Text(
            _enteredAmount.isEmpty ? "\$00.00" : "\$$_enteredAmount",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}


class AddPage extends StatefulWidget {
  final String initialAmount;

  const AddPage({Key? key, required this.initialAmount}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  late TextEditingController _amountController;
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.initialAmount);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  void _saveAmount() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pop(context, _amountController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Enter Amount',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200, // Adjust the width as needed
                        child: TextFormField(
                          focusNode: _focusNode,
                          controller: _amountController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true), // For decimal input
                          textInputAction: TextInputAction.none, // Remove "check" button
                          decoration: InputDecoration(
                            hintText: "\$00.00",
                            hintStyle: TextStyle(fontSize: 48, color: Colors.grey.shade500),
                            filled: true,
                            fillColor: Colors.transparent, // Transparent background
                            border: InputBorder.none,
                          ),
                          style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an amount';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: _saveAmount,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  minimumSize: Size(double.infinity, 50), // Make the button cover the full width
                ),
                child: Text(
                  'Add Amount',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
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



class BankCardDropdown extends ConsumerStatefulWidget {
  const BankCardDropdown({super.key});

  @override
  _BankCardDropdownState createState() => _BankCardDropdownState();
}

class _BankCardDropdownState extends ConsumerState<BankCardDropdown> {
  late String selectedCardName; // Declare selectedCardName
  late double selectedCardBalance; // Declare selectedCardBalance
  bool _isExpanded = false; // Expansion state

  @override
  void initState() {
    super.initState();
    // Initialize with the first card (cash card)
    final cashCard = ref.read(cashCardProvider);
    selectedCardName = 'Cash';
    selectedCardBalance = cashCard.balance;
  }

  @override
  Widget build(BuildContext context) {
    final cashCard = ref.watch(cashCardProvider);
    final bankAccountCards = ref.watch(bankAccountCardsProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
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
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              children: [
                // Leading Icon
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: const Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),

                // Bank Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedCardName, // Dynamic card name
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${selectedCardBalance.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // Dropdown Icon
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
              ],
            ),
          ),
          if (_isExpanded)
            Column(
              children: [
                ListTile(
                  title: Text('Cash'),
                  onTap: () {
                    setState(() {
                      selectedCardName = 'Cash';
                      selectedCardBalance = cashCard.balance;
                      _isExpanded = false;
                    });
                  },
                ),
                Divider(
                  height: 1,
                  color: Colors.grey.shade300,
                ),
                ...bankAccountCards.map((card) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(card.accountName),
                        onTap: () {
                          setState(() {
                            selectedCardName = card.accountName;
                            selectedCardBalance = card.balance;
                            _isExpanded = false;
                          });
                        },
                      ),
                      Divider(
                        height: 1,
                        color: Colors.grey.shade300,
                      ),
                    ],
                  );
                }).toList(),
                ListTile(
                  leading: Icon(Icons.add, color: Colors.blue),
                  title: Text("Add Bank or Wallet"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddBankCardPage()),
                    );
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}



class CategoryListPage extends ConsumerStatefulWidget {
  final Function(Category) onCategorySelected;
  final String userId;

  CategoryListPage({required this.userId, required this.onCategorySelected, Key? key}) : super(key: key);

  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends ConsumerState<CategoryListPage> {
  @override
  void initState() {
    super.initState();
    // Fetch categories when the widget is built
    Future.microtask(() => ref.read(categoryProvider.notifier).fetchCategories());
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Category'),
      ),
      body: Container(
        margin: const EdgeInsets.all(16), // Add margin for outer spacing
        padding: const EdgeInsets.all(16), // Padding inside the container
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: categories.isEmpty
            ? const Center(child: CircularProgressIndicator()) // Loading State
            : GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // Number of items per row
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8, // Adjust aspect ratio for proper layout
          ),
          itemCount: categories.length + 1, // Add one for the "Add" option
          itemBuilder: (context, index) {
            if (index == categories.length) {
              // Render the "Add" category option
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

            return GestureDetector(
              onTap: () {
                // Pass the selected category back to the previous screen
                widget.onCategorySelected(category);
                Navigator.pop(context);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 24, // Adjust radius as needed
                    backgroundColor: category.color.withOpacity(0.2),
                    child: Icon(
                      category.icon,
                      color: category.color,
                      size: 20, // Adjust size to fit within the circle
                    ),
                  ),
                  const SizedBox(height: 4), // Space between the icon and the text
                  Text(
                    category.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12), // Adjust font size
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // Prevent text overflow
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}






class SelectDateWidget extends StatefulWidget {
  @override
  _SelectDateWidgetState createState() => _SelectDateWidgetState();
}

class _SelectDateWidgetState extends State<SelectDateWidget> {
  DateTime? selectedDate;
  Color iconColor = Colors.grey;
  Color backgroundColor = Colors.grey.shade300;

  void _onDateChanged(DateTime date) {
    setState(() {
      selectedDate = date;
      iconColor = Colors.blue;
      backgroundColor = Colors.blue.withOpacity(0.2);
    });
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));

    if (date == today) {
      return 'Today';
    } else if (date == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          // Show the BottomSheet when the container is tapped
          showModalBottomSheet(
            context: context,
            isScrollControlled: true, // Allows flexible height
            backgroundColor: Colors.transparent, // Makes it look like a card
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min, // Adjust height based on content
                      children: [
                        const Text(
                          'Select Date',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        CalendarDatePicker(
                          initialDate: selectedDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                          onDateChanged: (date) {
                            setState(() {
                              selectedDate = date;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            DateTime dateToSet = selectedDate ?? DateTime.now();
                            _onDateChanged(selectedDate ?? DateTime.now());
                            Navigator.pop(context);
                            setState(() {
                              selectedDate = dateToSet;
                            }); // Close the bottom sheet
                          },
                          child: const Text('Set Date',
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Button color
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: backgroundColor,
            child: Icon(
              Icons.calendar_today,
              color: iconColor,
            ),
          ),
          title: Text(
            selectedDate != null
                ? formatDate(selectedDate!)
                : 'Set Date', // Title
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
//
// class SaveButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: TextButton(
//         onPressed: () {
//         },
//         style: TextButton.styleFrom(
//           backgroundColor: Colors.blue,
//           padding: const EdgeInsets.symmetric(vertical: 10),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           minimumSize: Size(double.infinity, 50), // Make the button cover the full width
//         ),
//         child: const Text(
//           'Save',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.w500,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }

