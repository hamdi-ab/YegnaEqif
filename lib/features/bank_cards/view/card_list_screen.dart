
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yegna_eqif_new/features/bank_cards/viewmodel/bank_card_viewmodel.dart';

class CardListScreen extends StatelessWidget {
  const CardListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<BankCardViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank Cards'),
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.error != null
              ? Center(child: Text(viewModel.error!))
              : ListView.builder(
                  itemCount: viewModel.bankCards.length,
                  itemBuilder: (context, index) {
                    final card = viewModel.bankCards[index];
                    return ListTile(
                      leading: Icon(Icons.credit_card, color: card.cardColor),
                      title: Text(card.accountName),
                      subtitle: Text(card.accountNumber),
                      trailing: Text('${card.balance} Br.'),
                    );
                  },
                ),
    );
  }
}
