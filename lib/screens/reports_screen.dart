import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yegna_eqif_new/data/data.dart';
import 'package:yegna_eqif_new/screens/dashboard_screen.dart';

class ReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              ProfileBalance(),
              SizedBox(height: 30),
              TimePeriodToggle(),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  children: [
                    Container(
                      width: 175,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent.shade100,
                        borderRadius: BorderRadius.circular(16)
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 25.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Income', style: TextStyle(fontSize: 16, fontWeight:FontWeight.w500),),
                            SizedBox(height: 8),
                            Text('\$ 45,520', style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold,))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Container(
                      width: 175,
                      height: 110,
                      decoration: BoxDecoration(
                          color: Colors.pink.shade100,
                          borderRadius: BorderRadius.circular(16)
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 25.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Expense', style: TextStyle(fontSize: 16, fontWeight:FontWeight.w500),),
                            SizedBox(height: 8),
                            Text('\$ 44,520', style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold,))
                          ],
                        ),
                      ),

                    )
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                height: 50,
                width: 375,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(16)
                ),
                child: const Center(child: Text('View report >', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),)),
              ),
              SizedBox(height: 26),
              SectionWithHeader(
                title: 'Recent Transaction',
                viewAllCallback: () {},
                child: const RecentTransaction(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileBalance extends StatelessWidget {

  const ProfileBalance({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:  16.0, right: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.yellow[700],
                child: Icon(
                  CupertinoIcons.person_fill,
                  color: Colors.yellow[900],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Balance',
                    style: Theme.of(context).textTheme.bodyMedium
                  ),
                  const Text(
                    '\$50,000',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                  ),
                ],
              )
            ],
          ),
          FloatingActionButton.small(
            onPressed: () {},
            elevation: 0,
            backgroundColor: Colors.blue,
            shape: const CircleBorder(),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 18, // Optional: Adjust the icon size
            ),
          ),
        ],
      ),
    );
  }
}

class TimePeriodToggle extends StatefulWidget {
  const TimePeriodToggle({Key? key}) : super(key: key);

  @override
  _TimePeriodToggleState createState() => _TimePeriodToggleState();
}

class _TimePeriodToggleState extends State<TimePeriodToggle> {
  int selectedIndex = 0;

  final List<String> labels = ["This Week", "This Month", "This Year"];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final isSelected = index == selectedIndex;
          return Expanded( // Ensures buttons are evenly spaced
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 8), // Reduced padding
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  labels[index],
                  style: TextStyle(
                    fontSize: 16,
                    color: isSelected ? Colors.black : Colors.black54,
                    fontWeight: FontWeight.w500,
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

class RecentTransaction extends StatelessWidget {
  const RecentTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: myTransactionalData.length,
          itemBuilder: (context, index) {
            final transaction = myTransactionalData[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                leading: CircleAvatar(
                  backgroundColor: transaction['color'],
                  child: transaction['icon'],
                ),
                title: Text(transaction['name']),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      transaction['totalAmount'],
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      transaction['date'],
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}


