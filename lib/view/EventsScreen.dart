import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custard_flutter/components/EventScreenCard.dart';
import 'package:custard_flutter/controllers/EventController.dart';
import 'package:custard_flutter/controllers/MainController.dart';
import 'package:custard_flutter/view/AllPhotosScreen.dart';
import 'package:custard_flutter/view/CheckInScreen.dart';
import 'package:custard_flutter/view/CreateEventScreen.dart';
import 'package:custard_flutter/view/EventCalendarScreen.dart';
import 'package:custard_flutter/view/FeedBackScreen.dart';
import 'package:custard_flutter/view/GroupImageScreen.dart';
import 'package:custard_flutter/view/ManageEventScreen.dart';
import 'package:custard_flutter/view/QrScanner.dart';
import 'package:custard_flutter/view/TicketScreen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'RegisterNowScreen.dart';

class EventsScreen extends StatelessWidget {
  EventsScreen({super.key});

  MainController mainController = Get.find();
  late EventController controller;
  ScrollController enrolledScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    controller = Get.put(EventController(uid: mainController.currentUser!.uid));

    enrolledScrollController.addListener(() {
      log(enrolledScrollController.offset.toString());
    });
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color(0x497B61FF),
        appBar: AppBar(
          title: Text(
            "Events",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          bottom: TabBar(
            tabs: [
              // Tab(text: 'Enrolled'),
              Tab(text: 'Upcoming'),
              Tab(text: 'Past Events'),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            indicatorColor: Colors.white,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(() => EventCalendarScreen());
                },
                icon: Icon(
                  Icons.calendar_month,
                  color: Colors.white,
                ))
          ],
        ),
        body: TabBarView(
          children: [
            // Your Upcoming Tab Content
            // EnrolledTab(enrolledScrollController),
            UpComingTab(),
            // Your Post Events Tab Content
            PastEvent(),
          ],
        ),
        floatingActionButton: mainController.role.value == "admin"
            ? FloatingActionButton(
                onPressed: () {
                  Get.to(() => CreateEventScreen());
                },
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: Color(0xFF7B61FF),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              )
            : null,
      ),
    );
  }

  Widget UpComingTab() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('events')
          .where('dateTime',
              isGreaterThanOrEqualTo: DateTime.now().millisecondsSinceEpoch)
          .orderBy('dateTime', descending: false)
          .snapshots(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            List<dynamic> events = snapshot.data!.docs;
            print(events[0].id);
            return ListView.builder(
                cacheExtent: double.maxFinite,
                itemCount: events.length,
                itemBuilder: ((context, index) {
                  return EventsScreenCard(
                    isUpcoming: true,
                    eventId: events[index].id,
                    title: events[index]['title'],
                    description: events[index]['description'],
                    imageUrl: events[index]['coverPhotoUrl'],
                    text_TextButton: mainController.role.value == "admin"
                        ? "Manage Event"
                        : null,
                    onTapTextButton: () {
                      Get.to(() => ManageEventScreen(
                            snapshot: snapshot.data!.docs,
                            index: index,
                          ));
                    },
                    onTapElevatedButton: mainController.role.value == "admin"
                        ? () {
                            // Get.to(() => CheckInScreen());
                            Get.to(() => QrScannerScreen());
                          }
                        : () {
                            Get.to(() => RegisterNowScreen(
                                  snapshot: snapshot.data!.docs[index].data(),
                                  id: snapshot.data!.docs[index].id,
                                ));
                          },
                    elevatedButton_icon: mainController.role.value == "admin"
                        ? Icon(
                            Icons.qr_code_scanner,
                            color: Colors.white,
                          )
                        : null,
                    elevatedButton_text: mainController.role.value == "admin"
                        ? "Check-In"
                        : "Register Now",
                    dateTime: events[index]['dateTime'],
                    capacity: events[index]['capacity'],
                    price: events[index]['ticketPrice'],
                  );
                }));
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      }),
    );
  }

  Widget EnrolledTab(ScrollController scrollController) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('userEvents')
          .where("uid", isEqualTo: mainController.currentUser!.uid)
          .get(),
      builder: ((context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            List<dynamic> userEvents = snapshot.data!.docs;
            // print(userEvents[0]['eventId']);
            print(userEvents[1]['id']);
            return ListView.builder(
                controller: scrollController,
                itemCount: userEvents.length,
                itemBuilder: ((context, index) {
                  log(index.toString());
                  return FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection("events")
                          .doc(userEvents[index]['eventId'])
                          .get(),
                      builder: (context,
                          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                              snap) {
                        // print("index:: $index");
                        if (snap.connectionState == ConnectionState.done ||
                            snap.connectionState == ConnectionState.active) {
                          if (snap.hasData) {
                            final event = snap.data!;
                            print("hi");
                            print("event: ${event.data()?['title']}");
                            return InkWell(
                              onTap: () {
                                print(event.data());
                                Get.to(() => RegisterNowScreen(
                                      snapshot: event.data()!,
                                      id: event.id,
                                    ));
                              },
                              child: EventsScreenCard(
                                eventId: "",
                                title: event.get('title'),
                                description: event.get('description'),
                                imageUrl: event.get('coverPhotoUrl'),
                                text_TextButton:
                                    mainController.role.value == "admin"
                                        ? "View Ticket"
                                        : null,
                                onTapTextButton: () {
                                  Get.to(() => TicketScreen(
                                        snapshot: snap.data,
                                      ));
                                },
                                onTapElevatedButton: () {
                                  if (mainController.role.value == "admin") {
                                    Get.to(() => CheckInScreen());
                                  } else {
                                    Get.to(() => TicketScreen(
                                          snapshot: snap,
                                        ));
                                  }
                                },
                                elevatedButton_icon:
                                    mainController.role.value == "admin"
                                        ? Icon(
                                            Icons.qr_code_scanner,
                                            color: Colors.white,
                                          )
                                        : null,
                                elevatedButton_text:
                                    mainController.role.value == "admin"
                                        ? "Check-in"
                                        : "View Ticket",
                                dateTime: event.get('dateTime'),
                                capacity: event.get('capacity'),
                                price: event.get('ticketPrice'),
                              ),
                            );
                          }
                        }
                        return Container();
                      });
                }));
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      }),
    );
  }

  Widget PastEvent() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('events')
          .where('dateTime', isLessThan: DateTime.now().millisecondsSinceEpoch)
          .orderBy('dateTime', descending: true)
          .snapshots(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            List<dynamic> events = snapshot.data!.docs;
            return ListView.builder(
                itemCount: events.length,
                dragStartBehavior: DragStartBehavior.down,
                itemBuilder: ((context, index) {
                  return EventsScreenCard(
                    eventId: events[index].id,
                    title: events[index]['title'],
                    description: events[index]['description'],
                    imageUrl: events[index]['coverPhotoUrl'],
                    text_TextButton: mainController.role.value == "admin"
                        ? "View FeedBack"
                        : "Give feedback",
                    onTapTextButton: () {
                      if (mainController.role.value == "admin") {
                        Get.to(() => ManageEventScreen(
                            snapshot: snapshot, index: index,isFeedBack: true,));
                      } else {
                        Get.to(() => FeedBackScreen());
                      }
                    },
                    onTapElevatedButton: () async {
                      print("id: " + events[index].id);
                      // final snap = await FirebaseFirestore.instance
                      //     .collection("gallery")
                      //     .where("eventId", isEqualTo: events[index].id)
                      //     .get();
                      // List<dynamic> images = snap.docs[0].data()['urls'];
                      Get.to(() => AllPhotoScreen(snapshot: snapshot,index: index,));
                    },
                    elevatedButton_icon: null,
                    elevatedButton_text: "Open Gallery",
                    dateTime: events[index]['dateTime'],
                    capacity: events[index]['capacity'],
                    price: events[index]['ticketPrice'],
                  );
                }));
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      }),
    );
  }
}
