import 'package:flutter/material.dart';
import 'package:tacc_app/pages/calendar_setting_page.dart';
import 'package:tacc_app/pages/main_page.dart';
import 'package:tacc_app/pages/setting_page.dart';
import 'package:tacc_app/pages/tesla_setting_page.dart';
import 'package:openid_client/openid_client_io.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

Future<String> authenticate() async {
  // Keycloak-Server-URL
  var uri = Uri.parse('https://keycloak.jakfut.at/realms/tacc');

  // Discovery-Dokument laden
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
  var token = await c.getTokenResponse();

  // Benutzerinformationen abrufen
  var userInfo = await c.getUserInfo();

  // Beispiel: Benutzername anzeigen
  return userInfo.subject;
}
void main() async{ 
  WidgetsFlutterBinding.ensureInitialized();
  String uuid = await authenticate();
  runApp(MyApp(uuid: uuid));
}

class MyApp extends StatelessWidget {
  final String uuid;
  const MyApp({super.key, required this.uuid});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tacc app',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF24293E),
          primary: const Color(0xFF24293E),
          secondary:const Color(0xFF2F3855),
          surface:  const Color(0xFF181C2A),
        ),
      ),
      home: MyHomePage(uuid: uuid),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String uuid;
  const MyHomePage({super.key, required this.uuid});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0; 
  var isVisible = false;
  var appBar = true;
  

  void changeState(){
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = MainPage(uuid: widget.uuid);
        break;
      case 1:
        page = SettingPage(uuid: widget.uuid);
        break;
      case 2:
        page = TeslaSettingPage(uuid: widget.uuid);
        break;
      case 3:
        page = CalendarSettingPage(uuid: widget.uuid);
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar( 
          backgroundColor: Theme.of(context).colorScheme.primary,
          centerTitle: true,
          title: Transform.scale(
            scale: 0.8, 
            child: const Image(
              image: AssetImage('assets/Icon_text_right.png'),
              fit: BoxFit.contain,
            ),
          ),
          leading: IconButton( 
            icon: Icon(appBar ? Icons.menu : Icons.close),
            onPressed: () {
              setState(() {
                if (appBar) {
                    isVisible = true;
                } else {
                    selectedIndex = 0;
                    isVisible = false;
                    appBar=true;
                }
              });
              changeState();
            }
          ),
        ),
        body: Stack(
          children: [
            Container(
              color: Theme.of(context).colorScheme.primary,
              child: page,
            ),
            if(isVisible)
            SafeArea(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: constraints.maxWidth * 0.8,
                  child: NavigationRail(
                    extended: isVisible,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    labelType: NavigationRailLabelType.none,
                    selectedLabelTextStyle: TextStyle(color: Color(0xFFFBFCFE), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                    unselectedLabelTextStyle: TextStyle(color: Color(0xFFFBFCFE), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                    destinations: const <NavigationRailDestination>[
                      NavigationRailDestination(
                        icon: Icon(Icons.backspace, color: Color(0xFFFBFCFE)),
                        label: Text(''),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.settings, color: Color(0xFFFBFCFE)),
                        label: Text('Settings'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.car_rental, color: Color(0xFFFBFCFE)),
                        label: Text('Tesla setup'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.calendar_month, color: Color(0xFFFBFCFE)),
                        label: Text('Calendar setup'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                        isVisible = false;
                        if(value!=0){
                          appBar = false;
                        }
                      });
                      changeState();
                    },
                  ),
                )
              )
            ),
          ],
        ),
      );
    });
  }
}


