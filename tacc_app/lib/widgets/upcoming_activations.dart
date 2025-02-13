import 'package:flutter/material.dart';
import 'package:openid_client/openid_client_io.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class UpcomingActivations extends StatefulWidget {
  final Credential c;
  const UpcomingActivations({super.key, required this.c});

  @override
  State<StatefulWidget> createState() => _UpcomingActivationsState();
}

Future<List<Activation>> fetchActivations(Credential c) async {
  var userInfo = await c.getUserInfo();
  String userId = userInfo.subject;
  var authToken = await c.getTokenResponse();
  final response = await http.get(
      Uri.parse('https://tacc.jakfut.at/api/user/$userId/scheduled-entries'),
      headers: {
        'Authorization': 'Bearer ${authToken.accessToken}',
      });

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Activation.fromJson(json)).toList();
  } else {
    throw Exception(response.statusCode);
  }
}

class Activation {
  final String nextTrigger;
  final String eventTime;
  final String tarLocation;
  final bool isActivateAc;
  final bool isCheckAgain;

  const Activation({
    required this.nextTrigger,
    required this.eventTime,
    required this.tarLocation,
    required this.isActivateAc,
    required this.isCheckAgain,
  });

  factory Activation.fromJson(Map<String, dynamic> json) {
    return Activation(
      nextTrigger: json['nextTrigger'] as String? ?? 'N/A',
      eventTime: json['eventTime'] as String? ?? 'N/A',
      tarLocation: json['tarLocation'] as String? ?? 'N/A',
      isActivateAc: json['isActivateAc'] as bool? ?? false,
      isCheckAgain: json['isCheckAgain'] as bool? ?? false,
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

class _UpcomingActivationsState extends State<UpcomingActivations> {
  late Future<List<Activation>> activations;

  @override
  void initState() {
    super.initState();
    activations = fetchActivations(widget.c);
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
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
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
                                    isExpanded
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    size: 24.0,
                                    color: const Color(0xFF8EBBFF),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Icon(
                                    Icons.mode_fan_off,
                                    color: Color(0xFF8EBBFF),
                                    size: 24.0 * 1.5,
                                  ),
                                  const SizedBox(width: 8.0),
                                  Text(
                                    '${formatTime(activation.nextTrigger)}',
                                    style: const TextStyle(
                                        color: Color(0xFFFBFCFE),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Inter'),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Text(
                                    ' -- ${calculateTimeDifferenceInMinutes(activation.nextTrigger, activation.eventTime)} min --',
                                    style: const TextStyle(
                                        color: Color(0xFF2F3855),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Inter'),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Icon(
                                    Icons.access_time,
                                    color: Color(0xFF8EBBFF),
                                    size: 24.0 * 1.5,
                                  ),
                                  const SizedBox(width: 8.0),
                                  Text(
                                    '${formatTime(activation.eventTime)}',
                                    style: const TextStyle(
                                        color: Color(0xFFFBFCFE),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Inter'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (isExpanded)
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 0.0),
                                child: Column(children: [
                                  const SizedBox(height: 4.0),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.outlined_flag,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        size: 24.0 * 1.5,
                                      ),
                                      Icon(
                                        Icons.outlined_flag,
                                        color: Color(0xFF8EBBFF),
                                        size: 24.0 * 1.5,
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        '${formatTime(activation.tarLocation)}',
                                        style: const TextStyle(
                                            color: Color(0xFFFBFCFE),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Inter'),
                                      ),
                                      const SizedBox(width: 8.0),
                                      /*Icon(
                                        Icons.access_time,
                                        color: Color(0xFF8EBBFF),
                                        size: 24.0 * 1.5,
                                      ),
                                      const SizedBox(width: 8.0),*/
                                      Text(
                                        '${formatTime(activation.isActivateAc.toString())}',
                                        style: const TextStyle(
                                            color: Color(0xFFFBFCFE),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Inter'),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        '${formatTime(activation.isCheckAgain.toString())}',
                                        style: const TextStyle(
                                            color: Color(0xFFFBFCFE),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Inter'),
                                      ),

                                      /*Text('Event Location: ${activation.eventLocation}'),
                                    Text('Arrival Time: ${activation.arrivalTime}'),
                                    Text('Event Start Time: ${activation.eventStartTime}'),
                                    Text('Travel Time: ${activation.travelTimeMinutes} minutes'),*/
                                    ],
                                  ),
                                  /*const SizedBox(height: 4.0),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.outlined_flag,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        size: 24.0 * 1.5,
                                      ),
                                      Text(
                                        '${formatTime(activation.eventLocation)}',
                                        style: const TextStyle(
                                            color: Color(0xFFFBFCFE),
                                            fontSize: 15,
                                            fontFamily: 'Inter'),
                                      ),
                                    ],
                                  ),*/
                                ])),
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
