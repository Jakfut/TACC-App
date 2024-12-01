import 'package:flutter/material.dart';
import 'package:tacc_app/widgets/destination_card.dart';
import 'package:tacc_app/widgets/arrival_buffer_card.dart';
import 'package:tacc_app/widgets/runtime_card.dart';
import 'package:tacc_app/widgets/save_button.dart';
import 'package:tacc_app/widgets/sign_out_button.dart';
import 'package:tacc_app/widgets/delete_account_button.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>{
  ValueNotifier destTime = ValueNotifier(0);
  ValueNotifier runTime = ValueNotifier(0);
  ValueNotifier bufferTime = ValueNotifier(0);

  void changeState(){
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.075),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Settings", style: TextStyle(color: Color(0xFFFBFCFE), fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu')),
            DestinationCard(destTime),
            RuntimeCard(runTime),
            ArrivalBufferCard(bufferTime),
            const SaveButton(),
            const SizedBox(height:  50),
            const Text("Account", style: TextStyle(color: Color(0xFFFBFCFE), fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu')),
            const SignOutButton(),
            const DeleteAccountButton(),
          ],
        )
      ),
    );
  }
}