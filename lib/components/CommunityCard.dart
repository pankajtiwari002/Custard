import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'DashedBox.dart';

class CommunityCard extends StatelessWidget {
  List<Widget> widgets;
  
  CommunityCard({
    super.key,
    required this.widgets
  });


  @override
  Widget build(BuildContext context) {
    var reqWidgets = [
      const Image(image: NetworkImage("https://via.placeholder.com/290x110")),
      const Text(
        'Social Dance Tribe',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF061237),
          fontSize: 24,
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w700,
        ),
      ),
    ];
    widgets.forEach((element) {
      reqWidgets.add(element);
    });
    
    return Padding(
      padding: EdgeInsets.all(18),
      child: Card(
        color: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: reqWidgets,
          ),
        ),
      )
    );
  }
}