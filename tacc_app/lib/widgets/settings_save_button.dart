import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;  

class SaveButton extends StatefulWidget {
  final ValueNotifier destTimeNotifier;
  final ValueNotifier runTimeNotifier;
  final ValueNotifier bufferTimeNotifier;
  final String userId;
  const SaveButton(this.destTimeNotifier, this.runTimeNotifier, this.bufferTimeNotifier, this.userId, {super.key,});
  @override
  State<StatefulWidget> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {

  Future<void> updateUserInfo() async {
    Map<String, dynamic> data = {
      'arrivalBufferMinutes': widget.bufferTimeNotifier.value,
      'ccRuntimeMinutes': widget.runTimeNotifier.value,
      'noDestMinutes': widget.destTimeNotifier.value,
    };

    final Uri apiUrl = Uri.parse('http://10.0.2.2:8080/api/user/${widget.userId}/default-values'); // Update the API endpoint if needed

    try {
      final response = await http.patch(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
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
          updateUserInfo();
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
