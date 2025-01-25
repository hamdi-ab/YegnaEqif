import 'package:flutter/material.dart';
import 'package:yegna_eqif_new/data/data.dart';
import 'package:yegna_eqif_new/screens/reports_screen.dart';

class BudgetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              TimePeriodToggle(),
              SizedBox(height: 40),
              CircularProgressBar(
                progress: 0.45, // Example progress (55%)
                currentAmount: 3456, // Current value
                totalAmount: 6300, // Total value
              ),
              SizedBox(height: 26),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text('Category List',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Container(
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
                  itemCount: myTransactionalDataTwo.length + 1, // Add one for the FAB
                  itemBuilder: (context, index) {
                    if (index == myTransactionalDataTwo.length) {
                      // Add FAB as the last item
                      return FloatingActionButton.small(
                        elevation: 0,
                        shape: CircleBorder(),
                        onPressed: () {},
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.add, size: 20), // Adjust icon size
                      );
                    }

                    final data = myTransactionalDataTwo[index];
                    return Column(
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
                        const SizedBox(height: 4), // Space between the icon and the text
                        Text(
                          data['label'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12), // Adjust font size
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis, // Prevent text overflow
                        ),
                      ],
                    );
                  },
                ),
              ),




              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text('Category Budget',
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 16),
              MonthlyBudget(),
            ],
          ),
        ),
      ),
    );
  }
}

class CircularProgressBar extends StatelessWidget {
  final double progress; // Progress percentage (0.0 to 1.0)
  final double currentAmount; // Current amount
  final double totalAmount; // Total amount

  const CircularProgressBar({
    Key? key,
    required this.progress,
    required this.currentAmount,
    required this.totalAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine color based on progress
    Color progressColor;
    if (progress <= 0.5) {
      progressColor = Colors.red; // Red for less than 50%
    } else if (progress <= 0.8) {
      progressColor = Colors.yellow; // Yellow for 50-80%
    } else {
      progressColor = Colors.green; // Green for 80% and above
    }

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Circle
          SizedBox(
            width: 200,
            height: 200,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 15,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              backgroundColor: Colors.black12,
            ),
          ),
          // Inner content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Progress percentage
              Text(
                '${(progress * 100).toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              // Current and Total amount
              Text(
                '\$${currentAmount.toStringAsFixed(0)} of \$${totalAmount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MonthlyBudget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Adjust the height as needed
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: myTransactionalDataTwo.length,
        itemBuilder: (context, index) {
          final item = myTransactionalDataTwo[index];
          final double progress = item['progress'];
          final Color progressColor = item['color'];

          // Determine the status and indicator properties
          String statusText;
          IconData statusIcon;
          Color statusColor;

          if (progress < 0.7) {
            statusText = 'Your spending is still on track';
            statusIcon = Icons.check_circle;
            statusColor = Colors.green;
          } else if (progress < 1.0) {
            statusText = 'You are almost exceeding your budget';
            statusIcon = Icons.error_outline;
            statusColor = Colors.yellow[700]!;
          } else {
            statusText = 'You have exceeded your budget';
            statusIcon = Icons.error;
            statusColor = Colors.red;
          }

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15), // Subtle shadow
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 4), // Bottom shadow
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.05), // Lighter top shadow
                  blurRadius: 8,
                  spreadRadius: -1,
                  offset: const Offset(0, -2), // Top shadow
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon and Label Row
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: item['backgroundColor'],
                      child: Icon(
                        item['icon'],
                        color: progressColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['label'],
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$${item['total'].toStringAsFixed(0)} total',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Progress Bar with Labels Inside
                Stack(
                  children: [
                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        minHeight: 24,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progressColor,
                        ),
                      ),
                    ),
                    // Labels Inside Progress Bar
                    Positioned.fill(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              '\$${(progress * item['total']).toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              '\$${item['total']}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Status Indicator
                Row(
                  children: [
                    Icon(
                      statusIcon,
                      color: statusColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
