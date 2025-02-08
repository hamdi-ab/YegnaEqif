import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yegna_eqif_new/screens/add_budget_screen.dart';
import 'package:yegna_eqif_new/screens/add_category_screen.dart';
import 'package:yegna_eqif_new/screens/add_debt_transaction_screen.dart';
import 'package:yegna_eqif_new/screens/add_transaction_screen.dart';
import 'package:yegna_eqif_new/screens/budget_screen.dart';
import 'package:yegna_eqif_new/screens/dashboard_screen.dart';
import 'package:yegna_eqif_new/screens/ows_money_screen.dart';
import 'package:yegna_eqif_new/screens/reports_screen.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'add_bank_card_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    DashboardScreen(),
    ReportsScreen(),
    BudgetScreen(),
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
              child: const FaIcon(
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 16.0, bottom: 16.0), // Add padding to position the SpeedDial
        child: SpeedDial(
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
          shape: CircleBorder(),
          spacing: 6, // Adjust spacing between SpeedDial children
          spaceBetweenChildren: 14, // Add space between SpeedDial children
          children: [
            SpeedDialChild(
              child: Icon(Icons.attach_money, color: Colors.green),
              backgroundColor: Colors.green.shade200,
              labelWidget: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // Add padding to label
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300, width: 1), // Add border
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                constraints: BoxConstraints(maxWidth: 150), // Limit the label width
                child: Text(
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
              child: Icon(Icons.account_balance_wallet, color: Colors.blue),
              backgroundColor: Colors.blue.shade200,
              labelWidget: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // Add padding to label
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300, width: 1), // Add border
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                constraints: BoxConstraints(maxWidth: 150), // Limit the label width
                child: Text(
                  'Add Card or Wallet',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddBankCardPage()));
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.category, color: Colors.orange),
              backgroundColor: Colors.orange.shade200,
              labelWidget: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // Add padding to label
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300, width: 1), // Add border
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                constraints: BoxConstraints(maxWidth: 150), // Limit the label width
                child: Text(
                  'Add Budget',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddBudgetPage()));
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.people, color: Colors.red),
              backgroundColor: Colors.red.shade200,
              labelWidget: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // Add padding to label
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300, width: 1), // Add border
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                constraints: BoxConstraints(maxWidth: 150), // Limit the label width
                child: Text(
                  'Add Debt',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddDebtTransactionScreen()));
              },
            )
          ],
        ),
      )

      ,
    );
  }
}
