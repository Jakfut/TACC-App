import 'package:flutter/material.dart';
import 'package:tacc_app/widgets/climate_card.dart';
import 'package:tacc_app/widgets/location_card.dart';
import 'package:tacc_app/widgets/tesla_status.dart';
import 'package:tacc_app/widgets/upcoming_activations.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

Future<void> fetchUserInfo(String userId) async {
  final response = await http.get(Uri.parse(
      'http://10.0.2.2:8080/api/user/${userId}'));

  if (response.statusCode == 404) {
    await http.post(Uri.parse('http://10.0.2.2:8080/api/user/${userId}'));
    return fetchUserInfo(userId);
  }
}

class _MainPageState extends State<MainPage> {
  final String userId = "8a61a7d6-52d1-4dd7-9c60-1f5e08edc28b";
  @override
  void initState() {
    super.initState();
    fetchUserInfo(userId);
  }
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
            Expanded(
            child: UpcomingActivations(), 
          ),
          ],
        )
      ),
    );
  }
}
