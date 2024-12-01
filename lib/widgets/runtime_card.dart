import 'package:flutter/material.dart';

class RuntimeCard extends StatefulWidget {
  final ValueNotifier timeValueNotifier;
  const RuntimeCard(this.timeValueNotifier, {super.key,});

  @override
  State<StatefulWidget> createState() => _RuntimeCardState();
}

class _RuntimeCardState extends State<RuntimeCard>{
  
  void changeState(){
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(valueListenable: widget.timeValueNotifier, builder: (context, timeValue, _){
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
              const Row(
                children: [
                  Text(
                    "CC runtime:",
                    style: TextStyle(color: Color(0xFFFBFCFE), fontSize: 16, fontFamily: 'Inter'),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
                width: 100,
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Color(0xFFFBFCFE)),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),borderRadius: BorderRadius.circular(15.0),),
                    focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF8EBBFF)),borderRadius: BorderRadius.circular(15.0),),
                    hintStyle: const TextStyle(color: Color(0xFFFBFCFE)),
                    hintText: "$timeValue min",
                  ),
                  onChanged: (newValue) {
                    final int? nValue = int.tryParse(newValue);
                    if (nValue != null) {
                      widget.timeValueNotifier.value = nValue;
                      changeState();
                    }
                  },
                ),
              )
            ],
          ),
        )
      );
    });
  }
}