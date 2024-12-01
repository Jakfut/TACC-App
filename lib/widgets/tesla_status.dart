import 'package:flutter/material.dart';

class TeslaStatus extends StatefulWidget{
  const TeslaStatus({super.key});

  @override
  State<StatefulWidget> createState() => _TeslaStatusState();
}

class _TeslaStatusState extends State<TeslaStatus>{
  var tstatus = 1;
  var tstatusText = "";
  var tstatusColor = Colors.white;
  
  @override
  Widget build(BuildContext context) {

    if (tstatus == 0) {
      tstatusText = "Establishing";
      tstatusColor = const Color(0xFFD4A45A);
    } else if (tstatus == 1) {
      tstatusText = "Connected";
      tstatusColor = const Color(0xFF66B58C);
    } else if (tstatus == 2) {
      tstatusText = "Disconnected";
      tstatusColor = const Color(0xFFD55A5A);
    }

    return Text(tstatusText, style: TextStyle(color: tstatusColor, fontSize: 16,  fontFamily: 'Inter'));
  }
}


