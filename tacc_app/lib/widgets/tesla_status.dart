import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TeslaStatus extends StatefulWidget{
  const TeslaStatus({super.key});

  @override
  State<StatefulWidget> createState() => _TeslaStatusState();
}

class _TeslaStatusState extends State<TeslaStatus>{
  var tstatusText = "Establishing";
  var tstatusColor = Color(0xFFD4A45A);

  var available = false;
  final String userId = "8a61a7d6-52d1-4dd7-9c60-1f5e08edc28b";

  @override
  void initState() {
    super.initState();
    fetchInfo();
  }

  Future<void> fetchInfo() async {
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:8080/api/user/$userId/tesla/reachable'));

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
    } else {
      throw Exception('Failed to load tesla availability');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Text(tstatusText, style: TextStyle(color: tstatusColor, fontSize: 16,  fontFamily: 'Inter'));
  }
}


