import 'package:flutter/material.dart';

class ListCard extends StatefulWidget {
  const ListCard({super.key,});

  @override
  State<StatefulWidget> createState() => _ListCardState();
}

class ListItem{
  var ctime = "00:00";
  var dtime = "00:10";
  var atime = "01:00";
  var location = "Example Street 2, 12345 Example City,  Austria";
}

class LTile extends StatelessWidget{
  const LTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const ExpansionTile(title: Text("data"), 
    children: [
      ListTile(
        leading: Icon(Icons.map),
        title: Text('Map'),
      )
    ],
    );
  }
}

class _ListCardState extends State<ListCard>{
  var date = "Mo. - 00.00.0000";
  var items = List<ListItem>.filled(3,ListItem());

  /*void changeState(){
    setState(() {
      if(cstatus == 1){
        cstatus = 2;
      }else if(cstatus ==2 ){
        cstatus = 1;
      }
    });
  }*/

  @override
  Widget build(BuildContext context) {

    /*List<Widget> listArray = [];
    for(var i = 0; i < items.length; i++){
      listArray.add(LTile());
    }*/

    return Column(
      children: [
        Card(
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
                    /*const Icon(
                      Icons.mode_fan_off,
                      color: Color(0xFF8EBBFF),
                      size: 40,
                    ),*/
                    const SizedBox(width: 10),
                    Text(
                      date,
                      style: const TextStyle(color: Color(0xFFFBFCFE), fontSize: 16, fontFamily: 'Inter'),
                    ),
                  ],
                ),
                /*ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8EBBFF)
                  ),
                  onPressed: changeState,
                  child: Text(bText,
                  style: const TextStyle(fontSize: 16, fontFamily: 'Inter', fontWeight: FontWeight.bold),),
                ),*/
              ],
            ),
          )
        ),
        /*ListView(
          children: listArray,
        )*/
      ]
    );
  }
}

