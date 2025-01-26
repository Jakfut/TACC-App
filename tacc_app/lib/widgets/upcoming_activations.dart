import 'package:flutter/material.dart';
import 'package:tacc_app/widgets/location_text.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class UpcomingActivations extends StatefulWidget{
  const UpcomingActivations({super.key});

  @override
  State<StatefulWidget> createState() => _UpcomingActivationsState();
}

Future<List<Activation>> fetchActivations(String userId) async {
  /*final response = await http.get(Uri.parse(
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
  }*/
  // Simuliere eine Verzögerung wie bei einem echten Netzwerkaufruf
  await Future.delayed(const Duration(seconds: 2));

  // Mock-Daten erstellen
  return [
    Activation(
      climateActivationTime: "2025-01-26T08:00:00.0000000+01:00",  // Beispielzeit für Klimaaktivierung
      departureTime: "2025-01-26T08:30:00.0000000+01:00",        // Beispielzeit für Abfahrt
      arrivalTime: "2025-01-26T09:00:00.0000000+01:00",          // Beispielzeit für Ankunft
      eventStartTime: "2025-01-26T09:30:00.0000000+01:00",       // Beispielzeit für Eventbeginn
      eventLocation: "Office",                                    // Beispielort
      travelTimeMinutes: 30,                                      // Beispielreisezeit in Minuten
    ),
    Activation(
      climateActivationTime: "2025-01-26T10:00:00.0000000+01:00",
      departureTime: "2025-01-26T10:15:00.0000000+01:00",
      arrivalTime: "2025-01-26T10:45:00.0000000+01:00",
      eventStartTime: "2025-01-26T11:00:00.0000000+01:00",
      eventLocation: "Gym",
      travelTimeMinutes: 15,
    ),
    Activation(
      climateActivationTime: "2025-01-26T12:00:00.0000000+01:00",
      departureTime: "2025-01-26T12:15:00.0000000+01:00",
      arrivalTime: "2025-01-26T12:45:00.0000000+01:00",
      eventStartTime: "2025-01-26T13:00:00.0000000+01:00",
      eventLocation: "Park",
      travelTimeMinutes: 20,
    ),
  ];
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
       climateActivationTime: json['climateActivationTime'] as String? ?? 'N/A',
    departureTime: json['departureTime'] as String? ?? 'N/A',
    arrivalTime: json['arrivalTime'] as String? ?? 'N/A',
    eventStartTime: json['eventStartTime'] as String? ?? 'N/A',
    eventLocation: json['eventLocation'] as String? ?? 'Unknown Location',
    travelTimeMinutes: json['travelTimeMinutes'] as int? ?? 0,
      );
    }
  }

  String formatTime(String timeString) {
  try {
    final dateTime = DateTime.parse(timeString); 
    
    final dateFormat = DateFormat("HH:mm");
    return dateFormat.format(dateTime); 
  } catch (e) {
    return timeString;
  }
}

  int calculateTimeDifferenceInMinutes(String time1, String time2) {
  try {
    final DateTime time1Parsed = DateTime.parse(time1);
    final DateTime time2Parsed = DateTime.parse(time2);

    final difference = time2Parsed.difference(time1Parsed);

    return difference.inMinutes.abs();
  } catch (e) {
    return 0;
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

  final Set<int> expandedIndexes = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
    child: FutureBuilder<List<Activation>>(
              future: activations,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final activations = snapshot.data!;
                  return ListView.separated(
                    separatorBuilder: (context, index) => const Divider(
                      color: Color(0xFF2F3855),
                      thickness: 2.0, 
                    ),
                    itemCount: activations.length,
                    itemBuilder: (context, index) {
                      final isExpanded = expandedIndexes.contains(index);
                      final activation = activations[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (isExpanded) {
                                    expandedIndexes.remove(index);
                                  } else {
                                    expandedIndexes.add(index);
                                  }
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                      size: 24.0,
                                      color: const Color(0xFF8EBBFF), 
                                    ),
                                    const SizedBox(width: 8.0),
                                    Icon(Icons.mode_fan_off, color: Color(0xFF8EBBFF), size: 24.0 * 1.5,),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      '${formatTime(activation.climateActivationTime)}',
                                      style: const TextStyle(color: Color(0xFFFBFCFE), fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      ' -- ${calculateTimeDifferenceInMinutes(activation.climateActivationTime, activation.departureTime)} min --',
                                      style: const TextStyle(color: Color(0xFF2F3855), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Icon(Icons.car_rental, color: Color(0xFF8EBBFF), size: 24.0 * 1.5,),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      '${formatTime(activation.departureTime)}',
                                      style: const TextStyle(color: Color(0xFFFBFCFE), fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (isExpanded)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                                child: Column(
                                  children: [
                                  Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.outlined_flag, color: Theme.of(context).colorScheme.primary, size: 24.0 * 1.5,),
                                    
                                    Icon(Icons.more_vert, color: Color(0xFF8EBBFF), size: 24.0 * 1.5,),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      '${activation.travelTimeMinutes} min',
                                      style: const TextStyle(color: Color(0xFF2F3855), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4.0),
                                  Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.outlined_flag, color: Theme.of(context).colorScheme.primary, size: 24.0 * 1.5,),
                                    Icon(Icons.outlined_flag, color: Color(0xFF8EBBFF), size: 24.0 * 1.5,),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      '${formatTime(activation.arrivalTime)}',
                                      style: const TextStyle(color: Color(0xFFFBFCFE), fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      ' -- ${calculateTimeDifferenceInMinutes(activation.arrivalTime, activation.eventStartTime)} min --',
                                      style: const TextStyle(color: Color(0xFF2F3855), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Icon(Icons.access_time, color: Color(0xFF8EBBFF), size: 24.0 * 1.5,),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      '${formatTime(activation.eventStartTime)}',
                                      style: const TextStyle(color: Color(0xFFFBFCFE), fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                    ),
                                    
                                    
                                    /*Text('Event Location: ${activation.eventLocation}'),
                                    Text('Arrival Time: ${activation.arrivalTime}'),
                                    Text('Event Start Time: ${activation.eventStartTime}'),
                                    Text('Travel Time: ${activation.travelTimeMinutes} minutes'),*/
                                  ],
                                ),
                                const SizedBox(height: 4.0),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.outlined_flag, color: Theme.of(context).colorScheme.primary, size: 24.0 * 1.5,),
                                    Text(
                                      '${formatTime(activation.eventLocation)}',
                                      style: const TextStyle(color: Color(0xFFFBFCFE), fontSize: 15, fontFamily: 'Inter'),
                                    ),
                                  ],
                                ),
                                  ]
                                )
                                
                              ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No activations available'));
                }
                } else {
                  return const Center(child: Text('No data available'));
                }
              }),
  );
  }
}
