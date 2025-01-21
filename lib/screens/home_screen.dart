import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yegna_eqif_new/screens/add_transaction_screen.dart';
import 'package:yegna_eqif_new/screens/budget_screen.dart';
import 'package:yegna_eqif_new/screens/dashboard_screen.dart';
import 'package:yegna_eqif_new/screens/ows_money_screen.dart';
import 'package:yegna_eqif_new/screens/reports_screen.dart';

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
            icon: Icon(Icons.home_filled,size: 28,),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Colors.white,)),
      ),
    );
  }
}
