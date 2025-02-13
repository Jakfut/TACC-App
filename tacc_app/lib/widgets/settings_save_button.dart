import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:openid_client/openid_client_io.dart';  

class SaveButton extends StatefulWidget {
  final ValueNotifier destTimeNotifier;
  final ValueNotifier runTimeNotifier;
  final ValueNotifier bufferTimeNotifier;
  final ValueNotifier destValidNotifier;
  final ValueNotifier runValidNotifier;
  final ValueNotifier arrivalValidNotifier;
  final Credential c;
  const SaveButton(this.destTimeNotifier, this.runTimeNotifier, this.bufferTimeNotifier, this.destValidNotifier, this.runValidNotifier, this.arrivalValidNotifier, this.c, {super.key,});
  @override
  State<StatefulWidget> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  late ValueNotifier<bool> isFormValidNotifier;

  @override
  void initState() {
    super.initState();
    isFormValidNotifier = ValueNotifier<bool>(
      widget.destValidNotifier.value &&
          widget.runValidNotifier.value &&
          widget.arrivalValidNotifier.value,
    );

    widget.destValidNotifier.addListener(updateFormValidity);
    widget.runValidNotifier.addListener(updateFormValidity);
    widget.arrivalValidNotifier.addListener(updateFormValidity);
  }

  void updateFormValidity() {
    isFormValidNotifier.value = widget.destValidNotifier.value &&
        widget.runValidNotifier.value &&
        widget.arrivalValidNotifier.value;
  }

  @override
  void dispose() {
    widget.destValidNotifier.removeListener(updateFormValidity);
    widget.runValidNotifier.removeListener(updateFormValidity);
    widget.arrivalValidNotifier.removeListener(updateFormValidity);
    isFormValidNotifier.dispose();
    super.dispose();
  }

  Future<void> updateUserInfo() async {
    Map<String, dynamic> data = {
      'arrivalBufferMinutes': widget.bufferTimeNotifier.value,
      'ccRuntimeMinutes': widget.runTimeNotifier.value,
      'noDestMinutes': widget.destTimeNotifier.value,
    };
    var userInfo = await widget.c.getUserInfo();
    String userId = userInfo.subject;
    var authToken = await widget.c.getTokenResponse();
    final Uri apiUrl = Uri.parse('https://tacc.jakfut.at/api/user/${userId}/default-values');

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

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isFormValidNotifier,
      builder: (context, isFormValid, child) {
    return SizedBox(
      width: double.infinity, 
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isFormValid
                  ? const Color(0xFF8EBBFF)
                  : const Color(0x508EBBFF)
        ),
        onPressed: () {
          if(isFormValid){
            updateUserInfo();
          }
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
    );
  }
}
