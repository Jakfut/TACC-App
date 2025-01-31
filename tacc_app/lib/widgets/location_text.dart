import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LocationText extends StatefulWidget{
  final String uuid;
  const LocationText({super.key, required this.uuid});

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
    final response = await http.get(Uri.parse(
        'http://tacc.jakfut.at/api/user/${widget.uuid}/tesla/location'));

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