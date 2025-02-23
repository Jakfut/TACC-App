import 'package:flutter/material.dart';
import 'package:openid_client/openid_client_io.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class UpcomingActivations extends StatefulWidget {
  final Credential c;

  const UpcomingActivations({super.key, required this.c});

  @override
  State<UpcomingActivations> createState() => _UpcomingActivationsState();
}

Future<List<Activation>> fetchActivations(Credential c) async {
  var userInfo = await c.getUserInfo();
  String userId = userInfo.subject;
  var authToken = await c.getTokenResponse();
  final response = await http.get(
    Uri.parse('https://tacc.jakfut.at/api/user/$userId/scheduled-entries'),
    headers: {
      'Authorization': 'Bearer ${authToken.accessToken}',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Activation.fromJson(json)).toList();
  } else {
    return [];
  }
}

class Activation {
  final String nextTrigger;
  final String? eventTime;
  final String tarLocation;
  final bool isActivateAc;
  final bool isCheckAgain;

  const Activation({
    required this.nextTrigger,
    this.eventTime,
    required this.tarLocation,
    required this.isActivateAc,
    required this.isCheckAgain,
  });

  factory Activation.fromJson(Map<String, dynamic> json) {
    return Activation(
      nextTrigger: json['nextTrigger'] as String? ?? 'N/A',
      eventTime: json['eventTime'] as String?,
      tarLocation: json['tarLocation'] as String? ?? 'N/A',
      isActivateAc: json['isActivateAc'] as bool? ?? false,
      isCheckAgain: json['isCheckAgain'] as bool? ?? false,
    );
  }
}

// Function to format time with timezone
String formatTimeWithTimezone(String? timeString, String timeZoneName) {
  if (timeString == null) {
    return 'N/A';
  }
  try {
    final dateTime = DateTime.parse(timeString);
    final location = tz.getLocation(timeZoneName);
    final zonedTime = tz.TZDateTime.from(dateTime, location);
    final dateFormat = DateFormat("HH:mm");
    return dateFormat.format(zonedTime);
  } catch (e) {
    return timeString;
  }
}

// Function to format date with timezone
String formatDateWithTimezone(String? timeString, String timeZoneName) {
  if (timeString == null) {
    return 'N/A';
  }
  try {
    final dateTime = DateTime.parse(timeString);
    final location = tz.getLocation(timeZoneName);
    final zonedTime = tz.TZDateTime.from(dateTime, location);
    final dateFormat = DateFormat("yyyy-MM-dd");
    return dateFormat.format(zonedTime);
  } catch (e) {
    return timeString;
  }
}

// Function to get User's timezone.  A default timezone is used if retrieval fails.
Future<String> getUserTimezone(Credential c) async {
  try {
    var userInfo = await c.getUserInfo();
    // Access claims directly as if userInfo were a map.
    if (userInfo['zoneinfo'] != null) {
      return userInfo['zoneinfo'] as String;
    }
  } catch (e) {
    print("Error getting user timezone: $e");
  }
  return 'Europe/Vienna'; // Default timezone
}

class _UpcomingActivationsState extends State<UpcomingActivations> {
  late Future<List<Activation>> activations;
  late Future<String> userTimezone;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones(); // Initialize timezone data
    activations = fetchActivations(widget.c);
    userTimezone = getUserTimezone(widget.c);
  }

  final Set<int> expandedIndexes = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<Activation>>(
        future: activations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final activationsList = snapshot.data!;
            return SingleChildScrollView(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => const Divider(
                  color: Color(0xFF2F3855),
                  thickness: 2.0,
                ),
                itemCount: activationsList.length,
                itemBuilder: (context, index) {
                  final isExpanded = expandedIndexes.contains(index);
                  final activation = activationsList[index];
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
                                  activation.isActivateAc
                                      ? Icons.ac_unit
                                      : Icons.refresh,
                                  color: const Color(0xFF8EBBFF),
                                  size: 36.0,
                                ),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: FutureBuilder<String>(
                                    future: userTimezone,
                                    builder: (context, timezoneSnapshot) {
                                      final timezone =
                                          timezoneSnapshot.data ?? 'Europe/Vienna';
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${formatTimeWithTimezone(activation.nextTrigger, timezone)} (${formatDateWithTimezone(activation.nextTrigger, timezone)})',
                                            style: const TextStyle(
                                              color: Color(0xFFFBFCFE),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Inter',
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          if (activation.eventTime != null) ...[
                                            const SizedBox(height: 4.0),
                                            Text(
                                              'Event: ${formatTimeWithTimezone(activation.eventTime, timezone)} (${formatDateWithTimezone(activation.eventTime, timezone)})',
                                              style: TextStyle(
                                                color: Colors.grey[300],
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ]
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (isExpanded) ...[
                          const Divider(color: Color(0xFF2F3855), thickness: 1.0),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Location: ${activation.tarLocation.isNotEmpty ? activation.tarLocation : "No Location Set"}',
                                  style: const TextStyle(
                                      color: Color(0xFFFBFCFE),
                                      fontSize: 14,
                                      fontFamily: 'Inter'),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'Type: ${activation.isActivateAc ? "Activate AC" : "Check Again"}',
                                  style: const TextStyle(
                                      color: Color(0xFFFBFCFE),
                                      fontSize: 14,
                                      fontFamily: 'Inter'),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ]
                      ],
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(child: Text('No upcoming activations'));
          }
        },
      ),
    );
  }
}