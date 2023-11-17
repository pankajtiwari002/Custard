import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:custard_flutter/controllers/DiscussionController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polls/flutter_polls.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';

class MessageCard extends StatelessWidget {
  final int index;

  MessageCard({
    required this.index,
  });

  DiscussionController controller = Get.find();

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
  // String getTimeDifference() {
  //   Duration difference = date.difference(prevDate);
  //   return difference.inMinutes.toString();
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Obx(() => InkWell(
          onLongPress: () {
            if (controller.messages[index]['isSelected']) {
              controller.messages[index]['isSelected'] = false;
              controller.totalSelected.value =
                  controller.totalSelected.value - 1;
            } else {
              controller.messages[index]['isSelected'] = true;
              controller.totalSelected.value =
                  controller.totalSelected.value + 1;
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: controller.messages[index]["isSelected"]
                  ? Color(0x38FFB661)
                  : Colors.transparent,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                controller.messages[index]["prevDate"] == null ||
                        (DateFormat.yMMMd().format(
                                controller.messages[index]["prevDate"]!) !=
                            DateFormat.yMMMd()
                                .format(controller.messages[index]["date"]))
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Expanded(child: Divider()),
                            Text(
                              DateFormat.yMMMd()
                                  .format(controller.messages[index]["date"]),
                              style: TextStyle(
                                color: Color(0xFF909DAD),
                                fontSize: 12,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w500,
                                height: 0.11,
                              ),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                      )
                    : Container(),
                Row(
                  mainAxisAlignment: controller.messages[index]["owner"]
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!controller.messages[index]["owner"])
                      Padding(
                        padding: const EdgeInsets.only(right: 10, left: 8),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              controller.messages[index]["profileUrl"]),
                        ),
                      ),
                    GestureDetector(
                      onHorizontalDragEnd: (details) {
                        print(details.primaryVelocity.toString());
                        if (details.primaryVelocity! > 1000.0) {
                          controller.reply.value = {
                            "profileUrl": controller.messages[index]
                                ["profileUrl"],
                            "name": controller.messages[index]["name"],
                            "textMessage": controller.messages[index]
                                ["textMessage"],
                          };
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        width: size.width - 100,
                        decoration: BoxDecoration(
                          color: controller.messages[index]["owner"]
                              ? Color(0xFFF2EFFF)
                              : Color(0xFFF7F9FC),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: controller.messages[index]['documentUrl'] != null ?
                        Row(
                          children: [
                            IconButton(onPressed: () async{
                              downloadAndOpenPdf(controller.messages[index]['documentUrl']);
                            }, icon: Icon(Icons.picture_as_pdf,color: Colors.orange,)),
                            Text('pdf name')
                          ],
                        )
                        : controller.messages[index]['polls'] != null
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.messages[index]['polls']
                                        ['question'],
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
                                      itemCount: controller
                                          .messages[index]['polls']['options']
                                          .length,
                                      itemBuilder: (context, ind) {
                                        final ele = controller.messages[index]
                                            ['polls']['options'][ind];
                                        return Obx(() => Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ele['uid'].contains('abcd')
                                                    ? IconButton(
                                                        onPressed: () {},
                                                        icon: Icon(
                                                          Icons.check_circle,
                                                          color:
                                                              Color(0xFF7B61FF),
                                                        ))
                                                    : IconButton(
                                                        onPressed: () {
                                                          print(
                                                              "length : ${ele['uid'].length}");
                                                          ele['uid']
                                                              .add('abcd'.obs);
                                                          controller.messages[
                                                                      index]
                                                                  ['polls']
                                                              ['total']++;
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
                                                          Text(
                                                              '${ele['uid'].length}')
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
                                                        value: ele['uid']
                                                                .contains(
                                                                    'abcd')
                                                            ? ele['uid'].value
                                                                    .length /
                                                                controller
                                                                    .messages[
                                                                        index]['polls'][
                                                                        'total']
                                                                    .value
                                                            : 0,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ));
                                      }),
                                ],
                              )
                            : controller.messages[index]['audioMessageUrl'] !=
                                    null
                                ? Row(
                                    children: [
                                      Obx(
                                        () => IconButton(
                                            onPressed: () async {
                                              final player = AudioPlayer(
                                                  playerId: index.toString());
                                              if (controller
                                                  .isRecordingPlay.value) {
                                                print("hello");
                                                await player.pause();
                                                controller.isRecordingPlay
                                                    .value = false;
                                              } else {
                                                player
                                                    .play(UrlSource(controller
                                                            .messages[index]
                                                        ['audioMessageUrl']))
                                                    .whenComplete(() {
                                                  // controller.isRecordingPlay.value =
                                                  //     false;
                                                });
                                                controller.isRecordingPlay
                                                    .value = true;
                                              }
                                            },
                                            icon:
                                                controller.isRecordingPlay.value
                                                    ? Icon(Icons.pause)
                                                    : Icon(Icons.play_arrow)),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0),
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            alignment: Alignment.center,
                                            children: [
                                              LinearProgressIndicator(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                minHeight: 5,
                                                backgroundColor: Colors.grey,
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                        Color(0xFF7B61FF)),
                                                value: 0.5,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (!controller.messages[index]["owner"])
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              controller.messages[index]
                                                  ["name"],
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: Color(0xFF090B0E),
                                                fontSize: 14,
                                                fontFamily: 'Gilroy',
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.20,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 16,
                                            ),
                                          ],
                                        ),
                                      if (controller.messages[index]
                                                  ["repliedMessage"] !=
                                              null &&
                                          controller.messages[index]
                                                  ["repliedMessage"] !=
                                              {})
                                        Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 7, horizontal: 10),
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: !controller.messages[index]
                                                      ["owner"]
                                                  ? Color(0xFFF2EFFF)
                                                  : Color(0xFFF7F9FC),
                                            ),
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(children: [
                                                    CircleAvatar(
                                                        backgroundImage: NetworkImage(
                                                            controller.messages[
                                                                        index][
                                                                    "repliedMessage"]
                                                                ["profileUrl"]),
                                                        radius: 14),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      controller.messages[index]
                                                              ["repliedMessage"]
                                                              ["name"]
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF090B0E),
                                                        fontSize: 12,
                                                        fontFamily: 'Gilroy',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        letterSpacing: 0.20,
                                                      ),
                                                    ),
                                                  ]),
                                                  SizedBox(
                                                    height: 6,
                                                  ),
                                                  Text(
                                                    controller.messages[index]
                                                            ["repliedMessage"]
                                                            ["textMessage"]
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: Color(0xFF090B0E),
                                                      fontSize: 12,
                                                      fontFamily: 'Gilroy',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      letterSpacing: 0.20,
                                                    ),
                                                  ),
                                                ])),
                                      if (controller.messages[index]
                                              ["imageUrl"] !=
                                          null)
                                        Container(
                                          width: double.infinity,
                                          height: 200,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  controller.messages[index]
                                                      ["imageUrl"]!),
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                        ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        controller.messages[index]
                                            ["textMessage"],
                                        style: TextStyle(
                                          color: Color(0xFF090B0E),
                                          fontSize: 14,
                                          fontFamily: 'Gilroy',
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.20,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Chip(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                            backgroundColor: Color(0xFFD6CEFF),
                                            label: const Row(
                                              children: [
                                                Text(
                                                  '😊',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontFamily: 'Gilroy',
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.20,
                                                  ),
                                                ),
                                                Text(
                                                  ' 5',
                                                  style: TextStyle(
                                                    color: Color(0xFF7B61FF),
                                                    fontSize: 14,
                                                    fontFamily: 'Gilroy',
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Chip(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                            backgroundColor: Color(0xFFD6CEFF),
                                            label: const Row(
                                              children: [
                                                Text(
                                                  '🤯',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontFamily: 'Gilroy',
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.20,
                                                  ),
                                                ),
                                                Text(
                                                  ' 5',
                                                  style: TextStyle(
                                                    color: Color(0xFF7B61FF),
                                                    fontSize: 14,
                                                    fontFamily: 'Gilroy',
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            '01:50 PM',
                                            style: TextStyle(
                                              color: Color(0xFF909DAD),
                                              fontSize: 12,
                                              fontFamily: 'Gilroy',
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.20,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                      ),
                    ),
                    if (controller.messages[index]["owner"])
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 8),
                        // child: CircleAvatar(
                        //   backgroundImage: NetworkImage(profileUrl),
                        // ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
