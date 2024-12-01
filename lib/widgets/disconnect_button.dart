import 'package:flutter/material.dart';

class DisconnectButton extends StatefulWidget {
  const DisconnectButton({super.key});

  @override
  State<StatefulWidget> createState() => _DisconnectButtonState();
}

class _DisconnectButtonState extends State<DisconnectButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, 
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8EBBFF),
        ),
        onPressed: () {

        },
        child: const Text(
          "Disconnect from Google Calendar",
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
