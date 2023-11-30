import 'package:flutter/material.dart';

class EventsScreenCard extends StatelessWidget {
  String title;
  String imageUrl;
  String description;
  String text_TextButton;
  String elevatedButton_text;
  Icon? elevatedButton_icon;
  Function onTapTextButton;
  Function onTapElevatedButton;
  EventsScreenCard(
      {required this.title,
      required this.description,
      required this.imageUrl,
      required this.text_TextButton,
      required this.onTapTextButton,
      required this.onTapElevatedButton,
      required this.elevatedButton_icon,
      required this.elevatedButton_text});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
      // color: Colors.white,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: 150.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image:
                        NetworkImage(imageUrl), // Replace with your image URL
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF090B0E),
                  fontSize: 14,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF090B0E),
                  fontSize: 12,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        '₹ 99',
                        style: TextStyle(
                          color: Color(0xFF546881),
                          fontSize: 14,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Event Fee',
                        style: TextStyle(
                          color: Color(0xFF546881),
                          fontSize: 12,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '120+',
                        style: TextStyle(
                          color: Color(0xFF546881),
                          fontSize: 14,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Registered',
                        style: TextStyle(
                          color: Color(0xFF546881),
                          fontSize: 12,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Sun, Sep 24',
                        style: TextStyle(
                          color: Color(0xFF546881),
                          fontSize: 14,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Happeing on',
                        style: TextStyle(
                          color: Color(0xFF546881),
                          fontSize: 12,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 17, vertical: 8),
                  width: double.infinity,
                  child: elevatedButton_icon != null
                      ? ElevatedButton.icon(
                          onPressed: () {
                            onTapElevatedButton();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF7B61FF),
                          ),
                          icon: elevatedButton_icon!,
                          label: Text(
                            elevatedButton_text,
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            onTapElevatedButton();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF7B61FF),
                          ),
                          child: Text(
                            elevatedButton_text,
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
              TextButton(
                onPressed: () {
                  onTapTextButton();
                },
                child: Text(
                  text_TextButton,
                  style: TextStyle(color: Color(0xFF7B61FF)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
