import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:openid_client/openid_client_io.dart';
import 'package:tacc_app/widgets/calendar_select.dart';
import 'package:tacc_app/widgets/keyword_select.dart';
import 'package:tacc_app/widgets/keyword_select2.dart';
import 'package:tacc_app/widgets/calendar_save_button.dart';
import 'package:tacc_app/widgets/calendar_save_new_button.dart';
import 'package:tacc_app/widgets/google_disconnect_button.dart';
import 'package:tacc_app/widgets/google_connect_button.dart';
import 'package:tacc_app/widgets/calendar_activate_button.dart';
import 'package:tacc_app/widgets/calendar_deactivate_button.dart';
import 'package:http/http.dart' as http;

class CalendarSettingPage extends StatefulWidget {
  final Credential c;
  const CalendarSettingPage({super.key, required this.c});

  @override
  State<StatefulWidget> createState() => _CalendarSettingPageState();
}

Future<CalendarInfo?> fetchInfo(Credential c) async {
  var userInfo = await c.getUserInfo();
  String userId = userInfo.subject;
  var authToken = await c.getTokenResponse();
  final response = await http.get(Uri.parse(
      'https://tacc.jakfut.at/api/user/${userId}/calendar-connections/google-calendar'),
      headers: {
        'Authorization': 'Bearer ${authToken.accessToken}', 
      }
      );

  if (response.statusCode == 200) {
    return CalendarInfo.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    return null;
  }
}

class CalendarInfo {
  final String? email;
  final String keywordStart;
  final String keywordEnd;

  const CalendarInfo({
    this.email,
    required this.keywordStart,
    required this.keywordEnd,
  });

  factory CalendarInfo.fromJson(Map<String, dynamic> json) {
    return CalendarInfo(
        email: json['email'] as String?,
        keywordStart: json['keywordStart'] as String,
        keywordEnd: json['keywordEnd'] as String);
  }
}

Future<String?> fetchUserInfo(Credential c) async {
  try {
    var userInfo = await c.getUserInfo();
    String userId = userInfo.subject;
    var authToken = await c.getTokenResponse();
    final response = await http.get(
        Uri.parse('https://tacc.jakfut.at/api/user/${userId}'),
        headers: {
        'Authorization': 'Bearer ${authToken.accessToken}', 
      }
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['activeCalendarConnectionType'] as String?;
    } else {
      return null; 
    }
  } catch (e) {
    return null; 
  }
}

class _CalendarSettingPageState extends State<CalendarSettingPage> {
  late Future<CalendarInfo?> calendarInfo;

  @override
  void initState() {
    super.initState();
    calendarInfo = fetchInfo(widget.c);
    fetchUserInfo(widget.c).then((result) {
      if(result?.isNotEmpty == null){
        _calendarConnected.value = false;
      }else{
        _calendarConnected.value = true;
      }
    });
  }

  final keywordStart = ValueNotifier<String>("");
  final keywordEnd = ValueNotifier<String>("");

  void changeState() {
    setState(() {});
  }
  ValueNotifier<bool> _googleConnected = ValueNotifier(false);
  ValueNotifier<bool> _calendarConnected = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.075),
        child: FutureBuilder<CalendarInfo?>(
            future: calendarInfo,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                keywordStart.value = snapshot.data!.keywordStart;
                keywordEnd.value = snapshot.data!.keywordEnd;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Calendar setup",
                        style: TextStyle(
                            color: Color(0xFFFBFCFE),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Ubuntu')),
                    const SizedBox(height: 40),
                    const CalendarSelect(),
                    const SizedBox(height: 40),
                    KeywordSelect(keywordStart),
                    const SizedBox(height: 40),
                    KeywordSelect2(keywordEnd),
                    const SizedBox(height: 40),
                    SaveButton(keywordStart, keywordEnd, widget.c),
                    const SizedBox(height: 40),
                    ValueListenableBuilder<bool>(
                      valueListenable: _googleConnected,
                      builder: (context, connected, child) {
                        if (connected) {
                          return DisconnectButton(/*userId, _googleConnected*/);
                        } else {
                          return ConnectButton(c: widget.c);
                        }
                      },
                    ),
                    const SizedBox(height: 40),
                    ValueListenableBuilder<bool>(
                      valueListenable: _calendarConnected,
                      builder: (context, connected, child) {
                        if (connected) {
                          return DeactivateButton(widget.c, _calendarConnected);
                        } else {
                          return ActivateButton(widget.c, _calendarConnected);
                        }
                      },
                    ),
                  ],
                );
              } else {
                keywordStart.value = "";
                keywordEnd.value = "";

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Calendar setup",
                        style: TextStyle(
                            color: Color(0xFFFBFCFE),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Ubuntu')),
                    const SizedBox(height: 40),
                    const CalendarSelect(),
                    const SizedBox(height: 40),
                    KeywordSelect(keywordStart),
                    const SizedBox(height: 40),
                    KeywordSelect2(keywordEnd),
                    const SizedBox(height: 40),
                    SaveNewButton(keywordStart, keywordEnd, widget.c),
                    const SizedBox(height: 40),
                    ValueListenableBuilder<bool>(
                      valueListenable: _googleConnected,
                      builder: (context, connected, child) {
                        if (connected) {
                          return DisconnectButton(/*userId, _googleConnected*/);
                        } else {
                          return ConnectButton(c: widget.c);
                        }
                      },
                    ),
                    const SizedBox(height: 40),
                    ValueListenableBuilder<bool>(
                      valueListenable: _calendarConnected,
                      builder: (context, connected, child) {
                        if (connected) {
                          return DeactivateButton(widget.c, _calendarConnected);
                        } else {
                          return ActivateButton(widget.c, _calendarConnected);
                        }
                      },
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }
}
