import 'package:flutter/material.dart';
import 'package:tacc_app/pages/calendar_setting_page.dart';
import 'package:tacc_app/pages/main_page.dart';
import 'package:tacc_app/pages/setting_page.dart';
import 'package:tacc_app/pages/tesla_setting_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tacc app',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF24293E),
          primary: const Color(0xFF24293E),
          secondary: const Color(0xFF2F3855),
          surface:  const Color(0xFF181C2A),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0; 
  var isVisible = false;
  var appBar = true;
  var UUID = "8a61a7d6-52d1-4dd7-9c60-1f5e08edc28b";

  void changeState(){
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const MainPage();
        break;
      case 1:
        page = const SettingPage();
        break;
      case 2:
        page = const TeslaSettingPage();
        break;
      case 3:
        page = const CalendarSettingPage();
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


