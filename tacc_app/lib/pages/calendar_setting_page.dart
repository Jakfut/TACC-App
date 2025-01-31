import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tacc_app/widgets/calendar_select.dart';
import 'package:tacc_app/widgets/keyword_select.dart';
import 'package:tacc_app/widgets/calendar_save_button.dart';
import 'package:tacc_app/widgets/google_disconnect_button.dart';
import 'package:tacc_app/widgets/google_connect_button.dart';
import 'package:tacc_app/widgets/calendar_activate_button.dart';
import 'package:tacc_app/widgets/calendar_deactivate_button.dart';
import 'package:http/http.dart' as http;

class CalendarSettingPage extends StatefulWidget {
  final String uuid;
  const CalendarSettingPage({super.key, required this.uuid});

  @override
  State<StatefulWidget> createState() => _CalendarSettingPageState();
}

Future<CalendarInfo> fetchInfo(String userId) async {
  final response = await http.get(Uri.parse(
      'http://tacc.jakfut.at/api/user/${userId}/calendar-connections/google-calendar'));

  if (response.statusCode == 200) {
    return CalendarInfo.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else if(response.statusCode == 404){
    final Map<String, String> payload = {
      'keyword': '#tacc',
    };
    await http.post(Uri.parse('http://tacc.jakfut.at/api/user/${userId}/calendar-connections/google-calendar'), headers: {'Content-Type': 'application/json'}, body: jsonEncode(payload));
    return fetchInfo(userId);
  } else {
    throw Exception('Failed to load user info');
  }
}

class CalendarInfo {
  final String? email;
  final String keyword;

  const CalendarInfo({
    this.email,
    required this.keyword,
  });

  factory CalendarInfo.fromJson(Map<String, dynamic> json) {
    return CalendarInfo(
        email: json['email'] as String?,
        keyword: json['keyword'] as String);
  }
}

Future<String?> fetchUserInfo(String userId) async {
  try {
    final response = await http.get(
        Uri.parse('http://tacc.jakfut.at/api/user/${userId}'));

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
  late Future<CalendarInfo> calendarInfo;

  @override
  void initState() {
    super.initState();
    calendarInfo = fetchInfo(widget.uuid);
    fetchUserInfo(widget.uuid).then((result) {
      if(result?.isNotEmpty == null){
        _calendarConnected.value = false;
      }else{
        _calendarConnected.value = true;
      }
    });
  }

  ValueNotifier keyword = ValueNotifier("");

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
        child: FutureBuilder<CalendarInfo>(
            future: calendarInfo,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                keyword.value = snapshot.data!.keyword;

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
                    KeywordSelect(keyword),
                    const SizedBox(height: 40),
                    SaveButton(keyword, widget.uuid),
                    const SizedBox(height: 40),
                    ValueListenableBuilder<bool>(
                      valueListenable: _googleConnected,
                      builder: (context, connected, child) {
                        if (connected) {
                          return DisconnectButton(/*userId, _googleConnected*/);
                        } else {
                          return ConnectButton(uuid: widget.uuid);
                        }
                      },
                    ),
                    const SizedBox(height: 40),
                    ValueListenableBuilder<bool>(
                      valueListenable: _calendarConnected,
                      builder: (context, connected, child) {
                        if (connected) {
                          return DeactivateButton(widget.uuid, _calendarConnected);
                        } else {
                          return ActivateButton(widget.uuid, _calendarConnected);
                        }
                      },
                    ),
                  ],
                );
              } else {
                return const Center(child: Text('No data available'));
              }
            }),
      ),
    );
  }
}
