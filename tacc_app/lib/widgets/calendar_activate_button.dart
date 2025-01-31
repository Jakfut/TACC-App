import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;  

class ActivateButton extends StatefulWidget {
  final String userId;
  final ValueNotifier connectedValueNotifier;
  const ActivateButton(this.userId, this.connectedValueNotifier, {super.key});

  @override
  State<StatefulWidget> createState() => _ActivateButtonState();
}

class _ActivateButtonState extends State<ActivateButton> {

  Future<void> activateConnection() async {
    final Uri apiUrl = Uri.parse('http://tacc.jakfut.at/api/user/${widget.userId}/calendar-connections/google-calendar/activate');

    try {
      final response = await http.patch(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
       /* ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully connectet!')),
        );*/
      } else {
        /*ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to connect. Status code: ${response.statusCode}')),
        );*/
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.connectedValueNotifier,
      builder: (context, timeValue, _) {
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
          activateConnection();
          widget.connectedValueNotifier.value = true;
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
    },
    );
  }
}
