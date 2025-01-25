import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

List<Map<String, dynamic>> myTransactionalData = [
  {
    'icon': const FaIcon(
      FontAwesomeIcons.burger,
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
    'progress': 0.9,
  }
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



final List<BarChartGroupData> weeklyBarData = List.generate(7, (index) {
  // Dummy data for income and expense
  final income = [10000, 12000, 15000, 8000, 11000, 9000, 7000][index];
  final expense = [5000, 6000, 8000, 4000, 5000, 6000, 3000][index];
  return BarChartGroupData(
    x: index,
    barRods: [
      BarChartRodData(toY: income.toDouble(), color: Colors.green, width: 8),
      BarChartRodData(toY: expense.toDouble(), color: Colors.red, width: 8),
    ],
  );
});


// Pie chart data
final List<Map<String, dynamic>> incomeCategoryData = [
  {
    'name': 'Salary',
    'color': Colors.green,
    'icon': Icons.work,
    'amount': 35000,
    'percent': 75,
    'value': 75,
    'isHovered': false,
  },
  {
    'name': 'Freelance',
    'color': Colors.blue,
    'icon': Icons.computer,
    'amount': 5000,
    'percent': 10,
    'value': 10,
    'isHovered': false,
  },
  {
    'name': 'Investment',
    'color': Colors.orange,
    'icon': Icons.pie_chart,
    'amount': 3000,
    'percent': 6,
    'value': 6,
    'isHovered': false,
  },
  {
    'name': 'Others',
    'color': Colors.purple,
    'icon': Icons.account_balance_wallet,
    'amount': 2500,
    'percent': 5,
    'value': 5,
    'isHovered': false,
  },
  {
    'name': 'Bonus',
    'color': Colors.red,
    'icon': Icons.monetization_on,
    'amount': 1000,
    'percent': 4,
    'value': 4,
    'isHovered': false,
  },
];


// Categories list data
final List<Map<String, dynamic>> categoryData = [
  {
    'icon': Icons.shopping_bag,
    'name': 'Shopping',
    'color': Colors.blue,
    'amount': 12000,
    'percent': 40,
  },
  {
    'icon': Icons.restaurant,
    'name': 'Food',
    'color': Colors.green,
    'amount': 9000,
    'percent': 30,
  },
  {
    'icon': Icons.home,
    'name': 'House',
    'color': Colors.red,
    'amount': 6000,
    'percent': 20,
  },
  {
    'icon': Icons.car_rental,
    'name': 'Travel',
    'color': Colors.orange,
    'amount': 3000,
    'percent': 10,
  },
];

final List<Map<String, dynamic>> expenseCategoryData = [
  {
    'name': 'Rent',
    'color': Colors.blue,
    'icon': Icons.home,
    'amount': 1200,
    'percent': 30,
    'value': 30,
    'isHovered': false,
  },
  {
    'name': 'Groceries',
    'color': Colors.green,
    'icon': Icons.local_grocery_store,
    'amount': 800,
    'percent': 20,
    'value': 20,
    'isHovered': false,
  },
  {
    'name': 'Utilities',
    'color': Colors.orange,
    'icon': Icons.bolt,
    'amount': 400,
    'percent': 10,
    'value': 10,
    'isHovered': false,
  },
  {
    'name': 'Transportation',
    'color': Colors.red,
    'icon': Icons.directions_car,
    'amount': 500,
    'percent': 12,
    'value': 12,
    'isHovered': false,
  },
  {
    'name': 'Entertainment',
    'color': Colors.purple,
    'icon': Icons.movie,
    'amount': 300,
    'percent': 8,
    'value': 8,
    'isHovered': false,
  },
  {
    'name': 'Dining',
    'color': Colors.yellow,
    'icon': Icons.restaurant,
    'amount': 200,
    'percent': 5,
    'value': 5,
    'isHovered': false,
  },
  {
    'name': 'Miscellaneous',
    'color': Colors.grey,
    'icon': Icons.category,
    'amount': 100,
    'percent': 5,
    'value': 5,
    'isHovered': false,
  },
];


