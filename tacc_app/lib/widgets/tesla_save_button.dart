import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;  

class SaveButton extends StatefulWidget {
  final ValueNotifier vinNotifier;
  final ValueNotifier accessTokenNotifier;
  final String userId;
  const SaveButton(this.vinNotifier, this.accessTokenNotifier, this.userId, {super.key,});
  @override
  State<StatefulWidget> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {

  Future<void> updateUserInfo() async {
    Map<String, dynamic> data = {
      'vin': widget.vinNotifier.value,
      'accessToken': widget.accessTokenNotifier.value,
    };

    final Uri apiUrl = Uri.parse('http://10.0.2.2:8080/api/user/${widget.userId}/tesla-connections/tessie');

    try {
      final response = await http.patch(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data saved successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save data. Status code: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> activateConnection() async {
    final Uri apiUrl = Uri.parse('http://10.0.2.2:8080/api/user/${widget.userId}/tesla-connections/tessie/activate');

    try {
      final response = await http.patch(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        /*ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data saved successfully!')),
        );*/
      } else {
        /*ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save data. Status code: ${response.statusCode}')),
        );*/
      }
    } catch (e) {
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
          updateUserInfo();
          activateConnection();
        },
        child: const Text(
          "Save",
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
