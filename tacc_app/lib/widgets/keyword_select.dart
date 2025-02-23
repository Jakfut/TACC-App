import 'package:flutter/material.dart';

class KeywordSelect extends StatefulWidget {
  final ValueNotifier keywordNotifier;
  const KeywordSelect(this.keywordNotifier, {super.key});

  @override
  State<StatefulWidget> createState() => _KeywordSelectState();
}

bool _validateInput(String input) {
  // Überprüft die Eingabe mit dem Regex
  final regex = RegExp(r'[a-zA-Z0-9]{3,8}$');
  return regex.hasMatch(input);
}

class _KeywordSelectState extends State<KeywordSelect> {
  bool isValidInput = true;
  bool isFocused = false;

  void changeState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.keywordNotifier,
      builder: (context, keyword, _) {
        return TextField(
            keyboardType: TextInputType.text,
            style: const TextStyle(color: Color(0xFFFBFCFE)),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: isValidInput ? Theme.of(context).colorScheme.secondary : Colors.red ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: isValidInput ? Color(0xFF8EBBFF) : Colors.red ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              hintStyle: const TextStyle(
                color: Color(0xFF2F3855),
                fontSize: 16,
                fontFamily: 'Inter',
              ),
              hintText: "Keyword Start",
            ),
            onChanged: (newValue) {
              setState(() {
                isValidInput = _validateInput(newValue);
                if (isValidInput) {
                  widget.keywordNotifier.value = newValue;
                }
              });
            });
      },
    );
  }
}
