import 'package:flutter/material.dart';
import 'package:openid_client/openid_client_io.dart';
import 'package:tacc_app/widgets/navigation_bar.dart';
import 'package:url_launcher/url_launcher.dart';

Future<Credential> authenticate() async {
    // Keycloak-Server-URL
    var uri = Uri.parse('https://keycloak.jakfut.at/realms/tacc');

    var issuer = await Issuer.discover(uri);

    // Client-ID Ihrer Anwendung
    var client = Client(issuer, 'model-cc');

    // Authenticator erstellen
    var authenticator = Authenticator(
      client,
      scopes: ['openid', 'profile', 'email'],
      port: 4000, 
      urlLancher: (url) async {
        var uri = Uri.parse(url);
        if (!await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          throw 'Could not launch $url';
        }
      },
    );

    // Authentifizierung starten
    var c = await authenticator.authorize();

    // Token speichern
    //var token = await c.getTokenResponse();
    //print(token.accessToken);
    
    // Benutzerinformationen abrufen
    //var userInfo = await c.getUserInfo();
    //print(userInfo.subject);

    return c;
  }

void main() async{ 
  WidgetsFlutterBinding.ensureInitialized();
  Credential c = await authenticate();
  runApp(MyApp(c: c));
}

class MyApp extends StatelessWidget {
  final Credential c;
  const MyApp({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Model CC',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF24293E),
          primary: const Color(0xFF24293E),
          secondary:const Color(0xFF2F3855),
          surface:  const Color(0xFF181C2A),
        ),
      ),
      home: Navigation(c: c),
    );
  }
}

