import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yegna_eqif_new/shared/widgets/forms/container_with_box_shadow.dart';

class SelectDateWidget extends StatelessWidget {
  final String label;
  final DateTime firstDay;
  final DateTime lastDay;
  final Function(DateTime) onDateSelected;

  const SelectDateWidget({
    super.key,
    required this.label,
    required this.firstDay,
    required this.lastDay,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ContainerWIthBoxShadow(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: firstDay,
                lastDate: lastDay,
              );
              if (picked != null) {
                onDateSelected(picked);
              }
            },
            child: const Text(
              'Select',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
