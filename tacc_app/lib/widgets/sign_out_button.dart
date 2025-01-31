import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SignOutButton extends StatefulWidget {
  const SignOutButton({super.key});

  @override
  State<StatefulWidget> createState() => _SignOutButtonState();
}

Future<void> logout() async {
  var logoutUrl = Uri.parse('https://keycloak.jakfut.at/realms/tacc/protocol/openid-connect/logout');

  if (!await canLaunchUrl(logoutUrl)) {
    await launchUrl(logoutUrl);
  } else {
    throw 'Konnte die URL nicht starten: $logoutUrl';
  }
}

class _SignOutButtonState extends State<SignOutButton> {

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
          logout();
        },
        child: const Text(
          "Sign Out",
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
