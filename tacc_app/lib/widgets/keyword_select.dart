import 'package:flutter/material.dart';

class KeywordSelect extends StatefulWidget {
  const KeywordSelect({super.key});

  @override
  State<StatefulWidget> createState() => _KeywordSelectState();
}

class _KeywordSelectState extends State<KeywordSelect> {
  String keyword = "";

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
          hintText: "#Keyword",
        ));
  }
}
