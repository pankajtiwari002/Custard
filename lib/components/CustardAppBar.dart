import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustardAppBar {

  static homeAppBar(
    Function onAvatarTap
  ) {
    return AppBar(
      leading: Padding(
        padding: EdgeInsets.all(6),
        child: GestureDetector(
          onTap: () {
            onAvatarTap;
          },
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/avatar.png'),
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Social Dance tribe',
            style: TextStyle(
                color: Color(0xFF090B0E),
                fontSize: 18,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600
            ),
          ),
          Text(
            'Jaipur, Rajasthan',
            style: TextStyle(
                color: Color(0xFF546881),
                fontSize: 14,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w500
            ),
          )
        ],
      ),
      actions: [
        IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications)
        ),
        IconButton(
            onPressed: () {},
            icon: const Icon(Icons.message)
        )
      ],
    );
  }
}