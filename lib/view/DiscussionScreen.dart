import 'dart:developer';

import 'package:custard_flutter/controllers/DiscussionController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/MessageCard.dart';

class DiscussionScreen extends StatelessWidget {
  DiscussionController controller = Get.put(DiscussionController());

  _openDeleteDialogBox() {
    Get.dialog(
      AlertDialog(
        title: const Center(
          child: Text(
            'Confirm Deletion',
            style: TextStyle(
              color: Color(0xFF090B0E),
              fontSize: 24,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        content: Text(
          'Are you sure you want to delete this message?',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF546881),
            fontSize: 14,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w400,
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          SizedBox(
            width: 120,
            child: TextButton(
              onPressed: () {
                Get.back(); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: TextButton(
              onPressed: () {
                // Perform deletion logic here
                controller.messages.removeWhere((element) => element["isSelected"]);
                controller.totalSelected.value=0;
                Get.back(); // Close the dialog
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFF665EE0)),
              ),
            ),
          ),
        ],
      ),
      barrierDismissible:
          true, // Set this to true if you want to close dialog by tapping outside
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Obx(
          () => Text(
            controller.totalSelected.value > 0
                ? "${controller.totalSelected.value}"
                : "#General",
            style: TextStyle(color: Colors.white),
          ),
        ),
        leading: Obx(() => IconButton(
            onPressed: () {
              if (controller.totalSelected.value > 0) {
                for (int i = 0; i < controller.messages.length; i++) {
                  controller.messages[i]['isSelected'] = false;
                }
                controller.totalSelected.value = 0;
              } else {}
            },
            icon: controller.totalSelected.value > 0
                ? const Icon(
                    Icons.cancel,
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ))),
        actions: [
          Obx(
            () => controller.totalSelected > 0
                ? IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.star_outline_rounded, color: Colors.white))
                : IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.tag, color: Colors.white)),
          ),
          Obx(
            () => controller.totalSelected > 0
                ? IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.copy, color: Colors.white))
                : IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.push_pin_rounded, color: Colors.white)),
          ),
          Obx(
            () => controller.totalSelected > 0
                ? IconButton(
                    onPressed: () {
                      _openDeleteDialogBox();
                    },
                    icon: Icon(Icons.delete_outline, color: Colors.white))
                : IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.people, color: Colors.white)),
          ),
          PopupMenuButton(
            child: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            color: Colors.black,
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'reply',
                child: Row(
                  children: [
                    Icon(
                      Icons.tag,
                      color: Colors.white,
                    ),
                    Text(
                      'Reply in thread',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'report',
                child: Row(
                  children: [
                    Icon(
                      Icons.report,
                      color: Colors.white,
                    ),
                    Text(
                      'Report',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
            onSelected: (String value) {
              // Perform actions based on selected value
              if (value == 'reply') {
                print('Reply in thread selected');
                // Add your reply in thread logic here
              } else if (value == 'report') {
                print('Report selected');
                // Add your report logic here
              }
            },
          ),
        ],
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.messages.length,
          itemBuilder: (context, index) {
            return MessageCard(
              index: index,
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              print("Hello ${controller.reply.toString()}");
              if (controller.reply["name"] == null) {
                return Container();
              } else {
                return Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFFF9FAFB),
                    ),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Row(children: [
                        CircleAvatar(
                            backgroundImage:
                                NetworkImage(controller.reply["profileUrl"]),
                            radius: 14),
                        SizedBox(
                          width: 10,
                        ),
                        Text(controller.reply["name"]),
                        Spacer(),
                        IconButton(
                            onPressed: () {
                              controller.reply.value = {};
                            },
                            icon: Icon(Icons.cancel)),
                      ]),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        controller.reply["textMessage"],
                        style: TextStyle(
                          color: Color(0xFF090B0E),
                          fontSize: 14,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.20,
                        ),
                      ),
                    ]));
              }
            }),
            Container(
              height: kToolbarHeight + 5,
              child: Row(
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                          color: Color(0xFFF9FAFB)),
                      child: TextFormField(
                        controller: controller.messageController,
                        decoration: InputDecoration(
                            hintText: "Write a Message",
                            border: InputBorder.none,
                            suffix: IconButton(
                                onPressed: () {
                                  print(controller.reply);
                                  Map<String,dynamic> mp = controller.reply.value;
                                  controller.messages.add(RxMap({
                                    'profileUrl':
                                        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y3VzdG9tZXIlMjBwcm9maWxlfGVufDB8fDB8fHww&w=1000&q=80',
                                    'name': 'Pankaj',
                                    'imageUrl': null,
                                    'textMessage':
                                        controller.messageController.text,
                                    'repliedMessage':
                                        controller.reply["name"] == null
                                            ? null
                                            : mp,
                                    'date': DateTime.now(),
                                    'prevDate': DateTime.now()
                                        .subtract(Duration(minutes: 2)),
                                    'owner': true,
                                    "isSelected": false
                                  }));
                                  controller.messageController.text = "";
                                  controller.reply.value = {};
                                },
                                icon: Icon(Icons.send))),
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.mic))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
