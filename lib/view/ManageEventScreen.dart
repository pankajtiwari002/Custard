import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custard_flutter/components/CustardButton.dart';
import 'package:custard_flutter/controllers/ManageEventController.dart';
import 'package:custard_flutter/view/EditEventScreen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

class ManageEventScreen extends StatelessWidget {
  final snapshot;
  int index;
  bool isFeedBack;
  final controller = Get.put(ManageEventController());
  ManageEventScreen(
      {super.key,
      required this.snapshot,
      required this.index,
      this.isFeedBack = false}) {
    controller.titleController.text = snapshot[index]['title'];
    controller.descriptionController.text =
        snapshot[index]['description'];
    if (snapshot[index].data().containsKey("registerationStatus") &&
        snapshot[index]["registerationStatus"] == "close") {
      controller.isRegistrationOpen.value = false;
    }
    if (isFeedBack) {
      controller.reachToInsight();
    }
  }

  DateTime convertMillisecondsToDateTime(int millisecondsSinceEpoch) {
    return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Manage Event",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
          actions: [
            TextButton(
                onPressed: () async{
                  controller.price.text =
                      snapshot[index]['ticketPrice'].toString();
                  controller.capacity.text =
                      snapshot[index]['capacity'].toString();
                  controller.isFreeEvent.value =
                      snapshot[index]['isFreeEvent'];
                  controller.isRemoveLimit.value =
                      snapshot[index]['isRemoveLimit'];
                  controller.eventId = snapshot[index]["id"];
                  bool result = await Get.to(() => EditEventsScreen(
                        snapshot: snapshot,
                        index: index,
                      ));
                  if(result){
                    controller.update();
                  }
                },
                child: Text(
                  "Edit Event",
                  style: TextStyle(color: Color(0xFF7B61FF)),
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              TabBar(
                controller: controller.tabController,
                tabs: [
                  Tab(text: 'Overview'),
                  Tab(text: 'Registration'),
                  Tab(text: 'Insight'),
                ],
              ),
              Container(
                height: size.height * 0.8,
                child: TabBarView(
                  controller: controller.tabController,
                  children: [
                    // Overview Tab Content
                    OverviewTab(),
                    RegistrationTab(context),
                    insightsTab()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget OverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Scrollable Row with Rounded Rectangel Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Your rounded rectangle chips with icon and text
                customChip(Color(0x26FFB661), "assets/images/message.svg",
                    "Invite Guest", () {}),
                customChip(Color(0xFFF9E0E2), "assets/images/announcement.svg",
                    "Announcement", () {}),
                // ...
              ],
            ),
          ),

          SizedBox(height: 16.0),

          // 2. Image with Rounded Border and Camera Icon
          Center(
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                width: Get.size.width * 0.5,
                height: Get.size.width * 0.5,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          snapshot[index]['coverPhotoUrl']),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10),
                )),
          ),

          SizedBox(height: 16.0),

          // 3. Bold Text 'The Art of Living'
          Text(
            snapshot[index]['title'],
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF090B0E),
              fontSize: 24,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 16.0),
          Divider(),
          // 4. Bold Text 'Event Description'
          Text(
            'Event description',
            style: TextStyle(
              color: Color(0xFF141414),
              fontSize: 16,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 8.0),

          // 5. Text Description
          Text(
            snapshot[index]['description'],
            style: TextStyle(
              color: Color(0xFF546881),
              fontSize: 14,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 16.0),

          // 6. Two Rows with Icon and Text
          buildRowWithIcon(
              Icons.calendar_month,
              DateFormat('EEEE, MMMM d').format(convertMillisecondsToDateTime(
                  snapshot[index]['dateTime'])),
              "${DateFormat.jm().format(convertMillisecondsToDateTime(snapshot[index]['dateTime']))} - ${DateFormat.jm().format(convertMillisecondsToDateTime(snapshot[index]['dateTime']))}"),
          SizedBox(
            height: 24,
          ),
          buildRowWithIcon(Icons.location_on, '2, Jawahar Lal Nehru Marg',
              'Opposite Opp Commerce College, Jhalana Doongri, Jaipur, Rajasthan 302004'),

          SizedBox(height: 16.0),

          // 7. Image with Rounded Border
          RoundedImage(
              imageUrl:
                  "https://www.mapsofindia.com/maps/rajasthan/tehsil/chittaurgarh-tehsil-map.jpg"),

          SizedBox(height: 16.0),

          // 8. Bold Text 'Hosted By'
          Text('Hosted By',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

          SizedBox(height: 8.0),

          // 9. ListView Builder with Horizontal Scroll Direction
          Container(
            height: 100.0,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 5, // Replace with your actual item count
              itemBuilder: (context, index) {
                if (index == 4) {
                  // Last item with + icon and text
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 30.0,
                          backgroundColor: Color(0xFFF2EFFF),
                          child: Icon(Icons.add, color: Color(0xFF7B61FF)),
                        ),
                        SizedBox(height: 4.0),
                        Text('Add', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  );
                } else {
                  // Other items with circular image and name
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 30.0,
                          backgroundImage: NetworkImage(
                              "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                        ),
                        SizedBox(height: 4.0),
                        Text('Sonu', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  );
                }
              },
            ),
          ),

          SizedBox(height: 16.0),

          // 10. Bold Text 'Theme'
          Text(
            'Theme',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF090B0E),
              fontSize: 18,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            height: 100,
            child: ListView.builder(
              itemCount: 3,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5.0),
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            color: Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          'Title',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF090B0E),
                            fontSize: 12,
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text('Abstract')
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget RegistrationTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Your rounded rectangle chips with icon and text
                customChip(Color(0x26FFB661), "assets/images/message.svg",
                    "Invite Guest", () {}),
                Obx(() {
                  if (controller.isRegistrationOpen.value) {
                    return customChip(
                        Color(0xFFF9E0E2),
                        "assets/images/close-circle.svg",
                        "Close Registration", () async {
                      await FirebaseFirestore.instance
                          .collection("events")
                          .doc(snapshot[index]['id'])
                          .update({
                        "registerationStatus": "close",
                      });
                      controller.isRegistrationOpen.value = false;
                    });
                  } else {
                    return customChip(
                        Color(0x2300BC32),
                        "assets/images/tick-circle.svg",
                        "Open Registration", () async {
                      await FirebaseFirestore.instance
                          .collection("events")
                          .doc(snapshot[index]['id'])
                          .update({
                        "registerationStatus": "open",
                      });
                      controller.isRegistrationOpen.value=true;
                    });
                  }
                })
                // ...
              ],
            ),
          ),
          Text(
            'At a glance',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${controller.registered.length} ',
                  style: TextStyle(
                    color: controller.registered.value.length == 0
                        ? Colors.grey
                        : Color(0xFF00BC32),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: 'guests going',
                  style: TextStyle(
                    color: controller.registered.length == 0
                        ? Colors.grey
                        : Color(0xFF00BC32),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 6,
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(right: 20),
            height: 6,
            decoration: BoxDecoration(
              // color: Color(0xFF00BC32),
              color: controller.registered.length == 0
                  ? Colors.grey
                  : Color(0xFF00BC32),
              borderRadius: BorderRadius.circular(19),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            'Guest list',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
          Obx(
            () => Visibility(
              visible: controller.registered.length == 0,
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 500,
                child: Container(
                  width: 250,
                  alignment: Alignment.center,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    SvgPicture.asset("assets/images/profile-2user.svg"),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'No guests yet',
                      style: TextStyle(
                        color: Color(0xFF090B0E),
                        fontSize: 18,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.20,
                      ),
                    ),
                    Text(
                      'Share the event or invite people to get started.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF909DAD),
                        fontSize: 14,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.20,
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
          Obx(() => Visibility(
              visible: controller.registered.length > 0,
              child: Container(
                height: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        label: Text('Search Guest'),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PopupMenuButton(
                            color: Colors.black,
                            onSelected: (val) {
                              controller.filter.value = val;
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  controller.filter.value,
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Icon(
                                  Icons.filter_list,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                            itemBuilder: (context) => [
                                  PopupMenuItem<String>(
                                    value: 'All Guests',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.people,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          ' All Guests',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'Invited',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          ' Invited',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'Approval Pending',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.access_time_outlined,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          ' Approval Pending',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'Checked-In',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle_outline_outlined,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          ' Checked-In',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                        PopupMenuButton(
                            color: Colors.black,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Register time ",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Icon(
                                  Icons.filter_list,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                            itemBuilder: (context) => [
                                  PopupMenuItem<String>(
                                    value: 'name',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          ' Name',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'Register Time',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.people,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          ' Register Time',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                      ],
                    ),
                    Visibility(
                        visible: (controller.filter.value == "All Guests" ||
                            controller.filter.value == "Checked-In"),
                        child: ListView.builder(
                            itemCount: controller.registered.length,
                            shrinkWrap: true,
                            // primary: false,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                                  radius: 18,
                                ),
                                title: Text("Aman Gairola"),
                                subtitle: Text("Life is beautiful"),
                                trailing: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: Color(0x2800BC32),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text(
                                    'Going',
                                    style: TextStyle(
                                      color: Color(0xFF00BC32),
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              );
                            })),
                    Visibility(
                        visible: (controller.filter.value == "All Guests" ||
                            controller.filter.value == "Invited"),
                        child: ListView.builder(
                            itemCount: controller.registered.length,
                            shrinkWrap: true,
                            // primary: false,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                                  radius: 18,
                                ),
                                title: Text("Aman Gairola"),
                                subtitle: Text("Life is beautiful"),
                                trailing: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: Color(0x47FFB661),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text(
                                    'Invited',
                                    style: TextStyle(
                                      color: Color(0xFFFFB661),
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              );
                            })),
                    Visibility(
                        visible: (controller.filter.value == "All Guests" ||
                            controller.filter.value == "Approval Pending"),
                        child: ListView.builder(
                            itemCount: controller.registered.length,
                            shrinkWrap: true,
                            // primary: false,
                            itemBuilder: (context, index) {
                              return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                                    radius: 18,
                                  ),
                                  title: Text("Aman Gairola"),
                                  subtitle: Text("Life is beautiful"),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.check,
                                            color: Colors.green,
                                          )),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.close,
                                            color: Colors.red,
                                          )),
                                    ],
                                  ));
                            })),
                  ],
                ),
              ))),
        ],
      ),
    );
  }

  Widget insightsTab() {
    List<Color> gradientColor = [
      Color(0xffffb661),
      Color.fromARGB(255, 248, 192, 128),
    ];
    if (isFeedBack) {
      Future.delayed(Duration(milliseconds: 100)).then((value) {
        controller.scrollController.animateTo(
            controller.scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeIn);
      });
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: SingleChildScrollView(
        controller: controller.scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              elevation: 2,
              child: Stack(
                children: [
                  Container(
                    height: 200,
                    color: Colors.white,
                    child: LineChart(
                      LineChartData(
                          minX: 0,
                          maxX: 8,
                          minY: 0,
                          maxY: 6,
                          gridData: FlGridData(show: false),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                showTitles: false,
                              )),
                              topTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                showTitles: false,
                              )),
                              rightTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                showTitles: false,
                              )),
                              bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                interval: 1,
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  // print(value);
                                  switch (value.toInt()) {
                                    case 1:
                                      return Text("Mon");
                                    case 2:
                                      return Text("Tue");
                                    case 3:
                                      return Text("Wed");
                                    case 4:
                                      return Text("Thu");
                                    case 5:
                                      return Text("Fri");
                                    case 6:
                                      return Text("Sat");
                                    case 7:
                                      return Text("Sun");
                                  }
                                  return Text("");
                                },
                              ))),
                          lineBarsData: [
                            LineChartBarData(
                              spots: [
                                FlSpot(0, 3),
                                FlSpot(1, 2),
                                FlSpot(2, 5),
                                FlSpot(3, 2.5),
                                FlSpot(4, 4),
                                FlSpot(5, 3),
                                FlSpot(6, 5),
                                FlSpot(7.9, 4),
                              ],
                              isCurved: true,
                              color: Color(0xffffb661),
                              barWidth: 5,
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(
                                  show: true,
                                  // color: Color(0xffffb661).withOpacity(0.3),
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xffffb661).withOpacity(0.4),
                                        Color(0xffffb661).withOpacity(0.3),
                                        // Color(0xffffb661).withOpacity(0.1),
                                        Color(0xffffb661).withOpacity(0.0),
                                      ])),
                            )
                          ]),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Row(
              children: [
                SvgPicture.asset("assets/images/ticket-star.svg"),
                SizedBox(
                  width: 16,
                ),
                Text(
                  'Events Analytics',
                  style: TextStyle(
                    color: Color(0xFF090B0E),
                    fontSize: 18,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.54,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Card(
              elevation: 2,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    customRow(
                        "Event Views", "160", "+2.51%", Color(0xFF00BC32)),
                    SizedBox(
                      height: 16,
                    ),
                    Divider(),
                    SizedBox(
                      height: 16,
                    ),
                    customRow(
                        "Event Views", "160", "+2.51%", Color(0xFF00BC32)),
                    SizedBox(
                      height: 16,
                    ),
                    Divider(),
                    SizedBox(
                      height: 16,
                    ),
                    customRow(
                        "Event Views", "160", "+2.51%", Color(0xFF00BC32)),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                SvgPicture.asset("assets/images/document.svg"),
                SizedBox(
                  width: 16,
                ),
                Text(
                  'Events FeedBacks',
                  style: TextStyle(
                    color: Color(0xFF090B0E),
                    fontSize: 18,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.54,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 32,
            ),
            SvgPicture.asset("assets/images/documentPurple.svg"),
            Text(
              'No feedbacks yet',
              style: TextStyle(
                color: Color(0xFF090B0E),
                fontSize: 18,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600,
                letterSpacing: 0.20,
              ),
            ),
            Text(
              'To collect feedback, schedule a post event thankyou announcement and some feedback questions.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF909DAD),
                fontSize: 14,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w500,
                letterSpacing: 0.20,
              ),
            ),
            CustardButton(
                onPressed: () {},
                buttonType: ButtonType.NEGATIVE,
                label: "+ Create a feedBack Form"),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}

Widget customRow(String title, String num, String percent, Color color) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: TextStyle(
          color: Color(0xFF546881),
          fontSize: 14,
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w400,
          letterSpacing: 0.42,
        ),
      ),
      Row(
        children: [
          Text(
            num,
            style: TextStyle(
              color: Color(0xFF090B0E),
              fontSize: 16,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w600,
              height: 0,
            ),
          ),
          Text(
            percent,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w700,
              height: 0.11,
            ),
          )
        ],
      )
    ],
  );
}

// Widget for Rounded Rectangle Chip
class RoundedRectChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const RoundedRectChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      margin: EdgeInsets.only(right: 8.0),
      decoration: BoxDecoration(
        color: Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          SizedBox(width: 4.0),
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w500,
              height: 0.11,
              letterSpacing: 0.20,
            ),
          )
        ],
      ),
    );
  }
}

// Widget for Rounded Image
class RoundedImage extends StatelessWidget {
  final String imageUrl;

  const RoundedImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      width: double.infinity,
      height: 120.0,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10)),
    );
  }
}

// Function to build Row with Icon and Text
Widget buildRowWithIcon(IconData icon, String labelText, String normalText) {
  return Row(
    children: [
      Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
            color: Color(0xFFF2EFFF), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: Color(0xFF665EE0)),
      ),
      SizedBox(width: 8.0),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: TextStyle(
              color: Color(0xFF090B0E),
              fontSize: 16,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w600,
              height: 0,
            ),
          ),
          SizedBox(
            width: 300,
            child: Text(
              normalText,
              style: TextStyle(
                color: Color(0xFF546881),
                fontSize: 14,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w500,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    ],
  );
}

Widget customChip(
    Color backgroundColor, String imagePath, String title, Callback onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: ShapeDecoration(
        color: Color(0xFFF7F9FC),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: ShapeDecoration(
              color: backgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
            child: SvgPicture.asset(imagePath),
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w500,
              letterSpacing: 0.20,
            ),
          ),
        ],
      ),
    ),
  );
}
