import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:openid_client/openid_client_io.dart';
import 'package:url_launcher/url_launcher.dart';

class ConnectButton extends StatefulWidget {
  final Credential c;
  const ConnectButton({super.key, required this.c});

  @override
  State<StatefulWidget> createState() => _ConnectButtonState();
}

Future<String> googleConnect(Credential c) async {
  var userInfo = await c.getUserInfo();
  String userId = userInfo.subject;
  final response = await http.get(Uri.parse(
      'https://tacc.jakfut.at/auth/google/start/$userId'));

  if (response.statusCode == 200) {
        return response.body;
  } else {
    throw Exception('error connecting to google');
  }
}


class _ConnectButtonState extends State<ConnectButton> {
  late Future<String> url;

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
            String connectUrl = await googleConnect(widget.c);

            //connectUrl = 'https://tacc.jakfut.at/oauth2/authorization/google?session_id=eef6f442-0538-4776-a05f-96395124c70a';
            
            if (!await canLaunchUrl(Uri.parse(connectUrl))) {
              await launchUrl(
                Uri.parse(connectUrl),
                mode: LaunchMode.externalApplication, // Ensure the URL opens in a browser
              );
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
