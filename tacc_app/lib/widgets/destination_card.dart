import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DestinationCard extends StatefulWidget {
  final ValueNotifier timeValueNotifier;
  final ValueNotifier validNotifier;
  const DestinationCard(this.timeValueNotifier, this.validNotifier, {super.key,});

  @override
  State<StatefulWidget> createState() => _DestinationCardState();
}

class _DestinationCardState extends State<DestinationCard> {
  bool isValidInput = true;
  bool isFocused = false;

  void changeState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.timeValueNotifier,
      builder: (context, timeValue, _) {
        return Card(
          elevation: 5,
          color: Theme.of(context).colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
              vertical: MediaQuery.of(context).size.width * 0.05,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Text(
                      "No destination:",
                      style: TextStyle(
                        color: Color(0xFFFBFCFE),
                        fontSize: 16,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                  width: 100,
                  child: FocusScope(
                    child: Focus(
                      onFocusChange: (focus) {
                        setState(() {
                          isFocused = focus;
                        });
                      },
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: const TextStyle(color: Color(0xFFFBFCFE)),
                        decoration: InputDecoration(
                          suffixText: "min",
                          suffixStyle: const TextStyle(color: Color(0xFFFBFCFE)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: isValidInput ? Theme.of(context).colorScheme.primary : Colors.red),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: isValidInput ? Color(0xFF8EBBFF) : Colors.red),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          hintStyle: const TextStyle(color: Color(0xFFFBFCFE)),
                          hintText: isFocused ? null : "$timeValue min",
                        ),
                        onChanged: (newValue) {
                          final int? nValue = int.tryParse(newValue);
                          setState(() {
                            if (nValue != null && nValue >= 0 && nValue <= 90) {
                              isValidInput = true;
                              widget.validNotifier.value = true;
                              widget.timeValueNotifier.value = nValue;
                            } else {
                              widget.validNotifier.value = false;
                              isValidInput = false;
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
