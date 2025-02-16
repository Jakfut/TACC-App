import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:openid_client/openid_client_io.dart';  

class SaveButton extends StatefulWidget {
  final ValueNotifier vinNotifier;
  final ValueNotifier accessTokenNotifier;
  final Credential c;
  const SaveButton(this.vinNotifier, this.accessTokenNotifier, this.c, {super.key,});
  @override
  State<StatefulWidget> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {

  Future<void> updateUserInfo() async {
    //print(widget.vinNotifier.value);
    //print(widget.accessTokenNotifier.value);
    var userInfo = await widget.c.getUserInfo();
    String userId = userInfo.subject;
    var authToken = await widget.c.getTokenResponse();
    Map<String, dynamic> data = {
      'vin': widget.vinNotifier.value,
      'accessToken': widget.accessTokenNotifier.value,
    };

    final Uri apiUrl = Uri.parse('https://tacc.jakfut.at/api/user/$userId/tesla-connections/tessie');

    try {
      final response = await http.patch(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authToken.accessToken}', 
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
    var userInfo = await widget.c.getUserInfo();
    String userId = userInfo.subject;
    var authToken = await widget.c.getTokenResponse();
    final Uri apiUrl = Uri.parse('https://tacc.jakfut.at/api/user/$userId/tesla-connections/tessie/activate');

    try {
      final response = await http.patch(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authToken.accessToken}', 
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
