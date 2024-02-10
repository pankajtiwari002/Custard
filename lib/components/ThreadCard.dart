import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ThreadCard extends StatelessWidget {
  String name;
  String image;
  ThreadCard({super.key, required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 20,
            offset: Offset(0, 5),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(image),
                radius: 20,
              ),
              SizedBox(
                width: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Priya Bhatt',
                    style: TextStyle(
                      color: Color(0xFF090B0E),
                      fontSize: 14,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '5-star reviews from satisfied customer',
                    style: TextStyle(
                      color: Color(0xFF546881),
                      fontSize: 14,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Divider(),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              SvgPicture.asset("assets/images/like.svg"),
              Text(
                '109',
                style: TextStyle(
                  color: Color(0xFF546881),
                  fontSize: 12,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: 24,
              ),
              SvgPicture.asset("assets/images/message-2.svg"),
              Text(
                '109',
                style: TextStyle(
                  color: Color(0xFF546881),
                  fontSize: 12,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: 24,
              ),
              SvgPicture.asset("assets/images/diagram.svg"),
              Text(
                '109',
                style: TextStyle(
                  color: Color(0xFF546881),
                  fontSize: 12,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
