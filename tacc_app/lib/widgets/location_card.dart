import 'package:flutter/material.dart';
import 'package:openid_client/openid_client_io.dart';
import 'package:tacc_app/widgets/location_text.dart';

class LocationCard extends StatelessWidget {
  final Credential c;
  const LocationCard({
    super.key,
    required this.c
  });

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
          children: [
            Icon(Icons.location_on_outlined,
             color: Color(0xFF8EBBFF),
             size: 40
            ),
            SizedBox(width: 10,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LocationText(c: c),
                ],
              )
            ),
          ],
        )
      ), 
    );
  }
}
