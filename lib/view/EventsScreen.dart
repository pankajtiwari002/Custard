import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custard_flutter/components/EventScreenCard.dart';
import 'package:custard_flutter/view/CheckInScreen.dart';
import 'package:custard_flutter/view/CreateEventScreen.dart';
import 'package:custard_flutter/view/GroupImageScreen.dart';
import 'package:custard_flutter/view/ManageEventScreen.dart';
import 'package:custard_flutter/view/TicketScreen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'RegisterNowScreen.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Events",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Enrolled'),
              Tab(text: 'Upcoming'),
              Tab(text: 'Past Events'),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            indicatorColor: Colors.white,
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.calendar_month,
                  color: Colors.white,
                ))
          ],
        ),
        body: TabBarView(
          children: [
            // Your Upcoming Tab Content
            EnrolledTab(),
            UpComingTab(),
            // Your Post Events Tab Content
            PastEvent(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(() => CreateEventScreen());
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Color(0xFF7B61FF),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }

  Widget UpComingTab() {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('events')
          .where('dateTime',
              isGreaterThanOrEqualTo: DateTime.now().millisecondsSinceEpoch)
          .orderBy('dateTime', descending: false)
          .get(),
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
                    title: events[index]['title'],
                    description: events[index]['description'],
                    imageUrl: events[index]['coverPhotoUrl'],
                    text_TextButton: "Manage Event",
                    onTapTextButton: () {
                      Get.to(() => ManageEventScreen(snapshot: snapshot,index: index,));
                    },
                    onTapElevatedButton: () {
                      Get.to(() => CheckInScreen());
                    },
                    elevatedButton_icon: Icon(
                      Icons.qr_code_scanner,
                      color: Colors.white,
                    ),
                    elevatedButton_text: "Check-In",
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

  Widget EnrolledTab() {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('events')
          .where('dateTime',
              isGreaterThanOrEqualTo: DateTime.now().millisecondsSinceEpoch)
          .orderBy('dateTime', descending: false)
          .get(),
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
                    title: events[index]['title'],
                    description: events[index]['description'],
                    imageUrl: events[index]['coverPhotoUrl'],
                    text_TextButton: "View Ticket",
                    onTapTextButton: () {
                      Get.to(() => TicketScreen(snapshot: snapshot,index: index,));
                    },
                    onTapElevatedButton: () {
                      // Get.to(() => CheckInScreen());
                      Get.to(() => RegisterNowScreen());
                    },
                    elevatedButton_icon: Icon(
                      Icons.qr_code_scanner,
                      color: Colors.white,
                    ),
                    elevatedButton_text: "Register Now",
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

  Widget PastEvent() {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('events')
          .where('dateTime', isLessThan: DateTime.now().millisecondsSinceEpoch)
          .orderBy('dateTime', descending: true)
          .get(),
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
                    title: events[index]['title'],
                    description: events[index]['description'],
                    imageUrl: events[index]['coverPhotoUrl'],
                    text_TextButton: "Manage Event",
                    onTapTextButton: () {
                      Get.to(() => ManageEventScreen(snapshot: snapshot,index: index,));
                    },
                    onTapElevatedButton: () {
                      Get.to(() => CheckInScreen());
                    },
                    elevatedButton_icon: Icon(
                      Icons.qr_code_scanner,
                      color: Colors.white,
                    ),
                    elevatedButton_text: "Check-In",
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
