import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:openid_client/openid_client_io.dart';  

class SaveNewButton extends StatefulWidget {
  final ValueNotifier keywordStartNotifier;
  final ValueNotifier keywordEndNotifier;
  final Credential c;
  const SaveNewButton(this.keywordStartNotifier, this.keywordEndNotifier, this.c, {super.key,});
  @override
  State<StatefulWidget> createState() => _SaveNewButtonState();
}

class _SaveNewButtonState extends State<SaveNewButton> {

  Future<void> updateCalendarInfo() async {
    final String keywordStart = widget.keywordStartNotifier.value;
    final String keywordEnd = widget.keywordEndNotifier.value;

    var userInfo = await widget.c.getUserInfo();
    String userId = userInfo.subject;
    var authToken = await widget.c.getTokenResponse();
    Map<String, dynamic> data = {
      'keywordStart': keywordStart,
      'keywordEnd': keywordEnd,
    };

    final Uri apiUrl = Uri.parse('https://tacc.jakfut.at/api/user/$userId/calendar-connections/google-calendar'); // Update the API endpoint if needed

    try {
      final response = await http.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authToken.accessToken}', 
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        // Successfully sent the data
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data saved successfully!')),
        );
      } else {
        // If the server returns an error response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save data. Status code: ${response.statusCode}')),
        );
      }
    } catch (e) {
      // Handle network or other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, 
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8EBBFF),
        ),
        onPressed: () {
          updateCalendarInfo();
        },
        child: const Text(
          "Save New",
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
