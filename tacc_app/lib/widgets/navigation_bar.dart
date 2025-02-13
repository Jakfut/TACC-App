import 'package:openid_client/openid_client_io.dart';
import 'package:tacc_app/pages/calendar_setting_page.dart';
import 'package:tacc_app/pages/main_page.dart';
import 'package:tacc_app/pages/setting_page.dart';
import 'package:tacc_app/pages/tesla_setting_page.dart';
import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  final Credential c;
  const Navigation({super.key, required this.c});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
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
        page = MainPage(c: widget.c);
        break;
      case 1:
        page = SettingPage(c: widget.c);
        break;
      case 2:
        page = TeslaSettingPage(c: widget.c);
        break;
      case 3:
        page = CalendarSettingPage(c: widget.c);
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                AppBar( 
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
                          appBar = true;
                        }
                      });
                      changeState();
                    }
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.primary,
                    child: page,
                  ),
                ),
              ],
            ),
            
            if(isVisible)
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: constraints.maxWidth * 0.8,
                  height: MediaQuery.of(context).size.height,
                  child: Material(
                    color: Theme.of(context).colorScheme.surface,
                    child: Column(
                      children: [
                        //SizedBox(height: kToolbarHeight),
                        Expanded(
                          child: NavigationRail(
                            extended: isVisible,
                            backgroundColor: Colors.transparent,
                            labelType: NavigationRailLabelType.none,
                            selectedLabelTextStyle: TextStyle(
                              color: Color(0xFFFBFCFE), 
                              fontSize: 12, 
                              fontWeight: FontWeight.bold, 
                              fontFamily: 'Inter'
                            ),
                            unselectedLabelTextStyle: TextStyle(
                              color: Color(0xFFFBFCFE), 
                              fontSize: 12, 
                              fontWeight: FontWeight.bold, 
                              fontFamily: 'Inter'
                            ),
                            useIndicator: false,
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
                                if(value != 0) {
                                  appBar = false;
                                }
                              });
                              changeState();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}