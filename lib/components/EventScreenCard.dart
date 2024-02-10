import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custard_flutter/controllers/MainController.dart';
import 'package:custard_flutter/view/TicketScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EventsScreenCard extends StatefulWidget {
  String eventId;
  String title;
  String imageUrl;
  String description;
  String? text_TextButton;
  String? elevatedButton_text;
  Icon? elevatedButton_icon;
  Function onTapTextButton;
  Function onTapElevatedButton;
  double price;
  int capacity;
  int dateTime;
  bool isUpcoming;
  EventsScreenCard({
    required this.eventId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.text_TextButton,
    required this.onTapTextButton,
    required this.onTapElevatedButton,
    required this.elevatedButton_icon,
    required this.elevatedButton_text,
    required this.price,
    required this.dateTime,
    required this.capacity,
    this.isUpcoming = false,
  });

  @override
  State<EventsScreenCard> createState() => _EventsScreenCardState();
}

class _EventsScreenCardState extends State<EventsScreenCard> {
  MainController mainController = Get.find();
  Rx<bool> isLoading = false.obs;
  Rx<bool> isShown = true.obs;
  QueryDocumentSnapshot? snapshot;
  DateTime convertMillisecondsToDateTime(int millisecondsSinceEpoch) {
    return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  }

  Future<void> init() async {
    final snap = await FirebaseFirestore.instance
        .collection("userEvents")
        .where("uid", isEqualTo: mainController.currentUser!.uid)
        .where("eventId", isEqualTo: widget.eventId)
        .get();
    print(snap.docs.length);
    if (snap.docs.length != 0) {
      snapshot = snap.docs[0];
      isShown.value = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isUpcoming) {
      isLoading.value = true;
      init().then((value) {
        isLoading.value = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isLoading.value) {
        return Container();
      }
      return Container(
        // color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        // color: Colors.white,
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 0.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: Get.size.width * 0.5,
                  height: Get.size.width * 0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: NetworkImage(
                          widget.imageUrl), // Replace with your image URL
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  widget.title,
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
                  widget.description,
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
                          '₹ ${widget.price}',
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
                          '${widget.capacity}+',
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
                          DateFormat('EE, MMM d').format(
                              convertMillisecondsToDateTime(widget.dateTime)),
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
                Obx(() {
                  print(isShown.value);
                  if (isShown.value && widget.elevatedButton_text != null) {
                    return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 17, vertical: 8),
                        width: double.infinity,
                        child: widget.elevatedButton_icon != null
                            ? ElevatedButton.icon(
                                onPressed: () {
                                  widget.onTapElevatedButton();
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF7B61FF),
                                ),
                                icon: widget.elevatedButton_icon!,
                                label: Text(
                                  widget.elevatedButton_text!,
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  widget.onTapElevatedButton();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF7B61FF),
                                ),
                                child: Text(
                                  widget.elevatedButton_text!,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ));
                  } else if (snapshot != null) {
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 17, vertical: 4),
                      width: double.infinity,
                      child: Column(
                        children: [
                          Text("You have already booked Ticket",
                              style: TextStyle(color: Color(0xFF7B61FF))),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Get.to(() => TicketScreen(snapshot: snapshot));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF7B61FF),
                              ),
                              child: Text(
                                "View Ticket",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Container();
                }),
                if (widget.text_TextButton != null)
                  TextButton(
                    onPressed: () {
                      widget.onTapTextButton();
                    },
                    child: Text(
                      widget.text_TextButton!,
                      style: TextStyle(color: Color(0xFF7B61FF)),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
