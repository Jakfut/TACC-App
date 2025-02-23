import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:openid_client/openid_client_io.dart';
import 'package:tacc_app/widgets/destination_card.dart';
import 'package:tacc_app/widgets/arrival_buffer_card.dart';
import 'package:tacc_app/widgets/runtime_card.dart';
import 'package:tacc_app/widgets/settings_save_button.dart';
import 'package:tacc_app/widgets/sign_out_button.dart';
import 'package:tacc_app/widgets/delete_account_button.dart';

class SettingPage extends StatefulWidget {
  final Credential c;
  const SettingPage({super.key, required this.c});

  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

Future<UserInfo> fetchUserInfo(Credential c) async {
  var userInfo = await c.getUserInfo();
  String userId = userInfo.subject;
  var authToken = await c.getTokenResponse();
  final response = await http.get(Uri.parse(
      'https://tacc.jakfut.at/api/user/${userId}'),
      headers: {
        'Authorization': 'Bearer ${authToken.accessToken}', 
      }
      );

  if (response.statusCode == 200) {
    return UserInfo.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load user info');
  }
}

class UserInfo {
  final String id;
  final String email;
  final int noDestMinutes;
  final int ccRuntimeMinutes;
  final int arrivalBufferMinutes;
  final String? activeCalendarConnectionType;
  final String? activeTeslaConnectionType;

  const UserInfo({
    required this.id,
    required this.email,
    required this.noDestMinutes,
    required this.ccRuntimeMinutes,
    required this.arrivalBufferMinutes,
    this.activeCalendarConnectionType,
    this.activeTeslaConnectionType,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
      return UserInfo(
      id: json['id'] as String,
      email: json['email'] as String,
      noDestMinutes: json['noDestMinutes'] as int,
      ccRuntimeMinutes: json['ccRuntimeMinutes'] as int,
      arrivalBufferMinutes: json['arrivalBufferMinutes'] as int,
      activeCalendarConnectionType: json['activeCalendarConnectionType'] as String?,
      activeTeslaConnectionType: json['activeTeslaConnectionType'] as String?,
      );
    }
  }


class _SettingPageState extends State<SettingPage> {
  late Future<UserInfo> userInfo;

  @override
  void initState() {
    super.initState();
    userInfo = fetchUserInfo(widget.c);
  }

  ValueNotifier destTime = ValueNotifier(0);
  ValueNotifier runTime = ValueNotifier(0);
  ValueNotifier bufferTime = ValueNotifier(0);
  ValueNotifier destValidNotifier = ValueNotifier(true);
  ValueNotifier runValidNotifier = ValueNotifier(true);
  ValueNotifier arrivalValidNotifier = ValueNotifier(true);

  void changeState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.075),
          child: FutureBuilder<UserInfo>(
              future: userInfo,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  destTime.value = snapshot.data!.noDestMinutes;
                  runTime.value = snapshot.data!.ccRuntimeMinutes;
                  bufferTime.value = snapshot.data!.arrivalBufferMinutes;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Settings",
                          style: TextStyle(
                              color: Color(0xFFFBFCFE),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Ubuntu')),
                      DestinationCard(destTime, destValidNotifier),
                      RuntimeCard(runTime, runValidNotifier),
                      ArrivalBufferCard(bufferTime, arrivalValidNotifier),
                      SaveButton(destTime, runTime, bufferTime, destValidNotifier, runValidNotifier, arrivalValidNotifier, widget.c),
                      const SizedBox(height: 50),
                      const Text("Account",
                          style: TextStyle(
                              color: Color(0xFFFBFCFE),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Ubuntu')),
                      const SignOutButton(),
                      DeleteAccountButton(c: widget.c),
                    ],
                  );
                } else {
                  return const Center(child: Text('No data available'));
                }
              }),
        ));
  }
}
