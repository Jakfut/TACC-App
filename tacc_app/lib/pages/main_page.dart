import 'package:flutter/material.dart';
import 'package:tacc_app/widgets/climate_card.dart';
import 'package:tacc_app/widgets/list_card.dart';
import 'package:tacc_app/widgets/location_card.dart';
import 'package:tacc_app/widgets/tesla_status.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final String userId = "8a61a7d6-52d1-4dd7-9c60-1f5e08edc28b";
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.075),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tesla Status", style: TextStyle(color: Color(0xFFFBFCFE), fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu')),
            TeslaStatus(),
            LocationCard(),
            ClimateCard(),
            SizedBox(height:  50),
            Text("Upcoming Activations", style: TextStyle(color: Color(0xFFFBFCFE), fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu')),
            ListCard()
          ],
        )
      ),
    );
  }
}
