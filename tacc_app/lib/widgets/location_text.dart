import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:openid_client/openid_client_io.dart';

class LocationText extends StatefulWidget{
  final Credential c;
  const LocationText({super.key, required this.c});

  @override
  State<StatefulWidget> createState() => _LocationTextState();
}

class _LocationTextState extends State<LocationText>{
  var location = "";

  @override
  void initState() {
    super.initState();
    fetchInfo();
  }

  Future<void> fetchInfo() async {
    var userInfo = await widget.c.getUserInfo();
    String userId = userInfo.subject;
    var authToken = await widget.c.getTokenResponse();
    final response = await http.get(Uri.parse(
        'https://tacc.jakfut.at/api/user/$userId/tesla/location'),
        headers: {
        'Authorization': 'Bearer ${authToken.accessToken}', 
      }
      );

    if (!mounted) return;

    if (response.statusCode == 200) {
      setState(() {
        location = response.body;
      });
    } else {
      //throw Exception('Failed to load tesla location');
      setState(() {
        location = '';
      });
      //throw Exception(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(location, style: const TextStyle(color: Color(0xFFFBFCFE), fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Inter'));
  }
}