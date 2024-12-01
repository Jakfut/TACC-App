import 'package:flutter/material.dart';

class APISelect extends StatefulWidget {
  const APISelect({super.key});

  @override
  State<StatefulWidget> createState() => _APISelectState();
}

class _APISelectState extends State<APISelect> {
  String? selectedItem = "Tessie";

  final List<String> _options = ['Tessie', 'TeslaAPI'];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, 
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
        ),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true, 
          value: selectedItem,
          dropdownColor: Theme.of(context).colorScheme.primary,
          items: _options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(
                option,
                style: const TextStyle(
                  color: Color(0xFFFBFCFE),
                  fontSize: 16,
                  fontFamily: 'Inter',
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedItem = newValue;
            });
          },
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Color(0xFFFBFCFE),
          ),
        ),
      ),
    );
  }
}
