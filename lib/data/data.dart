import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<Map<String, dynamic>> myTransactionalData = [
  {
    'icon': const FaIcon(
      FontAwesomeIcons.chartPie,
      color: Colors.white,
    ),
    'color': Colors.yellow[700],
    'name': 'Food',
    'totalAmount': '-\$45.00',
    'date': 'Today'
  },
  {
    'icon': const FaIcon(
      FontAwesomeIcons.bagShopping,
      color: Colors.white,
    ),
    'color': Colors.purple,
    'name': 'Shopping',
    'totalAmount': '-\$230.00',
    'date': 'Today'
  },
  {
    'icon':
        const FaIcon(FontAwesomeIcons.heartCircleCheck, color: Colors.white),
    'color': Colors.green,
    'name': 'Health',
    'totalAmount': '-\$79.00',
    'date': 'Yesterday'
  },
  {
    'icon': const FaIcon(FontAwesomeIcons.plane, color: Colors.white),
    'color': Colors.blue,
    'name': 'Travel',
    'totalAmount': '-\$355.00',
    'date': 'Yesterday'
  }
];
final List<Map<String, dynamic>> myTransactionalDataTwo = [
  {
    'icon': Icons.shopping_bag,
    'label': 'Shopping',
    'color': Colors.blue, // Main color for the icon
    'backgroundColor': Colors.blue.shade100, // Lighter version for the background
    'total': 8000, // Total value
    'progress': 0.2, // Progress as a decimal (e.g., 20% progress)
  },
  {
    'icon': Icons.restaurant,
    'label': 'Food',
    'color': Colors.orange,
    'backgroundColor': Colors.orange.shade100,
    'total': 5000,
    'progress': 0.4,
  },
  {
    'icon': Icons.home,
    'label': 'House',
    'color': Colors.green,
    'backgroundColor': Colors.green.shade100,
    'total': 10000,
    'progress': 0.3,
  },
  {
    'icon': Icons.directions_car,
    'label': 'Travel',
    'color': Colors.purple,
    'backgroundColor': Colors.purple.shade100,
    'total': 3000,
    'progress': 0.5,
  },
  {
    'icon': Icons.phone,
    'label': 'Phone',
    'color': Colors.red,
    'backgroundColor': Colors.red.shade100,
    'total': 2000,
    'progress': 0.7,
  },
];

List<Map<String, dynamic>> peopleYouOweData = [
  {
    'name': 'John',
    'icon': Icons.person,  // Example icon for John Doe
    'color': Colors.white,
    'backgroundColor': Colors.blueAccent,
    'label': 'John',
    'moneyOwed': 700, // Example amount of money owed
  },
  {
    'name': 'Jane',
    'icon': Icons.account_circle,  // Example icon for Jane Smith
    'color': Colors.white,
    'backgroundColor': Colors.greenAccent,
    'label': 'Jane',
    'moneyOwed': 500,
  },
  {
    'name': 'Michael',
    'icon': Icons.people,  // Example icon for Michael Johnson
    'color': Colors.white,
    'backgroundColor': Colors.redAccent,
    'label': 'Michael',
    'moneyOwed': 250,
  },
  {
    'name': 'Sara',
    'icon': Icons.person_add,  // Example icon for Sara Lee
    'color': Colors.white,
    'backgroundColor': Colors.orangeAccent,
    'label': 'Sara',
    'moneyOwed': 600,
  },
  {
    'name': 'David',
    'icon': Icons.person_pin,  // Example icon for David Brown
    'color': Colors.white,
    'backgroundColor': Colors.purpleAccent,
    'label': 'David',
    'moneyOwed': 450,
  },
];

final List<Map<String, dynamic>> peopleWhoOweYou = [
  {
    'name': 'John',
    'icon': Icons.person,
    'backgroundColor': Colors.blue[100],
    'color': Colors.blue[800],
    'amountOwed': 150.00,
  },
  {
    'name': 'Sarah',
    'icon': Icons.person_outline,
    'backgroundColor': Colors.green[100],
    'color': Colors.green[800],
    'amountOwed': 250.00,
  },
  {
    'name': 'Ahmed',
    'icon': Icons.person_pin_circle,
    'backgroundColor': Colors.orange[100],
    'color': Colors.orange[800],
    'amountOwed': 120.00,
  },
  {
    'name': 'Linda',
    'icon': Icons.account_circle,
    'backgroundColor': Colors.red[100],
    'color': Colors.red[800],
    'amountOwed': 300.00,
  },
  {
    'name': 'Michael',
    'icon': Icons.account_box,
    'backgroundColor': Colors.purple[100],
    'color': Colors.purple[800],
    'amountOwed': 180.00,
  },
];
final List<Map<String, dynamic>> totalBalanceData = [
  {
    'totalBalance': 4000.00,
    'income': 2500.00,
    'expense': 400.00,
    'color': Colors.blue,
  },
  {
    'totalBalance': 6000.00,
    'income': 3500.00,
    'expense': 800.00,
    'color': Colors.orange,
  },
  {
    'totalBalance': 10000.00,
    'income': 7000.00,
    'expense': 1500.00,
    'color': Colors.purple,
  },
];

