import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custard_flutter/controllers/EventCalendarController.dart';
import 'package:custard_flutter/controllers/MainController.dart';
import 'package:custard_flutter/view/ManageEventScreen.dart';
import 'package:custard_flutter/view/RegisterNowScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class EventCalendarScreen extends StatefulWidget {
  EventCalendarScreen({super.key});

  @override
  State<EventCalendarScreen> createState() => _EventCalendarScreenState();
}

class _EventCalendarScreenState extends State<EventCalendarScreen> {
  MainController mainController = Get.find();
  DateTime focusDay = DateTime.now();
  List events = List.empty(growable: true);
  List eventsDateTime = List.empty(growable: true);
  final controller = Get.put(EventCalendarController());

  List<DateTime> getWeekDates(DateTime date) {
    List<DateTime> weekDates = [];

    // Find the start of the week (Sunday) by subtracting the weekday number from the current date
    DateTime startOfWeek = date.subtract(Duration(days: date.weekday-1));

    // Find the end of the week (Saturday) by adding the difference between 7 and the weekday number
    DateTime endOfWeek = date.add(Duration(days: 7 - date.weekday+1));

    // Iterate through the week and add each date to the list
    for (DateTime day = startOfWeek;
        day.isBefore(endOfWeek);
        day = day.add(Duration(days: 1))) {
      weekDates.add(day);
    }

    return weekDates;
  }

  Future<void> initialize() async {
    final ref = await FirebaseFirestore.instance
        .collection("events")
        .where("communityId", isEqualTo: mainController.currentCommunityId!)
        .get();
    events = ref.docs;
    controller.weekDates = getWeekDates(DateTime.now());
    for (var e in events) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(e.get("dateTime"));
      DateTime dateTime = DateTime(date.year, date.month, date.day);
      log("dateTime: " + dateTime.toString());
      eventsDateTime.add(dateTime);
    }
    log("length: " + events.length.toString());
    log("eventsDateTime: " + eventsDateTime.length.toString());
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Calendar',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
            letterSpacing: 0.20,
          ),
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
      body: Stack(
        children: [
          Container(
              alignment: Alignment.bottomCenter,
              height: Get.size.height,
              child: Container(
                height: Get.size.height - 230,
                padding: EdgeInsets.all(16),
                child: ListView.builder(
                    itemCount: controller.weekDates.length,
                    itemBuilder: ((context, index) {
                      return Container(
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  DateFormat("EE")
                                      .format(controller.weekDates[index])
                                      .toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFFFF6161),
                                    fontSize: 14,
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFE6E6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    DateFormat("dd")
                                        .format(controller.weekDates[index])
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFFFF6161),
                                      fontSize: 18,
                                      fontFamily: 'Gilroy',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            customCard(controller, index),
                          ],
                        ),
                      );
                    })),
              )),
          Container(
            height: MediaQuery.of(context).size.height * 0.9,
            alignment: Alignment.topCenter,
            child: Card(
                elevation: 1,
                child: Obx(
                  () => GestureDetector(
                    onVerticalDragDown: (details) {
                      // log(details.globalPosition.dy.toString());

                      // if (details.globalPosition.dy > 190) {
                      //   controller.height.value = 300;
                      //   controller.initialY.value = 300;
                      // }
                    },
                    onVerticalDragUpdate: (details) {
                      double delta = details.primaryDelta ?? 0;
                      log(delta.toString());
                      if (delta > 2.5) {
                        // Dragging downward
                        controller.height.value = 300;
                      } else if(delta < -5) {
                        // Dragging upward
                        controller.height.value=120;
                      }
                    },
                    child: controller.height.value <= 125
                        ? AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            color: Colors.white,
                            height: controller.height.value,
                            child: Column(
                              children: [
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 500),
                                  height: controller.height.value - 10,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: controller.weekDates.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                            onTap: () {
                                              controller.selectedIndex.value =
                                                  index;
                                            },
                                            child: Obx(
                                              () => Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 5,
                                                    vertical: 10),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 14,
                                                    vertical: 16),
                                                decoration: BoxDecoration(
                                                    color: controller
                                                                .selectedIndex
                                                                .value ==
                                                            index
                                                        ? Color(0xFFF2EFFF)
                                                        : Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      DateFormat("dd")
                                                          .format(controller
                                                              .weekDates[index])
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF090B0E),
                                                        fontSize: 18,
                                                        fontFamily: 'Gilroy',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Text(
                                                      DateFormat("EE")
                                                          .format(controller
                                                              .weekDates[index])
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF546881),
                                                        fontSize: 12,
                                                        fontFamily: 'Gilroy',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ));
                                      }),
                                ),
                                Container(
                                  height: 4,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: Color(0xFFE6E6E6),
                                      borderRadius: BorderRadius.circular(3)),
                                )
                              ],
                            ),
                          )
                        : Container(
                            height: MediaQuery.of(context).size.height * 0.50,
                            alignment: Alignment.topCenter,
                            decoration: BoxDecoration(color: Colors.white),
                            child: TableCalendar(
                              focusedDay: DateTime.now(),
                              firstDay: DateTime.now(),
                              lastDay: DateTime(2101),
                              currentDay: focusDay,
                              availableCalendarFormats: {
                                CalendarFormat.month: "Month",
                                CalendarFormat.week: "Week"
                              },
                              calendarFormat: CalendarFormat.month,
                              eventLoader: (day) {
                                // log("hello");
                                DateTime date =
                                    DateTime(day.year, day.month, day.day);
                                // log("dateTime: " + date.toString());
                                if (eventsDateTime.contains(date)) {
                                  return [
                                    {"": ""}
                                  ];
                                }
                                return [];
                              },
                              onDaySelected: (selectedDay, focusedDay) {
                                log("s:" + selectedDay.toString());
                                log("f:" + focusedDay.toString());
                                focusDay = focusedDay;
                                controller.weekDates = getWeekDates(focusedDay);
                                controller.height.value = 120;
                                controller.initialY.value = 0;
                                setState(() {});
                              },
                              pageJumpingEnabled: true,
                            )),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget customCard(EventCalendarController controller, int index) {
    dynamic event = null;
    for (var e in events) {
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(e.get("dateTime"));
      if (dateTime.day == controller.weekDates[index].day &&
          dateTime.month == controller.weekDates[index].month &&
          dateTime.year == controller.weekDates[index].year) {
        event = e;
        break;
      }
    }
    if (event == null) {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Nothing planned. ',
              style: TextStyle(
                color: Color(0xFF909DAD),
                fontSize: 12,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Create an event',
              style: TextStyle(
                color: Color(0xFF7B61FF),
                fontSize: 12,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          if(mainController.role.value=="admin"){
            // Get.to(() => ManageEventScreen(snapshot: event, index: index));
          }
          else{
            Get.to(() => RegisterNowScreen(snapshot: event.data(), id: ""));
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10)
              .copyWith(left: 0),
          width: Get.size.width * 0.7,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFFFF6161),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFFFF9393),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.calendar_month,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              children: [
                Text(
                  event.get("title"),
                  // controller.events[index]['title'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.timer,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      DateFormat.jm().format(
                          DateTime.fromMicrosecondsSinceEpoch(
                              event.get("dateTime"))),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                )
              ],
            )
          ]),
        ),
      );
    }
  }
}
