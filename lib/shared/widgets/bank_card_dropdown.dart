import 'package:flutter/material.dart';
import 'package:yegna_eqif_new/shared/widgets/forms/container_with_box_shadow.dart';

class BankCardDropdown extends StatefulWidget {
  final Function(String) onBankSelected;

  const BankCardDropdown({super.key, required this.onBankSelected});

  @override
  State<BankCardDropdown> createState() => _BankCardDropdownState();
}

class _BankCardDropdownState extends State<BankCardDropdown> {
  String _selectedBank = "Cash";
  final List<String> _bankOptions = [
    "Cash",
    "CBE",
    "Awash",
    "Dashen",
    "Abyssinia"
  ];

  @override
  Widget build(BuildContext context) {
    return ContainerWIthBoxShadow(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedBank,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
          items: _bankOptions.map((String bank) {
            return DropdownMenuItem<String>(
              value: bank,
              child: Text(
                bank,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedBank = newValue;
              });
              widget.onBankSelected(newValue);
            }
          },
        ),
      ),
    );
  }
}
