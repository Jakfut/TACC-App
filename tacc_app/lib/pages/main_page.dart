import 'package:flutter/material.dart';
import 'package:openid_client/openid_client_io.dart';
import 'package:tacc_app/widgets/climate_card.dart';
import 'package:tacc_app/widgets/location_card.dart';
import 'package:tacc_app/widgets/tesla_status.dart';
import 'package:tacc_app/widgets/upcoming_activations.dart';

class MainPage extends StatefulWidget {
  final Credential c;
  const MainPage({super.key, required this.c});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
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
            Text("Tesla Status", style: TextStyle(color: Color(0xFFFBFCFE), fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu')),
            TeslaStatus(c: widget.c),
            LocationCard(c: widget.c),
            ClimateCard(c: widget.c),
            SizedBox(height:  50),
            Text("Upcoming Activations", style: TextStyle(color: Color(0xFFFBFCFE), fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu')),
            Expanded(
            child: UpcomingActivations(c: widget.c), 
          ),
          ],
        )
      ),
    );
  }
}
