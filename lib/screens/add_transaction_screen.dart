import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  Map<String, dynamic> selectedCategory = {
    "label": "Select Category",
    "icon": Icons.category,
    "backgroundColor": Colors.grey.shade300
  };
  final TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transactions'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              IncomeExpenseToggle(),
              SizedBox(height: 20),
              BankCardDropdown(),
              SizedBox(height: 16),
              EnterAmountTile(),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
                    // Navigate to the category selection page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryListPage(
                          onCategorySelected: (category) {
                            setState(() {
                              selectedCategory = category;
                            });
                          },
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                  ),
                ),
              ),
              Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
                  )),
              SelectDateWidget(),
              SizedBox(height: 20),
              SaveButton(),
            ],
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

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.initialAmount);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                        onChanged: (value) {
                          setState(() {
                            // Update as user types
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pop(context, _amountController.text);
              },
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
    );
  }
}


class BankCardDropdown extends StatefulWidget {
  const BankCardDropdown({super.key});

  @override
  _BankCardDropdownState createState() => _BankCardDropdownState();
}

class _BankCardDropdownState extends State<BankCardDropdown> {
  final List<String> banks = [
    "CBE",
    "Awash Bank",
    "Dashen Bank",
    "Add Bank or Wallet"
  ]; // Dropdown items
  late String selectedBank; // Declare selectedBank
  bool _isExpanded = false; // Expansion state

  @override
  void initState() {
    super.initState();
    selectedBank = banks[
        0]; // Ensure selectedBank matches the first item in the banks list
  }

  @override
  Widget build(BuildContext context) {
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
                        selectedBank, // Dynamic bank title
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '\$50,000',
                        style: TextStyle(
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
              children: banks.map((String bank) {
                if (bank == "Add Bank or Wallet") {
                  return ListTile(
                    leading: Icon(Icons.add, color: Colors.blue),
                    title: Text(bank),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddBankOrWalletPage()),
                      );
                    },
                  );
                }
                return Column(
                  children: [
                    ListTile(
                      title: Text(bank),
                      onTap: () {
                        setState(() {
                          selectedBank = bank;
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
            ),
        ],
      ),
    );
  }
}

class AddBankOrWalletPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Bank or Wallet'),
      ),
      body: Center(
        child: Text('Add Bank or Wallet Page'),
      ),
    );
  }
}

class CategoryListPage extends StatelessWidget {
  final Function(Map<String, dynamic>) onCategorySelected;

  CategoryListPage({required this.onCategorySelected, super.key});

  final List<Map<String, dynamic>> myTransactionalDataTwo = [
    {
      'icon': Icons.shopping_cart,
      'label': 'Shopping',
      'backgroundColor': Colors.blue,
      'color': Colors.white
    },
    {
      'icon': Icons.fastfood,
      'label': 'Food',
      'backgroundColor': Colors.green,
      'color': Colors.white
    },
    {
      'icon': Icons.car_rental,
      'label': 'Transport',
      'backgroundColor': Colors.orange,
      'color': Colors.white
    },
    {
      'icon': Icons.home,
      'label': 'Home',
      'backgroundColor': Colors.red,
      'color': Colors.white
    },
    {
      'icon': Icons.school,
      'label': 'Education',
      'backgroundColor': Colors.purple,
      'color': Colors.white
    },
    {
      'icon': Icons.local_hospital,
      'label': 'Health',
      'backgroundColor': Colors.teal,
      'color': Colors.white
    },
    {
      'icon': Icons.sports,
      'label': 'Sports',
      'backgroundColor': Colors.indigo,
      'color': Colors.white
    },
    {
      'icon': Icons.movie,
      'label': 'Entertainment',
      'backgroundColor': Colors.pink,
      'color': Colors.white
    },
    {
      'icon': Icons.travel_explore,
      'label': 'Travel',
      'backgroundColor': Colors.cyan,
      'color': Colors.white
    },
    {
      'icon': Icons.add,
      'label': 'Add',
      'backgroundColor': Colors.grey,
      'color': Colors.white
    },
  ];

  @override
  Widget build(BuildContext context) {
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
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // Number of items per row
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8, // Adjust aspect ratio for proper layout
          ),
          itemCount: myTransactionalDataTwo.length,
          itemBuilder: (context, index) {
            final data = myTransactionalDataTwo[index];

            return GestureDetector(
              onTap: () {
                if (data['label'] == 'Add') {
                  // Handle the "Add" category
                  // For example: Open a dialog or another screen to add a new category
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Add Category'),
                      content:
                          const Text('Functionality to add category here.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Pass the selected category back to the previous screen
                  onCategorySelected(data);
                  Navigator.pop(context);
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 24, // Adjust radius as needed
                    backgroundColor: data['backgroundColor'],
                    child: Icon(
                      data['icon'],
                      color: data['color'],
                      size: 20, // Adjust size to fit within the circle
                    ),
                  ),
                  const SizedBox(
                      height: 4), // Space between the icon and the text
                  Text(
                    data['label'],
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                    'Date has been set successfully!'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
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

class SaveButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextButton(
        onPressed: () {
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.blue,
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

