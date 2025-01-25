import 'package:flutter/material.dart';

class OwsMoneyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Owe')),
      body: DebtManagementPage(),
    );
  }
}


class DebtManagementPage extends StatefulWidget {
  @override
  _DebtManagementPageState createState() => _DebtManagementPageState();
}

class _DebtManagementPageState extends State<DebtManagementPage> {
  bool _showOwedToYou = true;

  final List<Map<String, dynamic>> peopleOweYou = [
    {'name': 'Alice', 'amount': 100.0, 'profile': Icons.person, 'backgroundColor': Colors.blue.shade100, 'iconColor': Colors.blue},
    {'name': 'Bob', 'amount': 50.0, 'profile': Icons.person, 'backgroundColor': Colors.green.shade100, 'iconColor': Colors.green},
    // Add more people who owe you
  ];

  final List<Map<String, dynamic>> peopleYouOwe = [
    {'name': 'Charlie', 'amount': 75.0, 'profile': Icons.person, 'backgroundColor': Colors.red.shade100, 'iconColor': Colors.red},
    {'name': 'Diana', 'amount': 120.0, 'profile': Icons.person, 'backgroundColor': Colors.orange.shade100, 'iconColor': Colors.orange},
    // Add more people you owe
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debt Management'),
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          ToggleButtons(
            borderRadius: BorderRadius.circular(16),
            selectedBorderColor: Colors.blue,
            selectedColor: Colors.white,
            fillColor: Colors.blue,
            color: Colors.blue,
            constraints: BoxConstraints(minHeight: 40.0, minWidth: 100.0),
            isSelected: [_showOwedToYou, !_showOwedToYou],
            onPressed: (int index) {
              setState(() {
                _showOwedToYou = index == 0;
              });
            },
            children: [
              Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Text('Owed to You')),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Text('You Owe')),
            ],
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _showOwedToYou ? peopleOweYou.length : peopleYouOwe.length,
              itemBuilder: (context, index) {
                var person = _showOwedToYou ? peopleOweYou[index] : peopleYouOwe[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: person['backgroundColor'],
                      child: Icon(
                        person['profile'],
                        color: person['iconColor'],
                      ),
                    ),
                    title: Text(
                      person['name'],
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      '\$${person['amount'].toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



