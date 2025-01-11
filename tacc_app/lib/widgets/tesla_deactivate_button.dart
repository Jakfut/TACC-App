import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;  

class DeactivateButton extends StatefulWidget {
  final String userId;
  final ValueNotifier connectedValueNotifier;
  const DeactivateButton(this.userId, this.connectedValueNotifier, {super.key});

  @override
  State<StatefulWidget> createState() => _DeactivateButtonState();
}

class _DeactivateButtonState extends State<DeactivateButton> {

  Future<void> deactivateConnection() async {
    final Uri apiUrl = Uri.parse('http://10.0.2.2:8080/api/user/${widget.userId}/tesla-connections/deactivate');

    try {
      final response = await http.patch(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        /*ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully disconnectet!')),
        );*/
      } else {
        /*ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to disconnect. Status code: ${response.statusCode}')),
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
          deactivateConnection();
          widget.connectedValueNotifier.value = false;
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
