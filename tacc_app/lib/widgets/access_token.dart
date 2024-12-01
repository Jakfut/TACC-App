import 'package:flutter/material.dart';

class AccessToken extends StatefulWidget {
  const AccessToken({super.key});

  @override
  State<StatefulWidget> createState() => _AccessTokenState();
}

class _AccessTokenState extends State<AccessToken> {
  String accessToken = "";

  @override
  Widget build(BuildContext context) {
    return TextField(
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Color(0xFFFBFCFE)),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.secondary),
            borderRadius: BorderRadius.circular(15.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF8EBBFF)),
            borderRadius: BorderRadius.circular(15.0),
          ),
          hintStyle: const TextStyle(
            color: Color(0xFF2F3855),
            fontSize: 16,
            fontFamily: 'Inter',
          ),
          hintText: "Access Token",
        ));
  }
}
