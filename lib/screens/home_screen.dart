import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yegna_eqif_new/screens/add_category_screen.dart';
import 'package:yegna_eqif_new/screens/add_transaction_screen.dart';
import 'package:yegna_eqif_new/screens/budget_screen.dart';
import 'package:yegna_eqif_new/screens/dashboard_screen.dart';
import 'package:yegna_eqif_new/screens/ows_money_screen.dart';
import 'package:yegna_eqif_new/screens/reports_screen.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

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
    OwsMoneyScreen(),
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
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
            child: Icon(Icons.attach_money, color: Colors.green),
            backgroundColor: Colors.green.shade200,
            label: 'Add Transaction',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              // Navigate to AddTransactionScreen or perform any action
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddTransactionScreen()));
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.account_balance_wallet, color: Colors.blue),
            backgroundColor: Colors.blue.shade200,
            label: 'Add card or wallet',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              // Navigate to another screen or perform any action
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddCategoryPage()));
              print('Option 2 Tapped');
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.category, color: Colors.orange),
            backgroundColor: Colors.orange.shade200,
            label: 'Add Category',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              // Navigate to another screen or perform any action
              print('Option 3 Tapped');
            },
          ),
        ],
      ),
    );
  }
}
