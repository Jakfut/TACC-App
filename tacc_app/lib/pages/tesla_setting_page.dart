import 'package:flutter/material.dart';
import 'package:tacc_app/widgets/api_select.dart';
import 'package:tacc_app/widgets/vin.dart';
import 'package:tacc_app/widgets/access_token.dart';
import 'package:tacc_app/widgets/save_button.dart';
import 'package:tacc_app/widgets/deactivate_button.dart';

class TeslaSettingPage extends StatelessWidget {
  const TeslaSettingPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.075),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tesla setup", style: TextStyle(color: Color(0xFFFBFCFE), fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu')),
            SizedBox(height:  40),
            APISelect(),
            SizedBox(height:  40),
            VIN(),
            SizedBox(height:  30),
            AccessToken(),
            SizedBox(height:  40),
            SaveButton(),
            SizedBox(height:  40),
            DeactivateButton()
          ],
        )
      ),
    );
  }
}
