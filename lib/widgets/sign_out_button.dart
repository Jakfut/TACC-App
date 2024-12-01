import 'package:flutter/material.dart';

class SignOutButton extends StatefulWidget {
  const SignOutButton({super.key});

  @override
  State<StatefulWidget> createState() => _SignOutButtonState();
}

class _SignOutButtonState extends State<SignOutButton> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, 
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          side: const BorderSide( 
            color: Color(0xFF8EBBFF), 
          ),
        ),
        onPressed: () {

        },
        child: const Text(
          "Sign Out",
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
