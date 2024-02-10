import 'dart:developer';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custard_flutter/components/CustardButton.dart';
import 'package:custard_flutter/controllers/InvitePeopleController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvitePeopleScreen extends StatelessWidget {
  String eventId;
  InvitePeopleScreen({super.key, required this.eventId});

  _showMoreBottomSheet() {
    Get.bottomSheet(
      ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
        child: Container(
          padding: EdgeInsets.only(bottom: 20, top: 15),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Icons.people,
                  color: Colors.red,
                ),
                title: Text(
                  'Kick Priya Bhatt',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.block,
                  color: Colors.red,
                ),
                title: Text(
                  'Ban Priya Bhatt',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InvitePeopleController(eventId: eventId));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Participants",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            CustardButton(
              buttonType: ButtonType.NEGATIVE,
              label: "+ Invite People",
              onPressed: () {},
              textColor: Colors.purple,
              backgroundColor: Colors.white,
            ),
            SizedBox(
              height: 10,
            ),
            Obx(() {
              if (controller.isLoading.value) {
                return SizedBox.shrink();
              } else {
                // log(controller.userEvents.length.toString());
                return ListView.builder(
                    itemCount: controller.userEvents.length,
                    shrinkWrap: true,
                    primary: false,
                    itemBuilder: (context, index) {
                      log(index.toString());
                      return FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection("users")
                              .doc(controller.userEvents[index]['uid'])
                              .get(),
                          builder: ((context, snapshot) {
                            log("data + $index");
                            if (snapshot.connectionState ==
                                    ConnectionState.active ||
                                snapshot.connectionState ==
                                    ConnectionState.done) {
                              if (snapshot.hasData) {
                                return ListTile(
                                  leading: CircleAvatar(
                                    radius: 16,
                                    backgroundImage: NetworkImage(
                                        snapshot.data!['profilePic']),
                                  ),
                                  title: Text(snapshot.data!['name']),
                                  trailing: IconButton(
                                      onPressed: () {
                                        _showMoreBottomSheet();
                                      },
                                      icon: Icon(Icons.more_vert)),
                                );
                              }
                            }
                            return Container();
                          }));
                    });
              }
            })
          ],
        ),
      ),
    );
  }
}
