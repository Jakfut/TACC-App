import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TeslaStatus extends StatefulWidget{
  final String uuid;
  const TeslaStatus({super.key, required this.uuid});

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
    final response = await http.get(Uri.parse(
        'http://tacc.jakfut.at/api/user/${widget.uuid}/tesla/reachable'));

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


