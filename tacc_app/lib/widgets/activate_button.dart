import 'package:flutter/material.dart';

class ActivateButton extends StatefulWidget {
  const ActivateButton({super.key});

  @override
  State<StatefulWidget> createState() => _ActivateButtonState();
}

class _ActivateButtonState extends State<ActivateButton> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, 
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          side: const BorderSide(
            color: Color(0xFF8EBBFF),
          ),
        ),
        onPressed: () {

        },
        child: const Text(
          "Activate",
          style: TextStyle(
            color: Color(0xFF8EBBFF),
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
