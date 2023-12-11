import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:custard_flutter/controllers/MainController.dart';
import 'package:custard_flutter/utils/constants.dart';
import 'package:custard_flutter/src/FlowShader.dart';
import 'package:custard_flutter/src/Global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:custard_flutter/controllers/LocationController.dart';
import 'package:custard_flutter/view/MembersScreen.dart';
import 'package:custard_flutter/view/PollsScreen.dart';
import 'package:custard_flutter/view/ReportScreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
import 'package:workmanager/workmanager.dart';

import '../Global.dart';
import '../components/ChatBox.dart';
import '../components/MessageCard.dart';
import '../components/RecordButton.dart';

class DiscussionScreen extends StatelessWidget {
  DiscussionController controller = Get.put(DiscussionController());
  FocusNode focusNode = FocusNode();
  String? recordFilePath;
  final DatabaseReference _messagesRef = FirebaseDatabase.instance
      .reference()
      .child("communityChats/chapterId/messages");

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

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
      controller.start = DateTime.now();
      // while(true){
      //   if(controller.isCompleteAudioRecording.value) break;
      //   Future.delayed(Duration(seconds: 1)).then((value){
      //     controller.currentDuration.value = controller.currentDuration.value+ Duration(seconds: 1);
      //   });
      // }
    }
  }

  void stopRecord() {
    bool s = RecordMp3.instance.stop();
    controller.end = DateTime.now();
    if (s) {
      controller.isCompleteAudioRecording.value = true;
    }
  }

  void _openBottomSheet() {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () => Visibility(
                visible: controller.selectedButton.value == 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(Icons.image),
                      title: Text('Image'),
                      onTap: () async {
                        try {
                          // controller.image.value =
                          //     await pickImage(ImageSource.gallery);
                          XFile? file = await pickImage(ImageSource.gallery);
                          if (file != null) {
                            Uint8List bytes = await file.readAsBytes();
                            controller.image.value = bytes;
                            var path = await StorageMethods.saveImageToCache(
                                bytes,
                                "${Uuid().v1()}.${file.path.split('.').last}");
                            controller.imagePath = path;
                          }
                          Get.back();
                          focusNode.requestFocus();
                          print("successfull selected");
                        } catch (e) {
                          print("select image error: ");
                          print(e.toString());
                        }
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.video_call_sharp),
                      title: Text('Video'),
                      onTap: () async {
                        try {
                          XFile? file = await pickVideo(ImageSource.gallery);
                          if (file != null) {
                            print("asdf");
                            controller.video.value = await file.readAsBytes();
                            var path = await StorageMethods.saveImageToCache(
                                controller.video.value!,
                                "${Uuid().v1()}.${file.path.split('.').last}");
                            controller.videoPath = path;
                          }
                          print("successfull selected");
                        } catch (e) {
                          print("select image error: ");
                          print(e.toString());
                        }
                      },
                    ),
                    // Divider(
                    //   thickness: 15,
                    //   color: Color.fromARGB(109, 240, 235, 192),
                    // )
                  ],
                ),
              ),
            ),
            Row(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildInkWell('assets/images/image.svg', Color(0xFF318FFF), 1,
                    () {
                  controller.selectedButton.value = 1;
                }),
                buildInkWell(
                    'assets/images/document-text.svg', Color(0xFFFFCE59), 2,
                    () async {
                  controller.selectedButton.value = 2;
                  try {
                    controller.documentPath = await pickDocument();
                    if (controller.documentPath != null) {
                      controller.document.value =
                          File(controller.documentPath!);
                    }
                    // controller.document.value.path;
                    Get.back();
                    focusNode.requestFocus();
                  } catch (e) {
                    print("Select document error: ");
                    print(e.toString());
                  }
                }),
                buildInkWell('assets/images/location.svg', Color(0xFFF5225F), 3,
                    () async {
                  controller.selectedButton.value = 3;
                  Map<String, double>? mp =
                      await LocationController().getCoordinates();
                  if (mp != null) {
                    controller.messageController.text =
                        mp['latitude'].toString() +
                            ' ' +
                            mp['longitude'].toString();
                  }
                }),
                buildInkWell('assets/images/chart.svg', Color(0xFF60C255), 4,
                    () {
                  controller.selectedButton.value = 4;
                  Get.to(() => PollsScreen());
                }),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  Widget buildInkWell(
      String imageUrl, Color backgroundColor, int myId, VoidCallback onTap) {
    return Obx(() => InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                // border: Border.all(color: Colors.grey),
                color: backgroundColor),
            child: Container(
              padding: EdgeInsets.all(10),
              height: 50,
              width: 50,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: controller.selectedButton.value == myId
                      ? Border.all(color: Colors.white, width: 2)
                      : Border.all(color: Colors.transparent, width: 2),
                  color: backgroundColor),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: SvgPicture.asset(
                    imageUrl,
                    fit: BoxFit.contain,
                  )),
            ),
          ),
        ));
  }

  _openReportDialogBox() {
    Get.dialog(
      AlertDialog(
        title: const Center(
          child: Text(
            'Report Aman Gairola?',
            style: TextStyle(
              color: Color(0xFF090B0E),
              fontSize: 24,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        content: Text(
          'This message will be forwarded to communtiy admin. This contact will not be notified.',
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
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                Get.to(() => ReportScreen());
              },
              child: Text(
                'Report',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFF665EE0)),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Block this user',
                style: TextStyle(color: Color(0xFF665EE0)),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  side: MaterialStateProperty.all(
                      BorderSide(color: Color(0xFF665EE0)))),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                Get.back(); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF665EE0)),
              ),
            ),
          ),
        ],
      ),
      barrierDismissible:
          true, // Set this to true if you want to close dialog by tapping outside
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
            controller.selectedMessage.length > 0
                ? "${controller.selectedMessage.length}"
                : "#General",
            style: TextStyle(color: Colors.white),
          ),
        ),
        leading: Obx(() {
          if (controller.selectedMessage.length > 0) {
            return IconButton(
                onPressed: () {
                  controller.selectedMessage.clear();
                  // controller.totalSelected.value = 0;
                },
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.white,
                ));
          } else {
            return Container();
          }
        }),
        actions: [
          Obx(
            () => controller.selectedMessage.length > 0
                ? IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.star_outline_rounded, color: Colors.white))
                : IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.tag, color: Colors.white)),
          ),
          Obx(
            () => controller.selectedMessage.length > 0
                ? IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.copy, color: Colors.white))
                : IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.push_pin_rounded, color: Colors.white)),
          ),
          Obx(
            () => controller.selectedMessage.length > 0
                ? IconButton(
                    onPressed: () {
                      _openDeleteDialogBox();
                    },
                    icon: Icon(Icons.delete_outline, color: Colors.white))
                : IconButton(
                    onPressed: () {
                      Get.to(() => MembersScreen());
                    },
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
                _openReportDialogBox();
                print('Report selected');
                // Add your report logic here
              }
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _messagesRef.onValue,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done ||
              snapshot.connectionState == ConnectionState.active) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              List<dynamic> messages =
                  snapshot.data!.snapshot.children.toList();
                  return ListView.builder(
                          // shrinkWrap: true,
                          // primary: false,
                          itemCount: messages.length,
                          itemBuilder: ((context, index) {
                            return MessageCard(
                              index: index,
                              messages: messages,
                            );
                          }));
              // return Obx(
              //   () => SingleChildScrollView(
              //     child: Column(
              //       children: [
              //         ListView.builder(
              //             shrinkWrap: true,
              //             primary: false,
              //             itemCount: messages.length,
              //             itemBuilder: ((context, index) {
              //               return MessageCard(
              //                 index: index,
              //                 messages: messages,
              //               );
              //             })),
              //         SizedBox(
              //           height: 10,
              //         ),
              //         if (controller.isImageUploading.value &&
              //             controller.image.value != null)
              //           Container(
              //             height: 200,
              //             width: 200,
              //             decoration: BoxDecoration(
              //                 image: DecorationImage(
              //                     image: MemoryImage(controller.image.value!),
              //                     fit: BoxFit.cover),
              //                 borderRadius: BorderRadius.circular(30)),
              //             child: Center(child: CircularProgressIndicator()),
              //           )
              //       ],
              //     ),
              //   ),
              // );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }),
      ),

      // body: Obx(
      //   () => ListView.builder(
      //     itemCount: controller.messages.length,
      //     itemBuilder: (context, index) {
      //       return MessageCard(
      //         index: index,
      //       );
      //     },
      //   ),
      // ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 10, left: 18, right: 18),
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
                    Obx(() {
                      if (!controller.isCompleteAudioRecording.value &&
                          !controller.isRecording.value) {
                        return IconButton(
                            onPressed: () {
                              _openBottomSheet();
                            },
                            icon: Icon(Icons.add));
                      } else {
                        return Container(
                          width: 40,
                        );
                      }
                    }),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: controller.isRecording.value
                              ? Border.all(color: Colors.transparent)
                              : Border.all(color: Colors.grey),
                          color: controller.isRecording.value
                              ? Colors.transparent
                              : Color(0xFFF9FAFB),
                        ),
                        child: controller.isCompleteAudioRecording.value
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(formatDuration(Duration(
                                      seconds: controller.seconds.value))),
                                  TextButton(
                                    onPressed: () {
                                      controller.isCompleteAudioRecording
                                          .value = false;
                                      controller.seconds.value = 0;
                                      controller.isRecording.value = false;
                                      File(controller.audioPath!).delete();
                                    },
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  )
                                ],
                              )
                            : controller.isRecording.value
                                ? controller.isLocked.value
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(formatDuration(Duration(
                                              seconds:
                                                  controller.seconds.value))),
                                        ],
                                      )
                                    : Container()
                                : TextFormField(
                                    focusNode: focusNode,
                                    // autofocus: true,
                                    controller: controller.messageController,
                                    decoration: InputDecoration(
                                        hintText: "Write a Message",
                                        border: InputBorder.none,
                                        suffix: IconButton(
                                            onPressed: () async {
                                              Workmanager().cancelAll();
                                              MainController mainController =
                                                  Get.find();
                                              print(controller.reply);
                                              String text = controller
                                                  .messageController.text;
                                              controller
                                                  .messageController.text = "";
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                              print(
                                                  "\n\n cache imagePath: ${controller.imagePath}");
                                              print(
                                                  "cache videoPath: ${controller.videoPath}");
                                              print(
                                                  "cache documentPath: ${controller.documentPath} \n\n");
                                              Map<String, dynamic> reply =
                                                  controller.reply.value;
                                              controller.reply.value = {};
                                              if (controller.imagePath !=
                                                  null) {
                                                print("image");
                                                controller.isImageUploading
                                                    .value = true;
                                                await Workmanager()
                                                    .registerOneOffTask(
                                                        Uuid().v1(),
                                                        Constants
                                                            .chatImageUpload,
                                                        constraints: Constraints(
                                                            networkType:
                                                                NetworkType
                                                                    .connected),
                                                        inputData: {
                                                      "imagePath":
                                                          controller.imagePath,
                                                      "text": text,
                                                      "uid": mainController
                                                          .currentUser!.uid
                                                    }).whenComplete(() {
                                                  print("jio");
                                                  controller.isImageUploading
                                                      .value = false;
                                                  controller.image.value = null;
                                                  controller.imagePath = null;
                                                });
                                              } else if (controller.videoPath !=
                                                  null) {
                                                controller.video.value = null;
                                                print("video");
                                                await Workmanager()
                                                    .registerOneOffTask(
                                                        Uuid().v1(),
                                                        Constants
                                                            .chatVideoUpload,
                                                        constraints: Constraints(
                                                            networkType:
                                                                NetworkType
                                                                    .connected),
                                                        inputData: {
                                                      "videoPath":
                                                          controller.videoPath,
                                                      "text": text,
                                                      "uid": mainController
                                                          .currentUser!.uid
                                                    });
                                                controller.videoPath = null;
                                              } else if (controller
                                                      .documentPath !=
                                                  null) {
                                                print("document");
                                                controller.document.value =
                                                    null;

                                                await Workmanager()
                                                    .registerOneOffTask(
                                                        Uuid().v1(),
                                                        Constants
                                                            .chatDocumentUpload,
                                                        constraints: Constraints(
                                                            networkType:
                                                                NetworkType
                                                                    .connected),
                                                        inputData: {
                                                      "documentPath": controller
                                                          .documentPath,
                                                      "text": text,
                                                      "uid": mainController
                                                          .currentUser!.uid
                                                    });
                                                controller.documentPath = null;
                                                print("Hey");
                                              } else {
                                                print("text");
                                                final DatabaseReference
                                                    databaseReference =
                                                    FirebaseDatabase.instance
                                                        .ref()
                                                        .child(
                                                            "communityChats/chapterId/messages");
                                                DatabaseReference newMessage =
                                                    await databaseReference
                                                        .push();
                                                String messageId =
                                                    newMessage.key!;
                                                DateTime time = DateTime.now();
                                                int epochTime =
                                                    time.millisecondsSinceEpoch;
                                                Map<String, dynamic>
                                                    messageJson = {
                                                  "from": mainController
                                                      .currentUser!.uid,
                                                  "messageId": messageId,
                                                  "text": text,
                                                  "time": epochTime,
                                                  "type": "TEXT"
                                                };
                                                print("Json Form text");

                                                await newMessage
                                                    .set(messageJson);
                                              }
                                              // String? imageUrl = null;
                                              // String? documentUrl = null;
                                              // String? videoUrl = null;
                                              // if (controller.image.value !=
                                              //     null) {
                                              //   // imageUrl = controller.imageUrl!;
                                              //   String uid = Uuid().v1();
                                              //   imageUrl = await StorageMethods
                                              //       .uploadImageToStorage(
                                              //           'chat/image',
                                              //           uid,
                                              //           controller
                                              //               .image.value!);
                                              // }
                                              // if (controller.video.value !=
                                              //     null) {
                                              //   print("hi");
                                              //   String uid = Uuid().v1();
                                              //   videoUrl = await StorageMethods
                                              //       .uploadImageToStorage(
                                              //           'chat/video',
                                              //           uid,
                                              //           controller
                                              //               .video.value!);
                                              //   print("video url: $videoUrl");
                                              // }
                                              // if (controller.document.value !=
                                              //     null) {
                                              //   String uid = Uuid().v1();
                                              //   documentUrl =
                                              //       await StorageMethods
                                              //           .uploadDocument(
                                              //               'chat/document',
                                              //               uid,
                                              //               controller.document
                                              //                   .value!);
                                              // }
                                              // controller.messages.add(RxMap({
                                              //   'profileUrl':
                                              //       'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y3VzdG9tZXIlMjBwcm9maWxlfGVufDB8fDB8fHww&w=1000&q=80',
                                              //   'name': 'Pankaj',
                                              //   'imageUrl': imageUrl,
                                              //   'videoUrl': videoUrl,
                                              //   'documentUrl': documentUrl,
                                              //   'textMessage': controller
                                              //       .messageController.text,
                                              //   'repliedMessage':
                                              //       controller.reply["name"] ==
                                              //               null
                                              //           ? null
                                              //           : reply,
                                              //   'date': DateTime.now(),
                                              //   'prevDate': DateTime.now()
                                              //       .subtract(
                                              //           Duration(minutes: 2)),
                                              //   'owner': true,
                                              //   "isSelected": false
                                              // }));
                                              // print("message send");
                                              // controller.image.value = null;
                                              // controller.video.value = null;
                                              // controller.document.value = null;
                                              // controller.reply.value = {};
                                            },
                                            icon: Icon(Icons.send))),
                                    style: TextStyle(fontSize: 14),
                                  ),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    RecordButton(controller: controller.animationController),
                    // GestureDetector(
                    //   onTap: () async {
                    //     if (controller.isCompleteAudioRecording.value) {
                    //       String filename = recordFilePath!.split('/').last;
                    //       Duration audioLen =
                    //           controller.end!.difference(controller.start!);
                    //       int audioLength = audioLen.inMilliseconds;
                    //       controller.isCompleteAudioRecording.value = false;
                    //       controller.isRecording.value = false;
                    //       await Workmanager().registerOneOffTask(
                    //           Uuid().v1(), Constants.chatAudioUpload,
                    //           constraints: Constraints(
                    //               networkType: NetworkType.connected),
                    //           inputData: {
                    //             "audioPath": recordFilePath,
                    //             "audioLen": audioLength
                    //           });
                    //       // print("audio path: ${recordFilePath}");
                    //       // File file = File(recordFilePath!);
                    //       // print((await file.length()).toString());
                    //       // String uid = Uuid().v1();
                    //       // Duration audioLen =
                    //       //     controller.end!.difference(controller.start!);
                    //       // String audioMessageUrl =
                    //       //     await StorageMethods.uploadDocument(
                    //       //         'chat/audio', uid, file);
                    //       // print("audio Message Url: $audioMessageUrl");
                    //       // controller.messages.add(RxMap({
                    //       //   'profileUrl':
                    //       //       'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y3VzdG9tZXIlMjBwcm9maWxlfGVufDB8fDB8fHww&w=1000&q=80',
                    //       //   'name': 'Pankaj',
                    //       //   'imageUrl': null,
                    //       //   'documentUrl': null,
                    //       //   'audioMessageUrl': audioMessageUrl,
                    //       //   'audioLen': audioLen,
                    //       //   'textMessage': controller.messageController.text,
                    //       //   'repliedMessage': null,
                    //       //   'date': DateTime.now(),
                    //       //   'prevDate':
                    //       //       DateTime.now().subtract(Duration(minutes: 2)),
                    //       //   'owner': true,
                    //       //   "isSelected": false
                    //       // }));
                    //     }
                    //   },
                    //   onLongPress: () async {
                    //     startRecord();
                    //   },
                    //   onLongPressEnd: (details) {
                    //     stopRecord();
                    //   },
                    //   child: Container(
                    //       padding: EdgeInsets.all(8.86),
                    //       // margin: EdgeInsets.symmetric(horizontal: 4),
                    //       height: 40.45459,
                    //       width: 40.45459,
                    //       decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(30),
                    //           color: Color(0xFF7B61FF)),
                    //       child: controller.isCompleteAudioRecording.value
                    //           ? Icon(
                    //               Icons.send,
                    //               color: Colors.white,
                    //             )
                    //           : controller.isRecording.value
                    //               ? Icon(
                    //                   Icons.stop,
                    //                   color: Colors.red,
                    //                 )
                    //               : Container(
                    //                 height: 22.73725,
                    //                 width: 22.73725,
                    //                   child: SvgPicture.asset(
                    //                     "assets/images/microphone-2.svg",
                    //                     fit: BoxFit.contain,
                    //                   ),
                    //                 )),
                    // ),
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
