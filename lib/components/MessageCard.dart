import 'dart:ffi' as ff;
import 'dart:io';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custard_flutter/controllers/DiscussionController.dart';
import 'package:custard_flutter/controllers/MessageCardController.dart';
import 'package:custard_flutter/view/VideoPlayerScreen.dart';
import 'package:custard_flutter/view/ViewPhotoScreen.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:emoji_selector/emoji_selector.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_polls/flutter_polls.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:voice_message_package/voice_message_package.dart';

import '../Global.dart';
import '../controllers/MainController.dart';
import '../data/models/user.dart';
import '../repo/FirestoreMethods.dart';

class MessageCard extends StatelessWidget {
  final int index;
  List<dynamic> messages;
  late AudioPlayer player;
  MessageCardController messageCardController = MessageCardController();
  MainController mainController = Get.find();
  MessageCard({required this.index, required this.messages}) {
    messageCardController.isLoading.value = true;
    player = AudioPlayer(playerId: messages[index].value["messageId"]);
    print(messages[index].value["from"]);
    messageCardController.initUser(messages[index].value["from"]);
  }

  TextEditingController textEditingController = TextEditingController();

  DiscussionController controller = Get.find();
  RxList<User> users = RxList();

  Future<void> extractUser(String key) async {
    users = RxList();
    print(messages[index].value["reactions"]['uids']);
    messages[index].value["reactions"]['uids'].forEach((k, val) async {
      print(val['emoji']);
      if (val['emoji'] == key) {
        Map<String, dynamic> json =
            await FirestoreMethods().getData("users", val['uid']);
        User user = User.fromSnap(json);
        // print("Goku");
        print(user);
        users.add(user);
      }
    });
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    // String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Future<Uint8List?> _generateThumbnail(String videoUrl) async {
    final thumbnail = await VideoThumbnail.thumbnailData(
      video: videoUrl,
      imageFormat: ImageFormat.JPEG,
      quality: 50,
    );

    return thumbnail;
  }

  double calculatePercentage(Duration currentDuration, Duration totalDuration) {
    if (totalDuration.inSeconds == 0) {
      // Avoid division by zero
      return 0.0;
    }

    double currentSeconds = currentDuration.inMicroseconds.toDouble();
    double totalSeconds = totalDuration.inMicroseconds.toDouble();
    print("currentSecond: $currentSeconds");
    print("totalSeconds: $totalSeconds");
    return (currentSeconds / totalSeconds);
  }

  DateTime convertMillisecondsToDateTime(int millisecondsSinceEpoch) {
    return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  }

  Future<void> downloadAndOpenPdf(String pdfUrl) async {
    try {
      final response = await http.get(Uri.parse(pdfUrl));

      if (response.statusCode == 200) {
        final directory = Directory.systemTemp;
        final filePath = '${directory.path}/downloaded_pdf.pdf';

        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        OpenFilex.open(filePath);
      } else {
        // Handle error (e.g., show a snackbar)
        print('Failed to download PDF');
      }
    } catch (error) {
      // Handle error (e.g., show a snackbar)
      print('Error: $error');
    }
  }

  bool alreadyVoted(List list, String userId) {
    for (int i = 0; i < list.length; i++) {
      final uid = list[i]['uids'];
      if (uid != null && uid.contains(userId)) {
        print("userId: $userId");
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Obx(() => InkWell(
          onTap: () {
            Get.bottomSheet(Container(
              height: 380,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  )),
              child: EmojiSelector(
                columns: 8,
                onSelected: (emoji) async {
                  // print(emoji.char);
                  DatabaseReference ref = FirebaseDatabase.instance.ref().child(
                      "communityChats/chapterId/messages/${messages[index].value['messageId']}");
                  int val = messages[index].value["reactions"] != null
                      ? messages[index].value["reactions"]["${emoji.char}"] ?? 0
                      : 0;
                  int? val1 = -1;
                  String prevEmoji = "";
                  if (messages[index].value["reactions"] != null) {
                    messages[index]
                        .value["reactions"]["uids"]
                        .forEach((key, val) {
                      if (key == mainController.currentUser!.uid) {
                        val1 = messages[index].value["reactions"]
                                ["${val['emoji']}"] -
                            1;
                        prevEmoji = val["emoji"];
                      }
                    });
                  }
                  val++;
                  if (val1 != -1) {
                    if (val1 == 0) val1 = null;
                    await ref.update({
                      "reactions/uids/${mainController.currentUser!.uid}": {
                        "emoji": emoji.char,
                        "uid": mainController.currentUser!.uid
                      },
                      "reactions/${emoji.char}": val,
                      "reactions/$prevEmoji": val1,
                    });
                  } else {
                    await ref.update({
                      "reactions/uids/${mainController.currentUser!.uid}": {
                        "emoji": emoji.char,
                        "uid": mainController.currentUser!.uid
                      },
                      "reactions/${emoji.char}": val,
                    });
                  }
                  Navigator.of(context).pop(emoji);
                },
              ),
            ));
          },
          onLongPress: () {
            print("height: ${size.height}");
            print("width: ${size.width}");
            if (controller.selectedMessage
                .contains(messages[index].value["messageId"])) {
              controller.selectedMessage.removeWhere(
                  (e) => (e == messages[index].value["messageId"]));
              controller.totalSelected.value =
                  controller.totalSelected.value - 1;
            } else {
              controller.selectedMessage
                  .add(messages[index].value["messageId"]);
              controller.totalSelected.value =
                  controller.totalSelected.value + 1;
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: 7, horizontal: size.width * 0.042),
            decoration: BoxDecoration(
              color: controller.selectedMessage
                      .contains(messages[index].value["messageId"])
                  ? Color(0x38FFB661)
                  : Colors.transparent,
            ),
            child: Container(
              // margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              child: Row(
                mainAxisAlignment:
                    messages[index].value["from"] == mainController.currentUser!.uid
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!(messages[index].value['from'] ==
                      mainController.currentUser!.uid))
                    Padding(
                        padding: const EdgeInsets.only(right: 10, left: 8),
                        child: Obx(() {
                          if (messageCardController.isLoading.value) {
                            return CircleAvatar(
                              backgroundColor: Color(0XFF62c9d5),
                            );
                          } else {
                            return CircleAvatar(
                              backgroundImage: NetworkImage(
                                  messageCardController.user!.profilePic),
                            );
                          }
                        })),
                  Container(
                    padding: EdgeInsets.all(size.width * 0.037),
                    width: size.width * 0.765,
                    decoration: BoxDecoration(
                      color: messages[index].value["from"] ==
                              Global.currentUser!.uid
                          ? Color(0xFFF2EFFF)
                          : Color(0xFFF7F9FC),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: messages[index].value['type'] == "DOCUMENT"
                        ? Row(
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    downloadAndOpenPdf(
                                        messages[index].value["document"]);
                                  },
                                  icon: Icon(
                                    Icons.picture_as_pdf,
                                    color: Colors.orange,
                                  )),
                              Text('pdf name')
                            ],
                          )
                        : messages[index].value['type'] == "AUDIO"
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 50,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF7B61FF),
                                    ),
                                    child: SvgPicture.asset(
                                        "assets/images/microphone.svg"),
                                  ),
                                  // SizedBox(width: 10,),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: size.width * 0.55,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Obx(() => IconButton(
                                                  onPressed: () async {
                                                    if (controller
                                                                .recordingMessageId !=
                                                            messages[index]
                                                                    .value[
                                                                "messageId"] &&
                                                        controller
                                                                .recordingMessageId !=
                                                            "-1") {
                                                      return;
                                                    }

                                                    player.onPlayerStateChanged
                                                        .listen((event) {
                                                      controller.isRecordingPlay
                                                              .value =
                                                          (event ==
                                                              PlayerState
                                                                  .playing);
                                                      if (controller
                                                          .isRecordingPlay
                                                          .value) {
                                                        controller
                                                            .recordingMessageId
                                                            .value = messages[
                                                                index]
                                                            .value["messageId"];
                                                      } else {
                                                        // player.
                                                        print("HEY");
                                                        player.seek(Duration(
                                                            seconds: 0));
                                                        controller
                                                            .isRecordingPlay
                                                            .value = false;
                                                        controller
                                                            .recordingMessageId
                                                            .value = "-1";
                                                      }
                                                    });
                                                    if (controller
                                                        .isRecordingPlay
                                                        .value) {
                                                      print("hello");
                                                      if (player.state ==
                                                          PlayerState.playing) {
                                                        print("Jai Shee Ram");
                                                        await player.pause();
                                                      }
                                                      // controller
                                                      //     .recordingMessageId
                                                      //     .value = "-1";
                                                      // await player.pause();
                                                      // await player.stop();
                                                      // player.
                                                      // controller.isRecordingPlay
                                                      //     .value = false;
                                                    } else {
                                                      player.onPositionChanged
                                                          .listen((event) {
                                                        controller.audioListened
                                                            .value = event;
                                                      });
                                                      player.onPlayerComplete
                                                          .listen((event) {
                                                        controller.audioListened
                                                                .value =
                                                            Duration(
                                                                seconds: 0);
                                                        controller
                                                            .isRecordingPlay
                                                            .value = false;
                                                      });
                                                      // controller
                                                      //     .recordingMessageId
                                                      //     .value = messages[
                                                      //         index]
                                                      //     .value["messageId"];
                                                      player
                                                          .play(UrlSource(
                                                              messages[index]
                                                                      .value[
                                                                  "audio"]))
                                                          .whenComplete(() {
                                                        controller
                                                            .isRecordingPlay
                                                            .value = false;
                                                      });
                                                      controller.isRecordingPlay
                                                          .value = true;
                                                    }
                                                  },
                                                  icon: (!controller
                                                              .isRecordingPlay
                                                              .value ||
                                                          controller.recordingMessageId !=
                                                              messages[index]
                                                                      .value[
                                                                  "messageId"])
                                                      ? SvgPicture.asset(
                                                          "assets/images/play.svg")
                                                      : SvgPicture.asset(
                                                          "assets/images/pause.svg"),
                                                )),
                                            Obx(
                                              () => Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 0),
                                                  child: Stack(
                                                    clipBehavior: Clip.none,
                                                    alignment: Alignment.center,
                                                    children: [
                                                      LinearProgressIndicator(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        minHeight: 6,
                                                        backgroundColor:
                                                            Colors.grey,
                                                        valueColor:
                                                            AlwaysStoppedAnimation(
                                                                Color(
                                                                    0xFF7B61FF)),
                                                        value: controller
                                                                    .recordingMessageId ==
                                                                messages[
                                                                            index]
                                                                        .value[
                                                                    "messageId"]
                                                            ? calculatePercentage(
                                                                controller
                                                                    .audioListened
                                                                    .value,
                                                                Duration(
                                                                    milliseconds:
                                                                        messages[index]
                                                                            .value['audioLen']))
                                                            : 0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 9,
                                      ),
                                      Container(
                                        width: size.width * 0.55,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Obx(
                                              () => Text(
                                                controller.recordingMessageId !=
                                                        messages[index]
                                                            .value["messageId"]
                                                    ? "00:00"
                                                    : formatDuration(controller
                                                        .audioListened.value),
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  color: Color(0xFF546881),
                                                  fontSize: 14,
                                                  fontFamily: 'Gilroy',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              DateFormat.jm().format(
                                                  convertMillisecondsToDateTime(
                                                      messages[index]
                                                          .value['time'])),
                                              style: TextStyle(
                                                color: Color(0xFF909DAD),
                                                fontSize: 12,
                                                fontFamily: 'Gilroy',
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : messages[index].value['type'] == "POLLS"
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        messages[index].value['pollQuestion'],
                                        style: TextStyle(
                                          color: Color(0xFF090B0E),
                                          fontSize: 14,
                                          fontFamily: 'Gilroy',
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.20,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: messages[index]
                                              .value['pollOptions']
                                              .length,
                                          itemBuilder: (context, ind) {
                                            final ele = messages[index]
                                                .value['pollOptions'][ind];
                                            return Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                (ele['uids'] != null &&
                                                        ele['uids'].contains(
                                                            mainController
                                                                .currentUser!
                                                                .uid))
                                                    ? IconButton(
                                                        onPressed: () {
                                                          int total = messages[
                                                                  index]
                                                              .value['total'];
                                                          List<Object?> uids =
                                                              ele['uids']
                                                                  .toList();
                                                          uids.removeWhere(
                                                              (e) => (e ==
                                                                  mainController
                                                                      .currentUser!
                                                                      .uid));
                                                          total--;
                                                          1;
                                                          DatabaseReference
                                                              ref =
                                                              FirebaseDatabase
                                                                  .instance
                                                                  .ref()
                                                                  .child(
                                                                      "communityChats/chapterId/messages/${messages[index].value['messageId']}");
                                                          ref.update({
                                                            'total': total,
                                                            'pollOptions/$ind/uids':
                                                                uids
                                                          });
                                                        },
                                                        icon: Icon(
                                                          Icons.check_circle,
                                                          color:
                                                              Color(0xFF7B61FF),
                                                        ))
                                                    : IconButton(
                                                        onPressed: () {
                                                          int total = messages[
                                                                  index]
                                                              .value['total'];
                                                          List<Object?> uids =
                                                              ele['uids'] !=
                                                                      null
                                                                  ? ele['uids']
                                                                      .toList()
                                                                  : List.empty(
                                                                      growable:
                                                                          true);
                                                          // print(
                                                          //     "length : ${ele['uids'].length}");
                                                          if (messages[index]
                                                                  .value[
                                                              'MultipleOptions']) {
                                                            uids.add(
                                                                mainController
                                                                    .currentUser!
                                                                    .uid);
                                                            total++;
                                                          } else {
                                                            if (!alreadyVoted(
                                                                messages[index]
                                                                        .value[
                                                                    'pollOptions'],
                                                                mainController
                                                                    .currentUser!
                                                                    .uid)) {
                                                              uids.add(
                                                                  mainController
                                                                      .currentUser!
                                                                      .uid);
                                                              total++;
                                                              print("jkl");
                                                            } else {
                                                              return;
                                                            }
                                                          }
                                                          DatabaseReference
                                                              ref =
                                                              FirebaseDatabase
                                                                  .instance
                                                                  .ref()
                                                                  .child(
                                                                      "communityChats/chapterId/messages/${messages[index].value['messageId']}");
                                                          ref.update({
                                                            'total': total,
                                                            'pollOptions/$ind/uids':
                                                                uids
                                                          });
                                                        },
                                                        icon: Icon(Icons
                                                            .circle_outlined)),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 200,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(ele['text']),
                                                          if (alreadyVoted(
                                                              messages[index]
                                                                      .value[
                                                                  'pollOptions'],
                                                              mainController
                                                                  .currentUser!
                                                                  .uid))
                                                            ele['uids'] == null
                                                                ? Text('0')
                                                                : Text(ele[
                                                                        'uids']
                                                                    .length
                                                                    .toString()),
                                                          // Text(
                                                          //     '${ele['uids']}')
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 200,
                                                      child:
                                                          LinearProgressIndicator(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        minHeight: 5,
                                                        backgroundColor:
                                                            Colors.grey,
                                                        valueColor:
                                                            AlwaysStoppedAnimation(
                                                                Color(
                                                                    0xFF7B61FF)),
                                                        // value: ele['uids']
                                                        //         .contains(Global.currentUser!.uid)
                                                        //     ? ele['uids']
                                                        //             .value
                                                        //             .length /
                                                        //         controller
                                                        //             .messages[index]
                                                        //                 ['polls']
                                                        //                 ['total']
                                                        //             .value
                                                        //     : 0,
                                                        value: alreadyVoted(
                                                                messages[index]
                                                                        .value[
                                                                    'pollOptions'],
                                                                mainController
                                                                    .currentUser!
                                                                    .uid)
                                                            ? (ele['uids'] !=
                                                                    null)
                                                                ? ele['uids']
                                                                        .length /
                                                                    messages[index]
                                                                            .value[
                                                                        'total']
                                                                : 0
                                                            : 0,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                  ],
                                                )
                                              ],
                                            );
                                          }),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          DateFormat.jm().format(
                                              convertMillisecondsToDateTime(
                                                  messages[index]
                                                      .value['time'])),
                                          style: TextStyle(
                                            color: Color(0xFF909DAD),
                                            fontSize: 12,
                                            fontFamily: 'Gilroy',
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.20,
                                          ),
                                        ),
                                      ),
                                      if (!messages[index]
                                          .value['HideLiveResult'])
                                        Center(
                                          child: TextButton(
                                              onPressed: () {},
                                              child: Text(
                                                'View votes',
                                                style: TextStyle(
                                                  color: Color(0xFF7B61FF),
                                                  fontSize: 14,
                                                  fontFamily: 'Gilroy',
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.20,
                                                ),
                                              )),
                                        )
                                    ],
                                  )
                                : messages[index].value['type'] == "LOCATION"
                                    ? Container()
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (!(messages[index].value['from'] ==
                                              Global.currentUser!.uid))
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Obx(() {
                                                  if (messageCardController
                                                      .isLoading.value) {
                                                    return Container();
                                                  } else {
                                                    return Text(
                                                      messageCardController
                                                          .user.name,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xFF090B0E),
                                                        fontSize: 14,
                                                        fontFamily: 'Gilroy',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        letterSpacing: 0.20,
                                                      ),
                                                    );
                                                  }
                                                }),
                                                SizedBox(
                                                  height: 16,
                                                ),
                                              ],
                                            ),
                                          if (messages[index].value["type"] ==
                                              "IMAGE")
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(() => ViewPhotoScreen(
                                                    imageUrl: messages[index]
                                                        .value["image"]));
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                height: 200,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        messages[index]
                                                            .value["image"]!),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          if (messages[index].value["type"] ==
                                              "VIDEO")
                                            FutureBuilder(
                                              future: _generateThumbnail(
                                                  messages[index]
                                                      .value["video"]),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Container(height: 200);
                                                } else if (snapshot.hasError) {
                                                  return Text(
                                                      'Error loading thumbnail');
                                                } else if (snapshot.hasData) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Get.to(() =>
                                                          VideoPlayerScreen(
                                                            videoUrl: messages[
                                                                    index]
                                                                .value["video"],
                                                          ));
                                                    },
                                                    child: Container(
                                                      width: double.infinity,
                                                      height: 200,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        image: DecorationImage(
                                                          image: MemoryImage(
                                                              snapshot.data!),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Container(
                                                        // padding: EdgeInsets.all(5),
                                                        height: 40,
                                                        width: 40,
                                                        decoration: BoxDecoration(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.6),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30)),
                                                        child: Icon(
                                                          Icons.play_arrow,
                                                          size: 35,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  return Text(
                                                      'No thumbnail available');
                                                }
                                              },
                                            ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            messages[index].value['text'],
                                            style: TextStyle(
                                              color: Color(0xFF090B0E),
                                              fontSize: 14,
                                              fontFamily: 'Gilroy',
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.20,
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                // color: Colors.red,
                                                width: 210,
                                                child: GridView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemCount: messages[index]
                                                                    .value[
                                                                "reactions"] !=
                                                            null
                                                        ? messages[index]
                                                                .value[
                                                                    "reactions"]
                                                                .length -
                                                            1
                                                        : 0,
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 3,
                                                    ),
                                                    itemBuilder: ((context, ind) {
                                                      String key = messages[index]
                                                          .value['reactions']
                                                          .keys
                                                          .elementAt(ind + 1);
                                                      int value = messages[index]
                                                              .value['reactions']
                                                          [key];
                                                      return Container(
                                                        margin:
                                                            EdgeInsets.symmetric(
                                                                horizontal: 3,
                                                                vertical: 3),
                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            await extractUser(
                                                                key);
                                                            print("length: " +
                                                                users.length
                                                                    .toString());
                                                            Get.bottomSheet(
                                                                Container(
                                                              color: Colors.white,
                                                              height: 300,
                                                              child: Obx(() => ListView
                                                                  .builder(
                                                                      itemCount: users
                                                                          .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              i) {
                                                                        return ListTile(
                                                                          title: Text(
                                                                              users[i].name),
                                                                          leading:
                                                                              CircleAvatar(
                                                                            radius:
                                                                                20,
                                                                            backgroundImage:
                                                                                NetworkImage(users[i].profilePic),
                                                                          ),
                                                                        );
                                                                      })),
                                                            ));
                                                          },
                                                          child: Chip(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30)),
                                                            backgroundColor:
                                                                Color(0xFFD6CEFF),
                                                            label: Row(
                                                              children: [
                                                                Text(
                                                                  "$key",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: 12,
                                                                    fontFamily:
                                                                        'Gilroy',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    letterSpacing:
                                                                        0.20,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  ' $value',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xFF7B61FF),
                                                                    fontSize: 12,
                                                                    fontFamily:
                                                                        'Gilroy',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    letterSpacing:
                                                                        0.20,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    })),
                                              ),
                                              // SizedBox(
                                              //   width: 10,
                                              // ),
                                              // Spacer(),
                                              Text(
                                                DateFormat.jm().format(
                                                    convertMillisecondsToDateTime(
                                                        messages[index]
                                                            .value['time'])),
                                                style: TextStyle(
                                                  color: Color(0xFF909DAD),
                                                  fontSize: 12,
                                                  fontFamily: 'Gilroy',
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
  // String getTimeDifference() {
  //   Duration difference = date.difference(prevDate);
  //   return difference.inMinutes.toString();
  // }

  // @override
  // Widget build(BuildContext context) {
  //   Size size = MediaQuery.of(context).size;
  //   return Obx(() => InkWell(
  //         onLongPress: () {
  //           if (controller.messages[index]['isSelected']) {
  //             controller.messages[index]['isSelected'] = false;
  //             controller.totalSelected.value =
  //                 controller.totalSelected.value - 1;
  //           } else {
  //             controller.messages[index]['isSelected'] = true;
  //             controller.totalSelected.value =
  //                 controller.totalSelected.value + 1;
  //           }
  //         },
  //         child: Container(
  //           padding: EdgeInsets.symmetric(vertical: 15),
  //           decoration: BoxDecoration(
  //             color: controller.messages[index]["isSelected"]
  //                 ? Color(0x38FFB661)
  //                 : Colors.transparent,
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               controller.messages[index]["prevDate"] == null ||
  //                       (DateFormat.yMMMd().format(
  //                               controller.messages[index]["prevDate"]!) !=
  //                           DateFormat.yMMMd()
  //                               .format(controller.messages[index]["date"]))
  //                   ? Padding(
  //                       padding: const EdgeInsets.symmetric(vertical: 10),
  //                       child: Row(
  //                         children: [
  //                           Expanded(child: Divider()),
  //                           Text(
  //                             DateFormat.yMMMd()
  //                                 .format(controller.messages[index]["date"]),
  //                             style: TextStyle(
  //                               color: Color(0xFF909DAD),
  //                               fontSize: 12,
  //                               fontFamily: 'Gilroy',
  //                               fontWeight: FontWeight.w500,
  //                               height: 0.11,
  //                             ),
  //                           ),
  //                           Expanded(child: Divider()),
  //                         ],
  //                       ),
  //                     )
  //                   : Container(),
  //               Row(
  //                 mainAxisAlignment: controller.messages[index]["owner"]
  //                     ? MainAxisAlignment.end
  //                     : MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   if (!controller.messages[index]["owner"])
  //                     Padding(
  //                       padding: const EdgeInsets.only(right: 10, left: 8),
  //                       child: CircleAvatar(
  //                         backgroundImage: NetworkImage(
  //                             controller.messages[index]["profileUrl"]),
  //                       ),
  //                     ),
  //                   GestureDetector(
  //                     onHorizontalDragEnd: (details) {
  //                       print(details.primaryVelocity.toString());
  //                       if (details.primaryVelocity! > 1000.0) {
  //                         controller.reply.value = {
  //                           "profileUrl": controller.messages[index]
  //                               ["profileUrl"],
  //                           "name": controller.messages[index]["name"],
  //                           "textMessage": controller.messages[index]
  //                               ["textMessage"],
  //                         };
  //                       }
  //                     },
  //                     child: Container(
  //                       padding: EdgeInsets.all(8),
  //                       width: size.width - 100,
  //                       decoration: BoxDecoration(
  //                         color: controller.messages[index]["owner"]
  //                             ? Color(0xFFF2EFFF)
  //                             : Color(0xFFF7F9FC),
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                       child: controller.messages[index]['documentUrl'] != null
  //                           ? Row(
  //                               children: [
  //                                 IconButton(
  //                                     onPressed: () async {
  //                                       downloadAndOpenPdf(controller
  //                                           .messages[index]['documentUrl']);
  //                                     },
  //                                     icon: Icon(
  //                                       Icons.picture_as_pdf,
  //                                       color: Colors.orange,
  //                                     )),
  //                                 Text('pdf name')
  //                               ],
  //                             )
  //                           : controller.messages[index]['polls'] != null
  //                               ? Column(
  //                                   mainAxisSize: MainAxisSize.min,
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.start,
  //                                   children: [
  //                                     Text(
  //                                       controller.messages[index]['polls']
  //                                           ['question'],
  //                                       style: TextStyle(
  //                                         color: Color(0xFF090B0E),
  //                                         fontSize: 14,
  //                                         fontFamily: 'Gilroy',
  //                                         fontWeight: FontWeight.w600,
  //                                         letterSpacing: 0.20,
  //                                       ),
  //                                     ),
  //                                     SizedBox(
  //                                       height: 10,
  //                                     ),
  //                                     ListView.builder(
  //                                         shrinkWrap: true,
  //                                         itemCount: controller
  //                                             .messages[index]['polls']
  //                                                 ['options']
  //                                             .length,
  //                                         itemBuilder: (context, ind) {
  //                                           final ele =
  //                                               controller.messages[index]
  //                                                   ['polls']['options'][ind];
  //                                           return Obx(() => Row(
  //                                                 mainAxisSize:
  //                                                     MainAxisSize.min,
  //                                                 children: [
  //                                                   ele['uid'].contains(Global.currentUser!.uid)
  //                                                       ? IconButton(
  //                                                           onPressed: () {
  //                                                             ele['uid'].removeWhere(
  //                                                                 (e) => (e ==
  //                                                                     Global.currentUser!.uid));
  //                                                             controller.messages[
  //                                                                         index]
  //                                                                     ['polls']
  //                                                                 ['total']--;
  //                                                           },
  //                                                           icon: Icon(
  //                                                             Icons
  //                                                                 .check_circle,
  //                                                             color: Color(
  //                                                                 0xFF7B61FF),
  //                                                           ))
  //                                                       : IconButton(
  //                                                           onPressed: () {
  //                                                             print(
  //                                                                 "length : ${ele['uid'].length}");
  //                                                             if (controller.messages[
  //                                                                         index]
  //                                                                     ['polls'][
  //                                                                 'MultipleOptions']) {
  //                                                               ele['uid'].add(
  //                                                                   Global.currentUser!.uid.obs);
  //                                                               controller.messages[
  //                                                                           index]
  //                                                                       [
  //                                                                       'polls']
  //                                                                   ['total']++;
  //                                                             } else {
  //                                                               if (!alreadyVoted(
  //                                                                   controller.messages[index]
  //                                                                           [
  //                                                                           'polls']
  //                                                                       [
  //                                                                       'options'],
  //                                                                   Global.currentUser!.uid)) {
  //                                                                 ele['uid'].add(
  //                                                                     Global.currentUser!.uid
  //                                                                         .obs);
  //                                                                 controller.messages[
  //                                                                             index]
  //                                                                         [
  //                                                                         'polls']
  //                                                                     [
  //                                                                     'total']++;
  //                                                               }
  //                                                             }
  //                                                           },
  //                                                           icon: Icon(Icons
  //                                                               .circle_outlined)),
  //                                                   SizedBox(
  //                                                     width: 10,
  //                                                   ),
  //                                                   Column(
  //                                                     mainAxisSize:
  //                                                         MainAxisSize.min,
  //                                                     crossAxisAlignment:
  //                                                         CrossAxisAlignment
  //                                                             .start,
  //                                                     children: [
  //                                                       Container(
  //                                                         width: 200,
  //                                                         child: Row(
  //                                                           mainAxisAlignment:
  //                                                               MainAxisAlignment
  //                                                                   .spaceBetween,
  //                                                           children: [
  //                                                             Text(ele['text']),
  //                                                             Text(
  //                                                                 '${ele['uid'].length}')
  //                                                           ],
  //                                                         ),
  //                                                       ),
  //                                                       Container(
  //                                                         width: 200,
  //                                                         child:
  //                                                             LinearProgressIndicator(
  //                                                           borderRadius:
  //                                                               BorderRadius
  //                                                                   .circular(
  //                                                                       15),
  //                                                           minHeight: 5,
  //                                                           backgroundColor:
  //                                                               Colors.grey,
  //                                                           valueColor:
  //                                                               AlwaysStoppedAnimation(
  //                                                                   Color(
  //                                                                       0xFF7B61FF)),
  //                                                           value: ele['uid']
  //                                                                   .contains(
  //                                                                       Global.currentUser!.uid)
  //                                                               ? ele['uid']
  //                                                                       .value
  //                                                                       .length /
  //                                                                   controller
  //                                                                       .messages[
  //                                                                           index]
  //                                                                           [
  //                                                                           'polls']
  //                                                                           [
  //                                                                           'total']
  //                                                                       .value
  //                                                               : 0,
  //                                                         ),
  //                                                       ),
  //                                                       SizedBox(
  //                                                         height: 5,
  //                                                       ),
  //                                                     ],
  //                                                   )
  //                                                 ],
  //                                               ));
  //                                         }),
  //                                     if (!controller.messages[index]['polls']
  //                                         ['HideLiveResult'])
  //                                       Center(
  //                                         child: TextButton(
  //                                             onPressed: () {},
  //                                             child: Text(
  //                                               'View votes',
  //                                               style: TextStyle(
  //                                                 color: Color(0xFF7B61FF),
  //                                                 fontSize: 14,
  //                                                 fontFamily: 'Gilroy',
  //                                                 fontWeight: FontWeight.w600,
  //                                                 letterSpacing: 0.20,
  //                                               ),
  //                                             )),
  //                                       )
  //                                   ],
  //                                 )
  //                               : controller.messages[index]
  //                                           ['audioMessageUrl'] !=
  //                                       null
  //                                   ? Row(
  //                                       children: [
  //                                         Obx(
  //                                           () => IconButton(
  //                                               onPressed: () async {
  //                                                 final player = AudioPlayer(
  //                                                     playerId:
  //                                                         index.toString());
  //                                                 player.onPlayerStateChanged
  //                                                     .listen((event) {
  //                                                   controller.isRecordingPlay.value = (event==PlayerState.playing);
  //                                                 });
  //                                                 if (controller
  //                                                     .isRecordingPlay.value) {
  //                                                   print("hello");
  //                                                   await player.pause();
  //                                                   // await player.stop();
  //                                                   // player.
  //                                                   controller.isRecordingPlay
  //                                                       .value = false;
  //                                                 } else {
  //                                                   player.onPositionChanged
  //                                                     .listen((event) {
  //                                                   controller.audioListened
  //                                                       .value = event;
  //                                                 });
  //                                                 player.onPlayerComplete
  //                                                     .listen((event) {
  //                                                   controller.audioListened
  //                                                           .value =
  //                                                       Duration(seconds: 0);
  //                                                   controller.isRecordingPlay
  //                                                       .value = false;
  //                                                 });
  //                                                   player
  //                                                       .play(UrlSource(controller
  //                                                               .messages[index]
  //                                                           [
  //                                                           'audioMessageUrl']))
  //                                                       .whenComplete(() {
  //                                                     // controller.isRecordingPlay.value =
  //                                                     //     false;
  //                                                   });
  //                                                   controller.isRecordingPlay
  //                                                       .value = true;
  //                                                 }
  //                                               },
  //                                               icon: controller
  //                                                       .isRecordingPlay.value
  //                                                   ? Icon(Icons.pause)
  //                                                   : Icon(Icons.play_arrow)),
  //                                         ),
  //                                         Expanded(
  //                                           child: Padding(
  //                                             padding:
  //                                                 const EdgeInsets.symmetric(
  //                                                     horizontal: 0),
  //                                             child: Stack(
  //                                               clipBehavior: Clip.none,
  //                                               alignment: Alignment.center,
  //                                               children: [
  //                                                 LinearProgressIndicator(
  //                                                   borderRadius:
  //                                                       BorderRadius.circular(
  //                                                           15),
  //                                                   minHeight: 5,
  //                                                   backgroundColor:
  //                                                       Colors.grey,
  //                                                   valueColor:
  //                                                       AlwaysStoppedAnimation(
  //                                                           Color(0xFF7B61FF)),
  //                                                   value: calculatePercentage(
  //                                                       controller.audioListened
  //                                                           .value,
  //                                                       controller
  //                                                               .messages[index]
  //                                                           ['audioLen']),
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ],
  //                                     )
  //                                   : Column(
  //                                       crossAxisAlignment:
  //                                           CrossAxisAlignment.start,
  //                                       children: [
  //                                         if (!controller.messages[index]
  //                                             ["owner"])
  //                                           Column(
  //                                             mainAxisSize: MainAxisSize.min,
  //                                             children: [
  //                                               Text(
  //                                                 controller.messages[index]
  //                                                     ["name"],
  //                                                 textAlign: TextAlign.center,
  //                                                 style: const TextStyle(
  //                                                   color: Color(0xFF090B0E),
  //                                                   fontSize: 14,
  //                                                   fontFamily: 'Gilroy',
  //                                                   fontWeight: FontWeight.w600,
  //                                                   letterSpacing: 0.20,
  //                                                 ),
  //                                               ),
  //                                               SizedBox(
  //                                                 height: 16,
  //                                               ),
  //                                             ],
  //                                           ),
  //                                         if (controller.messages[index]
  //                                                     ["repliedMessage"] !=
  //                                                 null &&
  //                                             controller.messages[index]
  //                                                     ["repliedMessage"] !=
  //                                                 {})
  //                                           Container(
  //                                               margin:
  //                                                   const EdgeInsets.symmetric(
  //                                                       vertical: 7,
  //                                                       horizontal: 10),
  //                                               padding: EdgeInsets.all(8),
  //                                               decoration: BoxDecoration(
  //                                                 borderRadius:
  //                                                     BorderRadius.circular(20),
  //                                                 color: !controller
  //                                                             .messages[index]
  //                                                         ["owner"]
  //                                                     ? Color(0xFFF2EFFF)
  //                                                     : Color(0xFFF7F9FC),
  //                                               ),
  //                                               child: Column(
  //                                                   mainAxisSize:
  //                                                       MainAxisSize.min,
  //                                                   crossAxisAlignment:
  //                                                       CrossAxisAlignment
  //                                                           .start,
  //                                                   children: [
  //                                                     Row(children: [
  //                                                       CircleAvatar(
  //                                                           backgroundImage: NetworkImage(
  //                                                               controller.messages[
  //                                                                           index]
  //                                                                       [
  //                                                                       "repliedMessage"]
  //                                                                   [
  //                                                                   "profileUrl"]),
  //                                                           radius: 14),
  //                                                       SizedBox(
  //                                                         width: 10,
  //                                                       ),
  //                                                       Text(
  //                                                         controller
  //                                                             .messages[index][
  //                                                                 "repliedMessage"]
  //                                                                 ["name"]
  //                                                             .toString(),
  //                                                         textAlign:
  //                                                             TextAlign.center,
  //                                                         style: TextStyle(
  //                                                           color: Color(
  //                                                               0xFF090B0E),
  //                                                           fontSize: 12,
  //                                                           fontFamily:
  //                                                               'Gilroy',
  //                                                           fontWeight:
  //                                                               FontWeight.w600,
  //                                                           letterSpacing: 0.20,
  //                                                         ),
  //                                                       ),
  //                                                     ]),
  //                                                     SizedBox(
  //                                                       height: 6,
  //                                                     ),
  //                                                     Text(
  //                                                       controller
  //                                                           .messages[index][
  //                                                               "repliedMessage"]
  //                                                               ["textMessage"]
  //                                                           .toString(),
  //                                                       style: TextStyle(
  //                                                         color:
  //                                                             Color(0xFF090B0E),
  //                                                         fontSize: 12,
  //                                                         fontFamily: 'Gilroy',
  //                                                         fontWeight:
  //                                                             FontWeight.w500,
  //                                                         letterSpacing: 0.20,
  //                                                       ),
  //                                                     ),
  //                                                   ])),
  //                                         if (controller.messages[index]
  //                                                 ["imageUrl"] !=
  //                                             null)
  //                                           Container(
  //                                             width: double.infinity,
  //                                             height: 200,
  //                                             decoration: BoxDecoration(
  //                                               borderRadius:
  //                                                   BorderRadius.circular(10),
  //                                               image: DecorationImage(
  //                                                 image: NetworkImage(
  //                                                     controller.messages[index]
  //                                                         ["imageUrl"]!),
  //                                                 fit: BoxFit.fitWidth,
  //                                               ),
  //                                             ),
  //                                           ),
  //                                         SizedBox(
  //                                           height: 8,
  //                                         ),
  //                                         Text(
  //                                           controller.messages[index]
  //                                               ["textMessage"],
  //                                           style: TextStyle(
  //                                             color: Color(0xFF090B0E),
  //                                             fontSize: 14,
  //                                             fontFamily: 'Gilroy',
  //                                             fontWeight: FontWeight.w500,
  //                                             letterSpacing: 0.20,
  //                                           ),
  //                                         ),
  //                                         Row(
  //                                           children: [
  //                                             Chip(
  //                                               shape: RoundedRectangleBorder(
  //                                                   borderRadius:
  //                                                       BorderRadius.circular(
  //                                                           30)),
  //                                               backgroundColor:
  //                                                   Color(0xFFD6CEFF),
  //                                               label: const Row(
  //                                                 children: [
  //                                                   Text(
  //                                                     '😊',
  //                                                     style: TextStyle(
  //                                                       color: Colors.white,
  //                                                       fontSize: 14,
  //                                                       fontFamily: 'Gilroy',
  //                                                       fontWeight:
  //                                                           FontWeight.w500,
  //                                                       letterSpacing: 0.20,
  //                                                     ),
  //                                                   ),
  //                                                   Text(
  //                                                     ' 5',
  //                                                     style: TextStyle(
  //                                                       color:
  //                                                           Color(0xFF7B61FF),
  //                                                       fontSize: 14,
  //                                                       fontFamily: 'Gilroy',
  //                                                       fontWeight:
  //                                                           FontWeight.w500,
  //                                                       letterSpacing: 0.20,
  //                                                     ),
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                             ),
  //                                             SizedBox(
  //                                               width: 10,
  //                                             ),
  //                                             Chip(
  //                                               shape: RoundedRectangleBorder(
  //                                                   borderRadius:
  //                                                       BorderRadius.circular(
  //                                                           30)),
  //                                               backgroundColor:
  //                                                   Color(0xFFD6CEFF),
  //                                               label: const Row(
  //                                                 children: [
  //                                                   Text(
  //                                                     '🤯',
  //                                                     style: TextStyle(
  //                                                       color: Colors.white,
  //                                                       fontSize: 14,
  //                                                       fontFamily: 'Gilroy',
  //                                                       fontWeight:
  //                                                           FontWeight.w500,
  //                                                       letterSpacing: 0.20,
  //                                                     ),
  //                                                   ),
  //                                                   Text(
  //                                                     ' 5',
  //                                                     style: TextStyle(
  //                                                       color:
  //                                                           Color(0xFF7B61FF),
  //                                                       fontSize: 14,
  //                                                       fontFamily: 'Gilroy',
  //                                                       fontWeight:
  //                                                           FontWeight.w500,
  //                                                       letterSpacing: 0.20,
  //                                                     ),
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                             ),
  //                                             Spacer(),
  //                                             Text(
  //                                               '01:50 PM',
  //                                               style: TextStyle(
  //                                                 color: Color(0xFF909DAD),
  //                                                 fontSize: 12,
  //                                                 fontFamily: 'Gilroy',
  //                                                 fontWeight: FontWeight.w500,
  //                                                 letterSpacing: 0.20,
  //                                               ),
  //                                             ),
  //                                           ],
  //                                         )
  //                                       ],
  //                                     ),
  //                     ),
  //                   ),
  //                   if (controller.messages[index]["owner"])
  //                     Padding(
  //                       padding: const EdgeInsets.only(left: 10, right: 8),
  //                       // child: CircleAvatar(
  //                       //   backgroundImage: NetworkImage(profileUrl),
  //                       // ),
  //                     ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ));
  // }
}

class CustomView extends EmojiPickerBuilder {
  CustomView(Config config, EmojiViewState state) : super(config, state);

  @override
  _CustomViewState createState() => _CustomViewState();
}

class _CustomViewState extends State<CustomView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // Access widget.config and widget.state
    return Container();
  }
}
