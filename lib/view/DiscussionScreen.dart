import 'dart:developer';
import 'dart:io';
import 'package:custard_flutter/view/PollsScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:custard_flutter/controllers/DiscussionController.dart';
import 'package:custard_flutter/repo/StorageMethods.dart';
import 'package:custard_flutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:uuid/uuid.dart';

import '../components/MessageCard.dart';

class DiscussionScreen extends StatelessWidget {
  DiscussionController controller = Get.put(DiscussionController());
  FocusNode focusNode = FocusNode();
  String? recordFilePath;

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  int i = 0;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/test_${i++}.mp3";
  }

  void startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      controller.isRecording.value = true;
      recordFilePath = await getFilePath();
      RecordMp3.instance.start(recordFilePath!, (type) {});
    }
  }

  void stopRecord() {
    bool s = RecordMp3.instance.stop();
    if (s) {
      controller.isCompleteAudioRecording.value = true;
    }
  }

  void _openBottomSheet() {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        padding: EdgeInsets.all(16.0),
        child: Row(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildInkWell(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHIPpKB7-_-sIXNlCRuBzwH_pxHp1uAwoXUA&usqp=CAU',
                () async {
              try {
                controller.image.value = await pickImage(ImageSource.gallery);
                Get.back();
                focusNode.requestFocus();
                print("successfull selected");
              } catch (e) {
                print("select image error: ");
                print(e.toString());
              }
            }),
            buildInkWell(
                'https://static.vecteezy.com/system/resources/previews/006/692/271/non_2x/document-icon-template-black-color-editable-document-icon-symbol-flat-illustration-for-graphic-and-web-design-free-vector.jpg',
                () async {
              try {
                controller.document.value = await pickDocument();
                Get.back();
                focusNode.requestFocus();
              } catch (e) {
                print("Select document error: ");
                print(e.toString());
              }
            }),
            buildInkWell(
                'https://cdn-icons-png.flaticon.com/512/535/535239.png', () {}),
            buildInkWell(
                'https://static-00.iconduck.com/assets.00/poll-icon-2048x2048-yi03citz.png',
                () {
                  Get.to(() => PollsScreen());
                }),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  Widget buildInkWell(String imageUrl, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.grey),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Image.network(
            imageUrl, // Replace with your image URL
            width: 50.0,
            // height: 100.0,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

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
                controller.messages
                    .removeWhere((element) => element["isSelected"]);
                controller.totalSelected.value = 0;
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
            Obx(
              () => Container(
                height: kToolbarHeight + 5,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          _openBottomSheet();
                        },
                        icon: Icon(Icons.add)),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                            color: Color(0xFFF9FAFB)),
                        child: controller.isCompleteAudioRecording.value
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("time"),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  )
                                ],
                              )
                            : controller.isRecording.value
                                ? Container(
                                  height: 50,
                                  child: Text("time"),
                                )
                                : TextFormField(
                                    focusNode: focusNode,
                                    // autofocus: true,
                                    controller: controller.messageController,
                                    decoration: InputDecoration(
                                        hintText: "Write a Message",
                                        border: InputBorder.none,
                                        suffix: IconButton(
                                            onPressed: () async {
                                              print(controller.reply);
                                              String text = controller
                                                  .messageController.text;
                                              controller
                                                  .messageController.text = "";
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                              Map<String, dynamic> mp =
                                                  controller.reply.value;
                                              String? imageUrl = null;
                                              String? documentUrl = null;
                                              if (controller.image.value !=
                                                  null) {
                                                String uid = Uuid().v1();
                                                imageUrl = await StorageMethods
                                                    .uploadImageToStorage(
                                                        'chat/image',
                                                        uid,
                                                        controller
                                                            .image.value!);
                                              }
                                              if (controller.document.value !=
                                                  null) {
                                                String uid = Uuid().v1();
                                                documentUrl =
                                                    await StorageMethods
                                                        .uploadDocument(
                                                            'chat/document',
                                                            uid,
                                                            controller.document
                                                                .value!);
                                              }
                                              controller.messages.add(RxMap({
                                                'profileUrl':
                                                    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y3VzdG9tZXIlMjBwcm9maWxlfGVufDB8fDB8fHww&w=1000&q=80',
                                                'name': 'Pankaj',
                                                'imageUrl': imageUrl,
                                                'documentUrl': documentUrl,
                                                'textMessage': controller
                                                    .messageController.text,
                                                'repliedMessage':
                                                    controller.reply["name"] ==
                                                            null
                                                        ? null
                                                        : mp,
                                                'date': DateTime.now(),
                                                'prevDate': DateTime.now()
                                                    .subtract(
                                                        Duration(minutes: 2)),
                                                'owner': true,
                                                "isSelected": false
                                              }));
                                              controller.reply.value = {};
                                            },
                                            icon: Icon(Icons.send))),
                                    style: TextStyle(fontSize: 14),
                                  ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (controller.isCompleteAudioRecording.value) {
                          String filename = recordFilePath!.split('/').last;
                          print("audio path: ${recordFilePath}");
                          File file = File(recordFilePath!);
                          print((await file.length()).toString());
                          String uid = Uuid().v1();
                          String audioMessageUrl =
                              await StorageMethods.uploadDocument(
                                  'chat/audio', uid, file);
                          print("audio Message Url: $audioMessageUrl");
                          controller.messages.add(RxMap({
                            'profileUrl':
                                'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y3VzdG9tZXIlMjBwcm9maWxlfGVufDB8fDB8fHww&w=1000&q=80',
                            'name': 'Pankaj',
                            'imageUrl': null,
                            'documentUrl': null,
                            'audioMessageUrl': audioMessageUrl,
                            'textMessage': controller.messageController.text,
                            'repliedMessage': null,
                            'date': DateTime.now(),
                            'prevDate':
                                DateTime.now().subtract(Duration(minutes: 2)),
                            'owner': true,
                            "isSelected": false
                          }));
                          controller.isCompleteAudioRecording.value = false;
                          controller.isRecording.value = false;
                        }
                      },
                      onLongPress: () async {
                        startRecord();
                      },
                      onLongPressEnd: (details) {
                        stopRecord();
                      },
                      child: Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Color(0xFF7B61FF)),
                          child: controller.isCompleteAudioRecording.value
                              ? Icon(
                                  Icons.send,
                                  color: Colors.white,
                                )
                              : controller.isRecording.value
                                  ? Icon(
                                      Icons.stop,
                                      color: Colors.red,
                                    )
                                  : Icon(
                                      Icons.mic,
                                      color: Colors.white,
                                    )),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
