import 'package:custard_flutter/components/EventScreenCard.dart';
import 'package:custard_flutter/view/CheckInScreen.dart';
import 'package:custard_flutter/view/CreateEventScreen.dart';
import 'package:custard_flutter/view/ManageEventScreen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    return ListView.builder(
        itemCount: 2,
        dragStartBehavior: DragStartBehavior.down,
        itemBuilder: ((context, index) {
          return EventsScreenCard(
            title: "The art of living",
            description:
                "Jumping foxes dance swiftly under the moonlit sky, creating a mesmerizing spectacle of nature's beauty.",
            imageUrl:
                "https://images.unsplash.com/photo-1524601500432-1e1a4c71d692?auto=format&fit=crop&q=80&w=1000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fGdyb3VwfGVufDB8fDB8fHww",
            text_TextButton: "Manage Event",
            onTapTextButton: () {
              Get.to(() => ManageEventScreen());
            },
            onTapElevatedButton: () {
              Get.to(() => CheckInScreen());
            },
            elevatedButton_icon: Icon(Icons.qr_code_scanner,color: Colors.white,),
            elevatedButton_text: "Check-In",
          );
        }));
  }

  Widget EnrolledTab() {
    return ListView.builder(
        itemCount: 1,
        dragStartBehavior: DragStartBehavior.down,
        itemBuilder: ((context, index) {
          return EventsScreenCard(
            title: "The art of living",
            description:
                "Jumping foxes dance swiftly under the moonlit sky, creating a mesmerizing spectacle of nature's beauty.",
            imageUrl:
                "https://images.unsplash.com/photo-1524601500432-1e1a4c71d692?auto=format&fit=crop&q=80&w=1000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fGdyb3VwfGVufDB8fDB8fHww",
            text_TextButton: "View Tickets",
            onTapTextButton: () {
              print("Text Button");
            },
            onTapElevatedButton: () {
              Get.to(() => CheckInScreen());
            },
            elevatedButton_icon: Icon(Icons.qr_code_scanner,color: Colors.white,),
            elevatedButton_text: "Check-In",
          );
        }));
  }

  Widget PastEvent() {
    return ListView.builder(
        itemCount: 1,
        dragStartBehavior: DragStartBehavior.down,
        itemBuilder: ((context, index) {
          return EventsScreenCard(
            title: "The art of living",
            description:
                "Jumping foxes dance swiftly under the moonlit sky, creating a mesmerizing spectacle of nature's beauty.",
            imageUrl:
                "https://images.unsplash.com/photo-1524601500432-1e1a4c71d692?auto=format&fit=crop&q=80&w=1000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fGdyb3VwfGVufDB8fDB8fHww",
            text_TextButton: "View FeedBack",
            onTapTextButton: () {
              print("Text Button");
            },
            elevatedButton_icon: null,
            elevatedButton_text: "Open Gallery",
            onTapElevatedButton: () {
              print("Elevated Button");
            },
          );
        }));
  }
}
