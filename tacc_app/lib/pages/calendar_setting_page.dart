import 'package:flutter/material.dart';
import 'package:tacc_app/widgets/calendar_select.dart';
import 'package:tacc_app/widgets/keyword_select.dart';
import 'package:tacc_app/widgets/save_button.dart';
import 'package:tacc_app/widgets/disconnect_button.dart';
import 'package:tacc_app/widgets/activate_button.dart';

class CalendarSettingPage extends StatelessWidget {
  const CalendarSettingPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.075),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Calendar setup", style: TextStyle(color: Color(0xFFFBFCFE), fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu')),
            SizedBox(height:  40),
            CalendarSelect(),
            SizedBox(height:  40),
            KeywordSelect(),
            SizedBox(height:  40),
            SaveButton(),
            SizedBox(height:  40),
            DisconnectButton(),
            SizedBox(height:  40),
            ActivateButton(),
          ],
        )
      ),
    );
  }
}
