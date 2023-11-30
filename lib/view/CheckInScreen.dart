import 'package:flutter/material.dart';

class CheckInScreen extends StatelessWidget {
  const CheckInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Check-In",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: size.height * 0.9,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage("https://cdn3.vectorstock.com/i/1000x1000/47/02/a-man-scanning-qr-code-via-mobile-phone-vector-35944702.jpg"), fit: BoxFit.cover)),
          ),
          Container(
            color: Colors.transparent,
            height: size.height - AppBar().preferredSize.height,
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height*0.15,
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  )),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'At a glance',
                    style: TextStyle(
                      color: Color(0xFF090B0E),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '25 ',
                          style: TextStyle(
                            color: Color(0xFF00BC32),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: 'guests checked in',
                          style: TextStyle(
                            color: Color(0xFF00BC32),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 6,),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(right: 20),
                    height: 6,
                    decoration: BoxDecoration(
                      color: Color(0xFF00BC32),
                      borderRadius: BorderRadius.circular(19),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
