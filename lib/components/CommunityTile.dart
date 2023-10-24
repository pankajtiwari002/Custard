import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommunityTile extends StatelessWidget {
  ImageProvider<Object> image;
  String tilte;

  CommunityTile({
    required this.image,
    required this.tilte
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Padding(
        padding: EdgeInsets.all(12),
        child: CircleAvatar(
          backgroundImage: image,
        ),
      ),
      title: Text(
        tilte,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w500
        ),
      ),
    );
  }
}