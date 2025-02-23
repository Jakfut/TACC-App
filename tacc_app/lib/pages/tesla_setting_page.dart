import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:openid_client/openid_client_io.dart';
import 'package:tacc_app/widgets/api_select.dart';
import 'package:tacc_app/widgets/vin.dart';
import 'package:tacc_app/widgets/access_token.dart';
import 'package:tacc_app/widgets/tesla_save_button.dart';
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
        'Authorization': 'Bearer ${authToken.accessToken}', 
      }
  );

  if (response.statusCode == 200) {
    return TeslaInfo.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  }else {
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

  ValueNotifier<String> vin = ValueNotifier("");
  ValueNotifier<String> accessToken = ValueNotifier("");
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
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Tesla setup",
                      style: TextStyle(
                          color: Color(0xFFFBFCFE),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Ubuntu')),
                  const SizedBox(height: 40),
                  const APISelect(),
                  const SizedBox(height: 40),
                  VIN(vin),
                  const SizedBox(height: 30),
                  AccessToken(accessToken),
                  const SizedBox(height: 40),

                    if(snapshot.hasData) ...[
                      SaveTeslaConnectionButton( // Use the unified button
                        vinNotifier: vin,
                        accessTokenNotifier: accessToken,
                        c: widget.c,
                        saveType: SaveType.save, // Existing connection
                      ),
                  ] else ...[
                    SaveTeslaConnectionButton( // Use the unified button
                      vinNotifier: vin,
                      accessTokenNotifier: accessToken,
                      c: widget.c,
                      saveType: SaveType.saveNew, // New Connection
                    ),
                  ],
                  const SizedBox(height: 40),
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
          },
        ),
      ),
    );
  }
}