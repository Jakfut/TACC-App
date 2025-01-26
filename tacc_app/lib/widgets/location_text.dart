import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LocationText extends StatefulWidget{
  const LocationText({super.key});

  @override
  State<StatefulWidget> createState() => _LocationTextState();
}

class _LocationTextState extends State<LocationText>{
  var location = "";
  final String userId = "8a61a7d6-52d1-4dd7-9c60-1f5e08edc28b";

  @override
  void initState() {
    super.initState();
    fetchInfo();
  }

  Future<void> fetchInfo() async {
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:8080/api/user/$userId/tesla/location'));

    if (response.statusCode == 200) {
      setState(() {
        location = response.body;
      });
    } else {
      throw Exception('Failed to load tesla location');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(location, style: const TextStyle(color: Color(0xFFFBFCFE), fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Inter'));
  }
}