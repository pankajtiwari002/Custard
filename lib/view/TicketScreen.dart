import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custard_flutter/controllers/MainController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketScreen extends StatelessWidget {
  final snapshot;
  TicketScreen({super.key, required this.snapshot});

  MainController mainController = Get.find();

  @override
  Widget build(BuildContext context) {
    log(snapshot.data().toString());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Ticket",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      backgroundColor: Color(0xff665ee0),
      body: Stack(
        children: [
          Container(
            height: Get.size.height,
            width: Get.size.width,
            child: Image.asset(
              "assets/images/Noise.png",
              fit: BoxFit.cover,
            ),
          ),
          FutureBuilder(
            future: FirebaseFirestore.instance
                .collection("events")
                // .where('uid', isEqualTo: mainController.currentUser!.uid)
                // .where('eventId', isEqualTo: snapshot.data()['id'])
                .doc(snapshot.data()['eventId'])
                .get(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.active ||
                  snap.connectionState == ConnectionState.done) {
                if (snap.hasData) {
                  return Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 18),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 17),
                            width: double.infinity,
                            height: 150.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: NetworkImage(snap.data![
                                    'coverPhotoUrl']), // Replace with your image URL
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 17),
                            child: Text(
                              snap.data!['title'],
                              style: TextStyle(
                                color: Color(0xFF090B0E),
                                fontSize: 18,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 17),
                            child: GridView(
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, childAspectRatio: 3
                                      // crossAxisSpacing: 1 / 2,
                                      ),
                              children: [
                                TicketColumn(
                                    heading: "Date",
                                    data: DateFormat('MMMM d, y').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            snap.data!
                                                ['dateTime']))),
                                TicketColumn(
                                    heading: "Time",
                                    data:
                                        "${DateFormat("EE").format(DateTime.fromMillisecondsSinceEpoch(snap.data!['dateTime']))} ,${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(snap.data!['dateTime']))}"),
                                TicketColumn(
                                    heading: "Admit", data: "01 only"),
                                TicketColumn(
                                    heading: "Venue",
                                    data: "Boston College Ground"),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 14.0,
                                height: 28.0,
                                decoration: BoxDecoration(
                                  color: Color(0xff665ee0),
                                  image: DecorationImage(image: AssetImage("assets/images/Noise.png"),fit: BoxFit.cover),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(50.0),
                                    bottomRight: Radius.circular(50.0),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(child: Divider()),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                width: 14.0,
                                height: 28.0,
                                decoration: BoxDecoration(
                                  color: Color(0xff665ee0),
                                  image: DecorationImage(image: AssetImage("assets/images/Noise.png"),fit: BoxFit.cover,scale: 2),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50.0),
                                    bottomLeft: Radius.circular(50.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Center(
                            child: Container(
                              height: 150,
                              width: 150,
                              child: QrImageView(
                                data: snapshot.data()['id'],
                                version: QrVersions.auto,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              'Booking id - 000012456732',
                              style: TextStyle(
                                color: Color(0xFF546881),
                                fontSize: 14,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  );
                }
                return Container(
                  child: Text("No Data"),
                );
              }
              return Container();
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/Noise.png"),fit: BoxFit.cover)
        ),
          height: 90,
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 21),
          child: ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.download),
              label: Text("Download Ticket"))),
    );
  }
}

class RightSemiCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = size.height / 2;

    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width + radius, 0)
      ..arcToPoint(
        Offset(size.width - radius, size.height),
        radius: Radius.circular(radius),
        clockwise: true,
      )
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class LeftSemiCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = size.height / 2;

    return Path()
      ..moveTo(radius, 0)
      ..arcToPoint(Offset(radius, size.height),
          radius: Radius.circular(radius), clockwise: false)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class TicketColumn extends StatelessWidget {
  String heading;
  String data;
  TicketColumn({super.key, required this.heading, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: TextStyle(
            color: Color(0xFF546881),
            fontSize: 14,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          data,
          style: TextStyle(
            color: Color(0xFF090B0E),
            fontSize: 14,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }
}
