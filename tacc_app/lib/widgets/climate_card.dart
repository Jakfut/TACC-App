import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ClimateCard extends StatefulWidget {
  const ClimateCard({super.key,});

  @override
  State<StatefulWidget> createState() => _ClimateCardState();
}

class _ClimateCardState extends State<ClimateCard>{
  var cstatusText = "Loading ...";
  var cstatusColor = Color(0xFFD4A45A);
  var bText = "...";

  var climate = false;
  final String userId = "8a61a7d6-52d1-4dd7-9c60-1f5e08edc28b";

  @override
  void initState() {
    super.initState();
    fetchInfo();
  }

  Future<void> fetchInfo() async {
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:8080/api/user/$userId/tesla/climate/state'));

    if (response.statusCode == 200) {
      setState(() {
        climate = jsonDecode(response.body) as bool;
        if(climate){
          cstatusText = "Active";
          cstatusColor = const Color(0xFF66B58C);
          bText = "Turn off";
        }else{
          cstatusText = "Inactive";
          cstatusColor = const Color(0xFFD55A5A);
          bText = "Turn on";
        }
      });
    } else {
      throw Exception('Failed to load tesla availability');
    }
  }

  void changeState(){
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
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

