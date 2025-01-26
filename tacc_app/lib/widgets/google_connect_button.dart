import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ConnectButton extends StatefulWidget {
  const ConnectButton({super.key});

  @override
  State<StatefulWidget> createState() => _ConnectButtonState();
}

Future<String> googleConnect(String userId) async {
  final response = await http.get(Uri.parse(
      'http://10.0.2.2:8080/auth/google/start/${userId}'));

  if (response.statusCode == 200) {
        return response.body;
  } else {
    throw Exception('error connecting to google');
  }
}


class _ConnectButtonState extends State<ConnectButton> {
  late Future<String> url;
  final String userId = "8a61a7d6-52d1-4dd7-9c60-1f5e08edc28b";

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, 
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8EBBFF),
        ),
        /*onPressed: () {
          url = googleConnect(userId);
        },*/
        onPressed: () async {
          try {
            // Ruft die URL von der API ab
            String connectUrl = await googleConnect(userId);

            // Versucht, die URL zu öffnen
            if (await canLaunch(connectUrl)) {
              await launch(connectUrl);
            } else {
              throw Exception('Could not launch $connectUrl');
            }
          } catch (e) {
            // Fehlerbehandlung
            print('Error: $e');
          }
        },
        child: const Text(
          "Connect to Google Calendar",
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
