import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'DashedBox.dart';

class CommunityCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
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
            children: [
              Image(image: NetworkImage("https://via.placeholder.com/290x110")),
              Text(
                'Social Dance Tribe',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF061237),
                  fontSize: 24,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '“Jumping foxes dance swiftly under the moonlit sky, creating a mesmerizing spectacle of nature\'s beauty”',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF061237),
                  fontSize: 12,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w500
                )
              ),
              DashedBox(
                widget: [
                  Icon(Icons.lock,size: 16),
                  SizedBox(width: 12, height: 12),
                  Text(
                    'Anyone can join for free',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF1D2848),
                      fontSize: 12,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}