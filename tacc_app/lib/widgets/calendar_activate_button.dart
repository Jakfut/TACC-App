import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:openid_client/openid_client_io.dart';  

class ActivateButton extends StatefulWidget {
  final Credential c;
  final ValueNotifier connectedValueNotifier;
  const ActivateButton(this.c, this.connectedValueNotifier, {super.key});

  @override
  State<StatefulWidget> createState() => _ActivateButtonState();
}

class _ActivateButtonState extends State<ActivateButton> {

  Future<void> activateConnection() async {
    var userInfo = await widget.c.getUserInfo();
    String userId = userInfo.subject;
    var authToken = await widget.c.getTokenResponse();
    final Uri apiUrl = Uri.parse('https://tacc.jakfut.at/api/user/$userId/calendar-connections/google-calendar/activate');

    try {
      final response = await http.patch(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authToken.accessToken}', 
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
