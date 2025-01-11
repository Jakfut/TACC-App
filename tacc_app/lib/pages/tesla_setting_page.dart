import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tacc_app/widgets/api_select.dart';
import 'package:tacc_app/widgets/vin.dart';
import 'package:tacc_app/widgets/access_token.dart';
import 'package:tacc_app/widgets/tesla_save_button.dart';
import 'package:tacc_app/widgets/tesla_deactivate_button.dart';
import 'package:tacc_app/widgets/tesla_activate_button.dart';
import 'package:http/http.dart' as http;

class TeslaSettingPage extends StatefulWidget {
  const TeslaSettingPage({super.key});

  @override
  State<StatefulWidget> createState() => _TeslaSettingPageState();
}

Future<TeslaInfo> fetchTeslaInfo(String userId) async {
  final response = await http.get(Uri.parse(
      'http://10.0.2.2:8080/api/user/${userId}/tesla-connections/tessie'));

  if (response.statusCode == 200) {
    return TeslaInfo.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else if(response.statusCode == 404){
    final Map<String, String> payload = {
      'accessToken': '',
      'vin': '',
    };
    await http.post(Uri.parse('http://10.0.2.2:8080/api/user/${userId}/tesla-connections/tessie'), headers: {'Content-Type': 'application/json'}, body: jsonEncode(payload));
    return fetchTeslaInfo(userId);
  }else {
    throw Exception('Failed to load tesla info');
  }
}

Future<String?> fetchUserInfo(String userId) async {
  try {
    final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/user/${userId}'));

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
  late Future<TeslaInfo> teslaInfo;
  late Future<String?> connected;
  final String userId = "8a61a7d6-52d1-4dd7-9c60-1f5e08edc28b";

  @override
  void initState() {
    super.initState();
    teslaInfo = fetchTeslaInfo(userId);
    fetchUserInfo(userId).then((result) {
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
        child: FutureBuilder<TeslaInfo>(
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
                    SaveButton(vin, accessToken, userId),
                    SizedBox(height: 40),

                    ValueListenableBuilder<bool>(
                      valueListenable: _connected,
                      builder: (context, connected, child) {
                        if (connected) {
                          return DeactivateButton(userId, _connected);
                        } else {
                          return ActivateButton(userId, _connected);
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
                return const Center(child: Text('No data available'));
              }
            }),
      ),
    );
  }
}
