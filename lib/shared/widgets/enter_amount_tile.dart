import 'package:flutter/material.dart';
import 'package:yegna_eqif_new/shared/widgets/forms/container_with_box_shadow.dart';

class EnterAmountTile extends StatelessWidget {
  final Function(String) onAmountSaved;

  const EnterAmountTile({super.key, required this.onAmountSaved});

  @override
  Widget build(BuildContext context) {
    return ContainerWIthBoxShadow(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: TextFormField(
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        decoration: const InputDecoration(
          hintText: 'Enter Amount',
          hintStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          border: InputBorder.none,
          icon: Icon(Icons.attach_money, color: Colors.green),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter an amount';
          }
          if (double.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          return null;
        },
        onSaved: (value) {
          if (value != null) {
            onAmountSaved(value);
          }
        },
        onChanged: (value) {
          if (value.isNotEmpty) {
            onAmountSaved(value);
          }
        },
      ),
    );
  }
}
