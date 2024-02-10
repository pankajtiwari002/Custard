import 'package:custard_flutter/components/FeedbackCard.dart';
import 'package:custard_flutter/components/ThreadCard.dart';
import 'package:custard_flutter/controllers/AnalyticsController.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AnalyticsScreen extends StatelessWidget {
  AnalyticsScreen({super.key});
  final controller = Get.put(AnalyticsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Analytics',
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
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: InkWell(
              onTap: () {},
              child: SvgPicture.asset("assets/images/download.svg"),
            ),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            SizedBox(
              height: 24,
            ),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.9,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xFFF7F9FC)),
                child: TabBar(
                  controller: controller.analyticsController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: TextStyle(
                    color: Color(0xFF090B0E),
                    fontSize: 14,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.20,
                  ),
                  // padding: EdgeInsets.all(8),
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  dividerColor: Colors.transparent,
                  unselectedLabelColor: Color(0xFF546881),
                  tabs: const [
                    Tab(
                      text: 'Engagement Analytics',
                    ),
                    Tab(
                      text: 'Money Analytics',
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: Get.size.height * 0.75,
              child: TabBarView(
                  controller: controller.analyticsController,
                  children: [
                    engagementAnalyticsTab(),
                    moneyAnalyticsTab(),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget engagementAnalyticsTab() {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TabBar(
              dividerColor: Colors.transparent,
              controller: controller.engagementTabController,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Tab(
                  text: "Event",
                ),
                Tab(
                  text: "Member",
                ),
                Tab(
                  text: "Interaction",
                ),
              ],
            ),
            Container(
              height: Get.size.height * 0.69,
              child: TabBarView(
                controller: controller.engagementTabController,
                children: [
                  eventTab(),
                  membersTab(),
                  interactionTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget eventTab() {
    List<Color> gradientColor = [
      Color(0xffffb661),
      Color.fromARGB(255, 248, 192, 128),
    ];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        "Total Shares", "150", "+2.51%", Color(0xFF00BC32)),
                    SizedBox(
                      height: 16,
                    ),
                    Divider(),
                    SizedBox(
                      height: 16,
                    ),
                    customRow(
                        "Total Sales", "160", "-1.51%", Color(0xFFFF3A3A)),
                    SizedBox(
                      height: 16,
                    ),
                    Divider(),
                    SizedBox(
                      height: 16,
                    ),
                    customRow(
                        "Total likes", "160", "+2.51%", Color(0xFF00BC32)),
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
                  'FeedBacks',
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
            FeedBackCard(
                imageUrl:
                    "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y3VzdG9tZXIlMjBwcm9maWxlfGVufDB8fDB8fHww&w=1000&q=80",
                name: "Priya Bhatt",
                rating: 3.5),
            SizedBox(
              height: 16,
            ),
            Text(
              'See all 19 reviews',
              style: TextStyle(
                color: Color(0xFF7B61FF),
                fontSize: 14,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600,
                letterSpacing: 0.42,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget membersTab() {
    final List<Color> colors = [
      Color(0xFF7B61FF),
      Color(0xFFFFB661),
      Color(0xFFFF6262),
    ];
    final List<double> values = [40, 30, 30];
    // List<Color> gradientColor = [
    //   Color(0xffffb661),
    //   Color.fromARGB(255, 248, 192, 128),
    // ];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                              color: Color(0xFFFF6161),
                              barWidth: 5,
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(
                                  show: true,
                                  // color: Color(0xffffb661).withOpacity(0.3),
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xFFFF6161).withOpacity(0.4),
                                        Color(0xFFFF6161).withOpacity(0.3),
                                        // Color(0xffffb661).withOpacity(0.1),
                                        Color(0xFFFF6161).withOpacity(0.0),
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
            Container(
              width: 354,
              height: 200,
              padding: const EdgeInsets.all(16),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x0C000000),
                    blurRadius: 20,
                    offset: Offset(0, 5),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 100,
                        child: PieChart(
                          PieChartData(
                            sections: List.generate(
                              3,
                              (index) => PieChartSectionData(
                                showTitle: false,
                                color: colors[index],
                                value: values[index],
                                radius: 5,
                                titleStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            centerSpaceRadius: 50,
                            sectionsSpace: 0,
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              '213',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF090B0E),
                                fontSize: 19.84,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Members',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF546881),
                                fontSize: 12.40,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      customPieData(Color(0xFF7B61FF), "Male", "45%"),
                      SizedBox(
                        width: 32,
                      ),
                      Text(
                        '|',
                      ),
                      SizedBox(
                        width: 32,
                      ),
                      customPieData(Color(0xFFFF6262), "Male", "45%"),
                      SizedBox(
                        width: 32,
                      ),
                      Text(
                        '|',
                      ),
                      SizedBox(
                        width: 32,
                      ),
                      customPieData(Color(0xFFFFB661), "Male", "45%"),
                    ],
                  )
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
                  'Member Analytics',
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
                    customRow("Total Members", "160", "", Color(0xFF00BC32)),
                    SizedBox(
                      height: 16,
                    ),
                    Divider(),
                    SizedBox(
                      height: 16,
                    ),
                    customRow(
                        "New members", "15 ", "+2.51%", Color(0xFF00BC32)),
                    SizedBox(
                      height: 16,
                    ),
                    Divider(),
                    SizedBox(
                      height: 16,
                    ),
                    customRow(
                        "Total growth", "65% ", "-1.51%", Color(0xFFFF3A3A)),
                    SizedBox(
                      height: 16,
                    ),
                    Divider(),
                    SizedBox(
                      height: 16,
                    ),
                    customRow(
                        "Active Members", "24 ", "+2.51%", Color(0xFF00BC32)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget interactionTab() {
    List<Color> gradientColor = [
      Color(0xffffb661),
      Color.fromARGB(255, 248, 192, 128),
    ];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                              color: Color(0xFF168AF0),
                              barWidth: 5,
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(
                                  show: true,
                                  // color: Color(0xffffb661).withOpacity(0.3),
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xFF168AF0).withOpacity(0.4),
                                        Color(0xFF168AF0).withOpacity(0.3),
                                        // Color(0xffffb661).withOpacity(0.1),
                                        Color(0xFF168AF0).withOpacity(0.0),
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
                  'Member Analytics',
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
                    customRow("Content interaction", "15%", "+2.51%",
                        Color(0xFF00BC32)),
                    SizedBox(
                      height: 16,
                    ),
                    Divider(),
                    SizedBox(
                      height: 16,
                    ),
                    customRow("Inactive audience", "65%", "-1.51%",
                        Color(0xFFFF3A3A)),
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
                  'Top Threads',
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
            ListView.builder(
                shrinkWrap: true,
                itemCount: 2,
                primary: false,
                itemBuilder: (context, index) {
                  return ThreadCard(
                      image:
                          "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y3VzdG9tZXIlMjBwcm9maWxlfGVufDB8fDB8fHww&w=1000&q=80",
                      name: "Priya Bhatt");
                })
          ],
        ),
      ),
    );
  }

  Widget customPieData(Color color, String title, String percent) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF090B0E),
                fontSize: 14,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              percent,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF546881),
                fontSize: 12,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        )
      ],
    );
  }

  Widget moneyAnalyticsTab() {
    print("hello");
    return Container(
      height: Get.size.height * 0.7,
      // width: Get.size.width*0.9,
      margin: EdgeInsets.symmetric(horizontal: 18.5),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 24),
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: Color(0xffff6161),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Net Revenue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.30,
                    ),
                  ),
                  Text(
                    '₹ 3,95,000.00',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '+2.50%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.30,
                          ),
                        ),
                        TextSpan(
                          text: ' from last year',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.30,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: Color(0xFFF2F2F2),
                  ),
                  borderRadius: BorderRadius.circular(17.28),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 105,
                    offset: Offset(8.64, 12.96),
                    spreadRadius: 0,
                  )
                ],
              ),
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
                                      return Text("Sept");
                                    case 7:
                                      return Text("Oct");
                                    // case 3:
                                    //   return Text("Wed");
                                    // case 4:
                                    //   return Text("Thu");
                                    // case 5:
                                    //   return Text("Fri");
                                    // case 6:
                                    //   return Text("Sat");
                                    // case 7:
                                    //   return Text("Sun");
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
                              barWidth: 3,
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
                  'Revenue',
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
            Container(
              padding: EdgeInsets.all(16),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x0C000000),
                    blurRadius: 20,
                    offset: Offset(0, 5),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(
                children: [
                  customRevenueRow("Membership", "15000.00 ", "+2.51%",
                      "20 people have joined", Color(0xFF00BC32)),
                  SizedBox(
                    height: 16,
                  ),
                  Divider(),
                  SizedBox(
                    height: 16,
                  ),
                  customRevenueRow("Events", "5540.00 ", "+2.51%",
                      "35 events happened", Color(0xFF00BC32)),
                ],
              ),
            ),
            SizedBox(
              height: 19,
            ),
            Container(
              height: 284,
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      width: 208,
                      height: 284,
                      padding: const EdgeInsets.all(16),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: Color(0xFFF3F3F3)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x0A000000),
                            blurRadius: 54,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset("assets/images/Bar.svg"),
                          SizedBox(
                            height: 24,
                          ),
                          Center(
                            child: Text(
                              'Events',
                              style: TextStyle(
                                color: Color(0xFF090B0E),
                                fontSize: 14,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            'Charging for events helps cover operational costs, ensures a committed audience, and elevates the perceived value of the event.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF546881),
                              fontSize: 10,
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Container(
                      width: 208,
                      height: 284,
                      padding: const EdgeInsets.all(16),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: Color(0xFFF3F3F3)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x0A000000),
                            blurRadius: 54,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset("assets/images/Bar.svg"),
                          SizedBox(
                            height: 24,
                          ),
                          Center(
                            child: Text(
                              'Membership',
                              style: TextStyle(
                                color: Color(0xFF090B0E),
                                fontSize: 14,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            'Charging for memberships creates a stable revenue stream, fosters an engaged community, and funds platform improvements for all users.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF546881),
                              fontSize: 10,
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  Widget customRevenueRow(
      String title, String num, String percent, String desc, Color color) {
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
        Column(
          children: [
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
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              desc,
              style: TextStyle(
                color: Color(0xFF546881),
                fontSize: 12,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        )
      ],
    );
  }
}
