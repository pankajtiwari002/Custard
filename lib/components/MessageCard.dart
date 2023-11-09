import 'package:custard_flutter/controllers/DiscussionController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MessageCard extends StatelessWidget {
  final int index;

  MessageCard({
    required this.index,
  });

  DiscussionController controller = Get.find();

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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!controller.messages[index]["owner"])
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    controller.messages[index]["name"],
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
                            if (controller.messages[index]["repliedMessage"] !=
                                null && controller.messages[index]["repliedMessage"] !={})
                              Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 7, horizontal: 10),
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: !controller.messages[index]["owner"]
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
                                                  controller.messages[index]["repliedMessage"]
                                                      ["profileUrl"]),
                                              radius: 14),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            controller.messages[index]["repliedMessage"]["name"].toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF090B0E),
                                              fontSize: 12,
                                              fontFamily: 'Gilroy',
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.20,
                                            ),
                                          ),
                                        ]),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Text(
                                          controller.messages[index]["repliedMessage"]
                                              ["textMessage"].toString(),
                                          style: TextStyle(
                                            color: Color(0xFF090B0E),
                                            fontSize: 12,
                                            fontFamily: 'Gilroy',
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.20,
                                          ),
                                        ),
                                      ])),
                            if (controller.messages[index]["imageUrl"] != null)
                              Container(
                                width: double.infinity,
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage(controller
                                        .messages[index]["imageUrl"]!),
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              controller.messages[index]["textMessage"],
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
                                      borderRadius: BorderRadius.circular(30)),
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
                                      borderRadius: BorderRadius.circular(30)),
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
