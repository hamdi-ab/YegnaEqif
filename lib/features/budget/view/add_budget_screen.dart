import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yegna_eqif_new/features/budget/model/budget.dart';
import 'package:yegna_eqif_new/models/category.dart';
import 'package:yegna_eqif_new/features/budget/viewmodel/budget_viewmodel.dart';
import 'package:yegna_eqif_new/shared/widgets/forms/container_with_box_shadow.dart';
import 'package:yegna_eqif_new/shared/widgets/select_date_widget.dart';

class AddBudgetPage extends StatefulWidget {
  const AddBudgetPage({super.key});

  @override
  _AddBudgetPageState createState() => _AddBudgetPageState();
}

class _AddBudgetPageState extends State<AddBudgetPage> {
  final _formKey = GlobalKey<FormState>();
  String _enteredAmount = "";
  Category? selectedCategory;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  bool isCategorySelected = false;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final budget = Budget(
        id: DateTime.now().toString(), // Or generate a unique ID
        allocatedAmount: double.parse(_enteredAmount),
        spentAmount: 0, // Initial spent amount is 0
        startDate: _selectedStartDate!,
        endDate: _selectedEndDate!,
        category: selectedCategory!.name,
      );

      context.read<BudgetViewModel>().addBudget(budget);

      Navigator.of(context).pop();
    }
  }

  void _updateAmount(String amount) {
    setState(() {
      _enteredAmount = amount;
    });
  }

  void _updateCategory(Category category) {
    setState(() {
      selectedCategory = category;
      isCategorySelected = true;
    });
  }

  void _updateStartDate(DateTime date) {
    setState(() {
      _selectedStartDate = date;
    });
  }

  void _updateEndDate(DateTime date) {
    setState(() {
      _selectedEndDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Budget'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContainerWIthBoxShadow(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
                        backgroundColor: selectedCategory != null
                            ? selectedCategory!.color.withOpacity(0.2)
                            : Colors.grey.shade300,
                        child: Icon(
                          selectedCategory != null
                              ? selectedCategory!.icon
                              : Icons.category,
                          color: selectedCategory != null
                              ? selectedCategory!.color
                              : Colors.black54,
                        ),
                      ),
                      title: Text(
                        selectedCategory != null
                            ? selectedCategory!.name
                            : 'Select Category',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                    ),
                  )),
              // EnterAmountTile(
              //   onAmountSaved: _updateAmount,
              // ),
              SelectDateWidget(
                  label: 'Select Start Date',
                  firstDay: DateTime(2000),
                  lastDay: DateTime(2100),
                  onDateSelected: _updateStartDate),
              SelectDateWidget(
                  label: 'Select End Date',
                  firstDay: DateTime(2000),
                  lastDay: DateTime(2100),
                  onDateSelected: _updateEndDate),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextButton(
                  onPressed: _submitForm,
                  style: TextButton.styleFrom(
                    backgroundColor:
                        Colors.blue, // Change color based on validation
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    minimumSize: const Size(double.infinity,
                        50), // Make the button cover the full width
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
