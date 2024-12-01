import 'package:flutter/material.dart';

class LocationText extends StatefulWidget{
  const LocationText({super.key});

  @override
  State<StatefulWidget> createState() => _LocationTextState();
}

class _LocationTextState extends State<LocationText>{
  var location = "Example Street 1, 12345 Example City,  Austria";

  @override
  Widget build(BuildContext context) {
    return Text(location, style: const TextStyle(color: Color(0xFFFBFCFE), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Inter'));
  }
}