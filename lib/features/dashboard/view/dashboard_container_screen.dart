import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yegna_eqif_new/features/bank_cards/view/add_bank_card_screen.dart';
import 'package:yegna_eqif_new/features/budget/view/add_budget_screen.dart';
import 'package:yegna_eqif_new/features/budget/view/budget_screen.dart';
import 'package:yegna_eqif_new/features/dashboard/view/dashboard_screen.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:yegna_eqif_new/features/debt/view/add_debt_transaction_screen.dart';
import 'package:yegna_eqif_new/features/debt/view/debt_tracker_screen.dart';
import 'package:yegna_eqif_new/features/reports/view/reports_screen.dart';
import 'package:yegna_eqif_new/features/transactions/view/add_transaction_screen.dart';

class DashboardContainerScreen extends StatefulWidget {
  const DashboardContainerScreen({super.key});

  @override
  _DashboardContainerScreenState createState() =>
      _DashboardContainerScreenState();
}

class _DashboardContainerScreenState extends State<DashboardContainerScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const DashboardScreen(),
    ReportsScreen(),
    BudgetScreen(scrollToMonthlyBudget: false),
    DebtTrackerPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue, // Active tab color
        unselectedItemColor: Colors.grey, // Inactive tab color
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_filled,
              size: 28,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(right: 30.0),
              child: FaIcon(
                FontAwesomeIcons.chartPie,
                size: 22,
              ),
            ),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Icon(Icons.wallet),
            ),
            label: 'Budget',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Owe',
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        visible: true,
        closeManually: false,
        renderOverlay: true,
        overlayOpacity: 0.5,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        activeBackgroundColor: Colors.red,
        activeForegroundColor: Colors.white,
        shape: const CircleBorder(),
        spacing: 6, // Adjust spacing between SpeedDial children
        spaceBetweenChildren: 14, // Add space between SpeedDial children
        children: [
          SpeedDialChild(
            child: const Icon(Icons.payments, color: Colors.green),
            backgroundColor: Colors.green.shade200,
            labelWidget: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8.0, vertical: 4.0), // Add padding to label
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: Colors.grey.shade300, width: 1), // Add border
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              constraints:
                  const BoxConstraints(maxWidth: 150), // Limit the label width
              child: const Text(
                'Add Transaction',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTransactionScreen()),
              );
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.account_balance_wallet, color: Colors.blue),
            backgroundColor: Colors.blue.shade200,
            labelWidget: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8.0, vertical: 4.0), // Add padding to label
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: Colors.grey.shade300, width: 1), // Add border
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              constraints:
                  const BoxConstraints(maxWidth: 150), // Limit the label width
              child: const Text(
                'Add Card or Wallet',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddBankCardScreen()));
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.category, color: Colors.orange),
            backgroundColor: Colors.orange.shade200,
            labelWidget: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8.0, vertical: 4.0), // Add padding to label
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: Colors.grey.shade300, width: 1), // Add border
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              constraints:
                  const BoxConstraints(maxWidth: 150), // Limit the label width
              child: const Text(
                'Add Budget',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddBudgetPage()));
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.people, color: Colors.red),
            backgroundColor: Colors.red.shade200,
            labelWidget: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8.0, vertical: 4.0), // Add padding to label
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: Colors.grey.shade300, width: 1), // Add border
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              constraints:
                  const BoxConstraints(maxWidth: 150), // Limit the label width
              child: const Text(
                'Add Debt',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddDebtTransactionScreen()));
            },
          )
        ],
      ),
    );
  }
}
