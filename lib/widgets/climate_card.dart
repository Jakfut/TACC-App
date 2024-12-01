import 'package:flutter/material.dart';

class ClimateCard extends StatefulWidget {
  const ClimateCard({super.key,});

  @override
  State<StatefulWidget> createState() => _ClimateCardState();
}

class _ClimateCardState extends State<ClimateCard>{
  var cstatusText = "";
  var cstatusColor = Colors.white;
  var cstatus = 0;
  var bText = "";

  void changeState(){
    setState(() {
      if(cstatus == 1){
        cstatus = 2;
      }else if(cstatus ==2 ){
        cstatus = 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    if (cstatus == 0) {
      cstatusText = "Loading ...";
      cstatusColor = const Color(0xFFD4A45A);
      bText = "...";
    } else if (cstatus == 1) {
      cstatusText = "Active";
      cstatusColor = const Color(0xFF66B58C);
      bText = "Turn off";
    } else if (cstatus == 2) {
      cstatusText = "Inactive";
      cstatusColor = const Color(0xFFD55A5A);
      bText = "Turn on";
    }

    return Card(
      elevation: 5,
      color: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05, vertical: MediaQuery.of(context).size.width * 0.05),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, 
          children: [
            Row(
              children: [
                const Icon(
                  Icons.mode_fan_off,
                  color: Color(0xFF8EBBFF),
                  size: 40,
                ),
                const SizedBox(width: 10),
                Text(
                  cstatusText,
                  style: TextStyle(color: cstatusColor, fontSize: 16, fontFamily: 'Inter'),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8EBBFF)
               ),
              onPressed: changeState,
              child: Text(bText,
              style: const TextStyle(fontSize: 16, fontFamily: 'Inter', fontWeight: FontWeight.bold),),
            ),
          ],
        ),
      )
    );
  }
}

