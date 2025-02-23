import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:openid_client/openid_client_io.dart';
import 'package:flutter/services.dart';

class DeleteAccountButton extends StatefulWidget {
  final Credential c; 

  const DeleteAccountButton({super.key, required this.c});

  @override
  State<DeleteAccountButton> createState() => DeleteAccountButtonState();
}

class DeleteAccountButtonState extends State<DeleteAccountButton> {
  Future<void> _deleteAccount() async {
    var userInfo = await widget.c.getUserInfo();
    String userId = userInfo.subject;
    var authToken = await widget.c.getTokenResponse();

    final Uri apiUrl =
        Uri.parse('https://tacc.jakfut.at/api/user/$userId');

    try {
      final response = await http.delete(
        apiUrl,
        headers: {
          'Authorization': 'Bearer ${authToken.accessToken}',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account deleted successfully!')),
        );
        // Close the app:
        SystemNavigator.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to delete account. Status code: ${response.statusCode}')),
        );
      }
    } catch (e) {
      // Handle network errors
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
          backgroundColor: Theme.of(context).primaryColor, //Consider using a more 'destructive' color, like red
          side: const BorderSide(
            color: Color(0xFF8EBBFF),
          ),
        ),
        onPressed: () {
          // Show a confirmation dialog before deleting
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Confirm Deletion'),
                content: const Text(
                    'Are you sure you want to delete your account?  This action cannot be undone.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                  TextButton(
                    child: const Text('Delete', style: TextStyle(color: Colors.red)), //Use a destructive color
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      _deleteAccount(); // Call the delete function
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Text(
          "Delete Account",
          style: TextStyle(
            color: Color(0xFF8EBBFF),
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}