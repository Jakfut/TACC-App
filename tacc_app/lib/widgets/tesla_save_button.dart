import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:openid_client/openid_client_io.dart';

enum SaveType { save, saveNew } // Add an enum

class SaveTeslaConnectionButton extends StatefulWidget {
  final ValueNotifier<String> vinNotifier;
  final ValueNotifier<String> accessTokenNotifier;
  final Credential c;
  final SaveType saveType; // Add a saveType parameter

  const SaveTeslaConnectionButton({
    super.key,
    required this.vinNotifier,
    required this.accessTokenNotifier,
    required this.c,
    required this.saveType, // Pass in the save type
  });

  @override
  State<SaveTeslaConnectionButton> createState() =>
      _SaveTeslaConnectionButtonState();
}

class _SaveTeslaConnectionButtonState extends State<SaveTeslaConnectionButton> {
  Future<void> _saveChanges() async {
    final String vin = widget.vinNotifier.value;
    final String accessToken = widget.accessTokenNotifier.value;

    if ((vin.isEmpty || accessToken.isEmpty) && widget.saveType == SaveType.saveNew) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both VIN and Access Token.')),
      );
      return;
    }

    var userInfo = await widget.c.getUserInfo();
    String userId = userInfo.subject;
    var authToken = await widget.c.getTokenResponse();
    Map<String, dynamic> data = {
      'vin': vin,
      'accessToken': accessToken,
    };

    // Determine the HTTP method and URL based on saveType
    Uri apiUrl;
    http.Client client = http.Client();
    Future<http.Response> Function({
    Map<String, String>? headers,
        Object? body,
        Encoding? encoding,
    }) apiCall;


    if (widget.saveType == SaveType.saveNew) {
      apiUrl = Uri.parse(
          'https://tacc.jakfut.at/api/user/$userId/tesla-connections/tessie');
      apiCall = ({headers, body, encoding}) => client.post(apiUrl, headers: headers, body: body, encoding: encoding);
    } else {
      apiUrl = Uri.parse(
          'https://tacc.jakfut.at/api/user/$userId/tesla-connections/tessie');
          apiCall = ({headers, body, encoding}) => client.patch(apiUrl, headers: headers, body: body, encoding: encoding);
    }


    try {
      final response = await apiCall(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authToken.accessToken}',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data saved successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to save data. Status code: ${response.statusCode}')),
        );
        return;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      return;
    }

    //Activation is the same
    final Uri activateApiUrl = Uri.parse('https://tacc.jakfut.at/api/user/$userId/tesla-connections/tessie/activate');
      try {
        final response = await http.patch(
          activateApiUrl,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${authToken.accessToken}',
          },
        );

        if (response.statusCode != 200) {
          // You probably *do* want to show an error here.  Activation failed.
                ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to activate. Status code: ${response.statusCode}')),
      );
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
        onPressed: _saveChanges,
        child: Text(
          widget.saveType == SaveType.saveNew ? "Save New" : "Update", // Change button text
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}