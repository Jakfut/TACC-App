import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:openid_client/openid_client_io.dart';

class ClimateCard extends StatefulWidget {
  final Credential c;
  const ClimateCard({super.key, required this.c});

  @override
  State<StatefulWidget> createState() => _ClimateCardState();
}

class _ClimateCardState extends State<ClimateCard>{
  var cstatusText = "Loading ...";
  var cstatusColor = Color(0xFFD4A45A);
  var bText = "...";
  var _isLoading = false;

  var climate = false;

  @override
  void initState() {
    super.initState();
    fetchInfo();
  }

  Future<void> fetchInfo() async {
    bool requestCompleted = false;
    Future.delayed(Duration(seconds: 10), () {
      if (!requestCompleted && mounted) {
        setState(() {
          cstatusText = "No connection";
          cstatusColor = const Color(0xFFD55A5A);
          bText = "...";
        });
      }
    });
    var userInfo = await widget.c.getUserInfo();
    String userId = userInfo.subject;
    var authToken = await widget.c.getTokenResponse();
    final response = await http.get(Uri.parse(
        'https://tacc.jakfut.at/api/user/$userId/tesla/climate/state'),
        headers: {
        'Authorization': 'Bearer ${authToken.accessToken}', 
      }
      );

    if (!mounted) return;

    if (response.statusCode == 200) {
      setState(() {
        climate = jsonDecode(response.body) as bool;
        if(climate){
          cstatusText = "Active";
          cstatusColor = const Color(0xFF66B58C);
          bText = "Turn off";
        }else{
          cstatusText = "Inactive";
          cstatusColor = const Color(0xFFD55A5A);
          bText = "Turn on";
        }
      });
    }else {
      //throw Exception('Failed to load tesla availability');
      cstatusText = "Inactive";
      cstatusColor = const Color(0xFFD55A5A);
      bText = "Turn on";
    }
    requestCompleted = true;
  }

  Future<void> changeState() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    var userInfo = await widget.c.getUserInfo();
    String userId = userInfo.subject;
    var authToken = await widget.c.getTokenResponse();

    bool newState = !climate;

    final Uri apiUrl = Uri.parse(
        'https://tacc.jakfut.at/api/user/$userId/tesla/climate/state');

    try {
      final response = await http.patch(
        apiUrl,
        headers: {
          'Content-Type': 'application/json', // Correct Content-Type
          'Authorization': 'Bearer ${authToken.accessToken}',
        },
        body: jsonEncode(newState), // Correctly JSON-encode the boolean
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          climate = newState;
          cstatusText = climate ? "Active" : "Inactive";
          cstatusColor =
              climate ? const Color(0xFF66B58C) : const Color(0xFFD55A5A);
          bText = climate ? "Turn off" : "Turn on";
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Climate control updated!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to update climate control. Status code: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error changing climate state: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05, vertical: MediaQuery.of(context).size.width * 0.05),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, 
          children: [
            Row(
              children: [
                const Icon(
                  Icons.mode_fan_off,
                  color: Color(0xFF8EBBFF),
                  size: 40,
                ),
                const SizedBox(width: 10),
                Text(
                  cstatusText,
                  style: TextStyle(color: cstatusColor, fontSize: 16, fontFamily: 'Inter'),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8EBBFF)),
              onPressed: _isLoading ? null : changeState, // Disable when loading
              child: _isLoading
                ? CircularProgressIndicator(color: Colors.white)
                : Text(
                    bText,
                    style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold),
                  ),
            ),
          ],
        ),
      )
    );
  }
}

