import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/debt_provider.dart';


class DebtTrackerPage extends ConsumerStatefulWidget {
  @override
  _DebtTrackerPageState createState() => _DebtTrackerPageState();
}

class _DebtTrackerPageState extends ConsumerState<DebtTrackerPage> with SingleTickerProviderStateMixin {
  TabController? _tabController;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final transactions = ref.watch(borrowOrDebtProvider);
    final lentTransactions = transactions.where((transaction) => transaction.transactionType == 'lent').toList();
    final borrowedTransactions = transactions.where((transaction) => transaction.transactionType == 'borrowed').toList();

    final double totalLentAmount = lentTransactions.fold(0.0, (sum, transaction) => sum + transaction.totalAmount);
    final double totalOwedAmount = borrowedTransactions.fold(0.0, (sum, transaction) => sum + transaction.totalAmount);
    final int lentPeopleCount = lentTransactions.length;
    final int borrowedPeopleCount = borrowedTransactions.length;


    return Scaffold(
      appBar: AppBar(
        title: Text('Debt Tracker'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top card with two columns
            Container(
              padding: const EdgeInsets.all(16.0),
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Money Lent',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${totalLentAmount.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Icon(Icons.person, color: Colors.grey, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'People: $lentPeopleCount',
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Money Owed',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${totalOwedAmount.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
                          ),
                          Row(
                            children: [
                              Icon(Icons.person, color: Colors.grey, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'People: $borrowedPeopleCount',
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                   // Add an icon
                  child: Text('Lent',style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),),
                ),
                Tab(

                  child: Text('Owed',style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),),
                ),
              ],
              labelColor: Colors.blue, // Color of selected tab
              unselectedLabelColor: Colors.grey, // Color of unselected tab
              indicatorColor: Colors.blue, // Color of the indicator below the selected tab
              indicatorWeight: 6.0, // Thickness of the indicator
            ),

            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab view for "Lent"
                  ListView.builder(
                    itemCount: lentTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = lentTransactions[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
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
                              blurRadius: 4,
                              spreadRadius: -1,
                              offset: const Offset(0, -1),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(0),
                          leading: CircleAvatar(
                            backgroundColor: Colors.green.withOpacity(0.1),
                            radius: 24,
                            child: Icon(Icons.person, color: Colors.green, size: 24),
                          ),
                          title: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    transaction.personName,
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Remaining: \$${transaction.remainingAmount}',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Amount: \$${transaction.totalAmount}',
                                    style: TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                  Text(
                                    'Days Left: ${transaction.daysLeft}',
                                    style: TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: transaction.progress,
                                backgroundColor: Colors.grey[300],
                                color: Colors.green,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  // Tab view for "Owed"
                  ListView.builder(
                    itemCount: borrowedTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = borrowedTransactions[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
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
                              blurRadius: 4,
                              spreadRadius: -1,
                              offset: const Offset(0, -1),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(0),
                          leading: CircleAvatar(
                            backgroundColor: Colors.red.withOpacity(0.1),
                            radius: 24,
                            child: Icon(Icons.person, color: Colors.red, size: 24),
                          ),
                          title: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    transaction.personName,
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Remaining: \$${transaction.remainingAmount}',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Amount: \$${transaction.totalAmount}',
                                    style: TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                  Text(
                                    'Days Left: ${transaction.daysLeft}',
                                    style: TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: transaction.progress,
                                backgroundColor: Colors.grey[300],
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// final cardVisibilityProvider = StateProvider<bool>((ref) => false);
//
// class DebitCard extends ConsumerWidget {
//   final String cardHolder;
//   final String cardNumber;
//   final double balance;
//   final String bankName;
//
//   const DebitCard({
//     super.key,
//     required this.cardHolder,
//     required this.cardNumber,
//     required this.balance,
//     required this.bankName,
//   });
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isVisible = ref.watch(cardVisibilityProvider);
//
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       color: Colors.blueGrey[900],
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         width: double.infinity,
//         height: 220,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           gradient: const LinearGradient(
//             colors: [Colors.blueGrey, Colors.black87],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Bank Name
//             Text(
//               bankName,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const Spacer(),
//
//             // Card Number
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   isVisible ? cardNumber : '•••• •••• •••• ${cardNumber.substring(cardNumber.length - 4)}',
//                   style: const TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 2),
//                 ),
//                 IconButton(
//                   icon: Icon(
//                     isVisible ? Icons.visibility : Icons.visibility_off,
//                     color: Colors.white,
//                   ),
//                   onPressed: () => ref.read(cardVisibilityProvider.notifier).state = !isVisible,
//                 ),
//               ],
//             ),
//
//             // Balance
//             Text(
//               isVisible ? "\$${balance.toStringAsFixed(2)}" : "••••",
//               style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//
//             const Spacer(),
//
//             // Cardholder Name
//             Text(
//               cardHolder.toUpperCase(),
//               style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



