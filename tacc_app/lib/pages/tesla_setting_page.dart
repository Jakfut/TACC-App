import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:openid_client/openid_client_io.dart';
import 'package:tacc_app/widgets/api_select.dart';
import 'package:tacc_app/widgets/vin.dart';
import 'package:tacc_app/widgets/access_token.dart';
import 'package:tacc_app/widgets/tesla_save_button.dart';
import 'package:tacc_app/widgets/tesla_save_new_button.dart';
import 'package:tacc_app/widgets/tesla_deactivate_button.dart';
import 'package:tacc_app/widgets/tesla_activate_button.dart';
import 'package:http/http.dart' as http;

class TeslaSettingPage extends StatefulWidget {
  final Credential c;
  const TeslaSettingPage({super.key, required this.c});

  @override
  State<StatefulWidget> createState() => _TeslaSettingPageState();
}

Future<TeslaInfo?> fetchTeslaInfo(Credential c) async {
  var userInfo = await c.getUserInfo();
  String userId = userInfo.subject;
  var authToken = await c.getTokenResponse();
  final response = await http.get(Uri.parse(
      'https://tacc.jakfut.at/api/user/$userId/tesla-connections/tessie'),
      headers: {
        'Authorization': 'Bearer $authToken', 
      }
  );

  if (response.statusCode == 200) {
    return TeslaInfo.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } /*else if(response.statusCode == 404){
    final Map<String, String> payload = {
      'accessToken': '',
      'vin': '',
    };
    await http.post(Uri.parse('https://tacc.jakfut.at/api/user/$userId/tesla-connections/tessie'), headers: {'Content-Type': 'application/json'}, body: jsonEncode(payload));
    return fetchTeslaInfo(c);
  }*/else {
    return null;
  }
}

Future<String?> fetchUserInfo(Credential c) async {
  try {
    var userInfo = await c.getUserInfo();
    String userId = userInfo.subject;
    var authToken = await c.getTokenResponse();
    final response = await http.get(
        Uri.parse('https://tacc.jakfut.at/api/user/$userId'),
      headers: {
        'Authorization': 'Bearer ${authToken.accessToken}', 
      }
      );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['activeTeslaConnectionType'] as String?;
    } else {
      return null; 
    }
  } catch (e) {
    return null; 
  }
}

class TeslaInfo {
  final String vin;
  final String accessToken;

  const TeslaInfo({
    required this.vin,
    required this.accessToken,
  });

  factory TeslaInfo.fromJson(Map<String, dynamic> json) {
    return TeslaInfo(
      vin: json['vin'] as String,
      accessToken: json['accessToken'] as String,
    );
  }
}

class _TeslaSettingPageState extends State<TeslaSettingPage> {
  late Future<TeslaInfo?> teslaInfo;
  late Future<String?> connected;

  @override
  void initState() {
    super.initState();
    teslaInfo = fetchTeslaInfo(widget.c);
    fetchUserInfo(widget.c).then((result) {
      if(result?.isNotEmpty == null){
        _connected.value = false;
      }else{
        _connected.value = true;
      }
    });
  }

  ValueNotifier vin = ValueNotifier(0);
  ValueNotifier accessToken = ValueNotifier(0);
  ValueNotifier<bool> _connected = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.075),
        child: FutureBuilder<TeslaInfo?>(
            future: teslaInfo,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                vin.value = snapshot.data!.vin;
                accessToken.value = snapshot.data!.accessToken;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tesla setup",
                        style: TextStyle(
                            color: Color(0xFFFBFCFE),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Ubuntu')),
                    SizedBox(height: 40),
                    APISelect(),
                    SizedBox(height: 40),
                    VIN(vin),
                    SizedBox(height: 30),
                    AccessToken(accessToken),
                    SizedBox(height: 40),
                    SaveButton(vin, accessToken, widget.c),
                    SizedBox(height: 40),

                    ValueListenableBuilder<bool>(
                      valueListenable: _connected,
                      builder: (context, connected, child) {
                        if (connected) {
                          return DeactivateButton(widget.c, _connected);
                        } else {
                          return ActivateButton(widget.c, _connected);
                        }
                      },
                    )

                    /*FutureBuilder<String?>(
                      future: connected,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData && snapshot.data != null) {
                          // connectedType is available; show DeactivateButton
                          return DeactivateButton(userId);
                        } else {
                          // connectedType is null; show ActivateButton
                          return ActivateButton(userId);
                        }
                      },
                    ),*/
                  ],
                );
              } else {
                vin.value = "";
                accessToken.value = "";
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tesla setup",
                        style: TextStyle(
                            color: Color(0xFFFBFCFE),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Ubuntu')),
                    SizedBox(height: 40),
                    APISelect(),
                    SizedBox(height: 40),
                    VIN(vin),
                    SizedBox(height: 30),
                    AccessToken(accessToken),
                    SizedBox(height: 40),
                    SaveNewButton(vin, accessToken, widget.c),
                    SizedBox(height: 40),

                    ValueListenableBuilder<bool>(
                      valueListenable: _connected,
                      builder: (context, connected, child) {
                        if (connected) {
                          return DeactivateButton(widget.c, _connected);
                        } else {
                          return ActivateButton(widget.c, _connected);
                        }
                      },
                    )
                  ],
                );
              }
            }),
      ),
    );
  }
}
