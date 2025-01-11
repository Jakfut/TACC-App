import 'package:flutter/material.dart';
import 'package:tacc_app/widgets/location_text.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UpcomingActivations extends StatefulWidget{
  const UpcomingActivations({super.key});

  @override
  State<StatefulWidget> createState() => _UpcomingActivationsState();
}

Future<List<Activation>> fetchActivations(String userId) async {
  final response = await http.get(Uri.parse(
      'http://10.0.2.2:8080/api/user/${userId}/tesla/climate/upcoming-activations'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Activation.fromJson(json)).toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load user info');
  }
}

class Activation {
  final String climateActivationTime;
  final String departureTime;
  final String arrivalTime;
  final String eventStartTime;
  final String eventLocation;
  final int travelTimeMinutes;

  const Activation({
    required this.climateActivationTime,
    required this.departureTime,
    required this.arrivalTime,
    required this.eventStartTime,
    required this.eventLocation,
    required this.travelTimeMinutes,
  });

  factory Activation.fromJson(Map<String, dynamic> json) {
      return Activation(
      climateActivationTime: json['climateActivationTime'] as String,
      departureTime: json['departureTime'] as String,
      arrivalTime: json['arrivalTime'] as String,
      eventStartTime: json['ccRuntimeMinutes'] as String,
      eventLocation: json['eventLocation'] as String,
      travelTimeMinutes: json['travelTimeMinutes'] as int,
      );
    }
  }

class _UpcomingActivationsState extends State<UpcomingActivations>{
  late Future<List<Activation>> activations;
  final String userId = "8a61a7d6-52d1-4dd7-9c60-1f5e08edc28b";

  @override
  void initState() {
    super.initState();
    activations = fetchActivations(userId);
  }

  void changeState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Activations'),
      ),
      body: FutureBuilder<List<Activation>>(
        future: activations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No upcoming activations found.'));
          }

          final activationsList = snapshot.data!;

          return ListView.builder(
            itemCount: activationsList.length,
            itemBuilder: (context, index) {
              final activation = activationsList[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Theme.of(context).colorScheme.primary,
                        size: 30,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activation.eventLocation,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Climate Activation: ${activation.climateActivationTime}",
                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                            ),
                            Text(
                              "Departure: ${activation.departureTime}",
                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                            ),
                            Text(
                              "Arrival: ${activation.arrivalTime}",
                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
  
}
