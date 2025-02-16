import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:openid_client/openid_client_io.dart';

class TeslaStatus extends StatefulWidget{
  final Credential c;
  const TeslaStatus({super.key, required this.c});

  @override
  State<StatefulWidget> createState() => _TeslaStatusState();
}

class _TeslaStatusState extends State<TeslaStatus>{
  var tstatusText = "Establishing";
  var tstatusColor = Color(0xFFD4A45A);

  var available = false;

  @override
  void initState() {
    super.initState();
    fetchInfo();
  }

  Future<void> fetchInfo() async {
    bool requestCompleted = false;
    Future.delayed(Duration(seconds: 10), () {
      if (!requestCompleted && mounted) {
        setState(() {
          tstatusText = "No connection";
          tstatusColor = const Color(0xFFD55A5A);
        });
      }
    });

    var userInfo = await widget.c.getUserInfo();
    String userId = userInfo.subject;
    var authToken = await widget.c.getTokenResponse();
    final response = await http.get(Uri.parse(
        'https://tacc.jakfut.at/api/user/$userId/tesla/reachable'),
        headers: {
          'Authorization': 'Bearer ${authToken.accessToken}', 
        },
        );

    if (!mounted) return;
    
    if (response.statusCode == 200) {
      setState(() {
        available = jsonDecode(response.body) as bool;
        if(available){
          tstatusText = "Connected";
          tstatusColor = const Color(0xFF66B58C);
        }else{
          tstatusText = "Disconnected";
          tstatusColor = const Color(0xFFD55A5A);
        }
      });
    } else if (response.statusCode == 404){
      tstatusText = "Disconnected";
      tstatusColor = const Color(0xFFD55A5A);
    }else {
      tstatusText = "Disconnected";
      tstatusColor = const Color(0xFFD55A5A);
      //throw Exception('Failed to load tesla availability');
    }
    requestCompleted = true;
  }
  
  @override
  Widget build(BuildContext context) {
    return Text(tstatusText, style: TextStyle(color: tstatusColor, fontSize: 16,  fontFamily: 'Inter'));
  }
}


