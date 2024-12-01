import 'package:flutter/material.dart';

class DeactivateButton extends StatefulWidget {
  const DeactivateButton({super.key});

  @override
  State<StatefulWidget> createState() => _DeactivateButtonState();
}

class _DeactivateButtonState extends State<DeactivateButton> {

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
          "Deactivate",
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
