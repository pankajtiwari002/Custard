import 'package:custard_flutter/components/EventCard.dart';
import 'package:custard_flutter/controllers/MainController.dart';
import 'package:custard_flutter/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../components/AnalyticsButtonCard.dart';
import '../components/CommunityTile.dart';
import '../components/CustardButton.dart';
import '../components/HighlightContainer.dart';
import '../utils/CustardColors.dart';
import 'CommunityScreen.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final globalKey = GlobalKey<ScaffoldState>();
  MainController mainController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: globalKey,
      // key: mainController.homeGlobalKey,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Social Dance tribe',
              style: TextStyle(
                color: Color(0xFF090B0E),
                fontSize: 18,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Jaipur, Rajasthan',
              style: TextStyle(
                color: Color(0xFF546881),
                fontSize: 14,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        leading: GestureDetector(
          onTap: () {
            // print('hi');
            mainController.homeGlobalKey.currentState!.openDrawer();
          },
          child: Container(
            // margin: EdgeInsets.all(0).copyWith(left: 18,right: 15),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                        "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y3VzdG9tZXIlMjBwcm9maWxlfGVufDB8fDB8fHww&w=1000&q=80"),
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Color(0xfff2efff)),
                    child: Icon(
                      Icons.menu,
                      size: 15,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset("assets/images/notification.svg"),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset("assets/images/messages.svg"),
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // SizedBox(height: 10,),
              // completeProfile(),
              SizedBox(
                height: 32,
              ),
              Container(
                // width: Get.size.width*0.9,
                height: 80,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 7,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: ((context, index) {
                      return buildContainer(index);
                    })),
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                width: double.infinity,
                // margin: EdgeInsets.symmetric(horizontal: 18,vertical: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffffb661),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () {},
                  child: Text(
                    "Bachata Bliss Amigos!",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 32,
              ),
              // completeProfile(),
              Container(
                height: 130,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 2,
                    itemBuilder: ((context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xfff2efff),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.poll_outlined,
                                  color: Color(0xff7b61ff),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  'Total Reach',
                                  style: TextStyle(
                                    color: Color(0xFF546881),
                                    fontSize: 12,
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 22,
                            ),
                            Text(
                              '3333',
                              style: TextStyle(
                                color: Color(0xFF7B61FF),
                                fontSize: 18,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '+42% % ',
                                    style: TextStyle(
                                      color: Color(0xFF00BC32),
                                      fontSize: 12,
                                      fontFamily: 'Gilroy',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'from last week',
                                    style: TextStyle(
                                      color: Color(0xFF546881),
                                      fontSize: 12,
                                      fontFamily: 'Gilroy',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    })),
              ),
              SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Gallery',
                    style: TextStyle(
                      color: Color(0xFF090B0E),
                      fontSize: 16,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'See more',
                      style: TextStyle(
                        color: Color(0xFF7B61FF),
                        fontSize: 14,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                alignment: Alignment.topLeft,
                height: 200,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 4,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return HighlightContainer();
                    }),
              ),
              SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Events',
                    style: TextStyle(
                      color: Color(0xFF090B0E),
                      fontSize: 16,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        'See more',
                        style: TextStyle(
                          color: Color(0xFF7B61FF),
                          fontSize: 14,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                alignment: Alignment.topLeft,
                height: 240,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 4,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Card(
                          elevation: 1.0,
                          margin: EdgeInsets.all(10.0),
                          child: Container(
                            width: 170,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 10.0,
                                      height: 10.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.yellow,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Upcoming',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10.0,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdXX7GO70tKqiGR95LplD2avbw4oIOGll9jJBNCnvT&s"),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(15)),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'Starting in 12:09:66',
                                  style: TextStyle(
                                    color: Color(0xFFFF3A3A),
                                    fontSize: 10,
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.w400,
                                    height: 0.15,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'Social Dance Tribe',
                                  style: TextStyle(
                                    color: Color(0xFF090B0E),
                                    fontSize: 14,
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'CHECK IN',
                                        style: TextStyle(
                                          color: Color(0xFF7B61FF),
                                          fontSize: 12,
                                          fontFamily: 'Gilroy',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Achievements',
                    style: TextStyle(
                      color: Color(0xFF090B0E),
                      fontSize: 16,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        'See more',
                        style: TextStyle(
                          color: Color(0xFF7B61FF),
                          fontSize: 14,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                alignment: Alignment.topLeft,
                height: 200,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 4,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                  "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y3VzdG9tZXIlMjBwcm9maWxlfGVufDB8fDB8fHww&w=1000&q=80"),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Together We \nThrive',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF090B0E),
                                fontSize: 12,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildWhenEmpty() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Column(
        children: [
          Text("You have not joined any events."),
          SizedBox(
            height: 10,
          ),
          TextButton(
              onPressed: () {},
              child: Text(
                "+ Join a Event",
                style: TextStyle(color: Color(0xff7b61ff)),
              ))
        ],
      ),
    );
  }

  Widget buildContainer(int index) {
    // Check if the container is selected
    bool isSelected =
        index == 2; // Replace with your logic to determine selected container

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          height: 50,
          width: 50,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFFFF6161) : Color(0xFFFFE7E7),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'S',
                style: TextStyle(
                    color: isSelected ? Colors.white : Color(0xFFFF6161)),
              ),
              Text(
                '10',
                style: TextStyle(color: isSelected ? Colors.white : Colors.red),
              ),
            ],
          ),
        ),
        if (isSelected)
          SizedBox(
            height: 10.0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              width: 10.0,
            ),
          ),
      ],
    );
  }

  Widget completeProfile() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0x30FFB661),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Complete your profile",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "75 %",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Container(
                width: 300,
                child: LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(15),
                    minHeight: 5,
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation(Color(0xFFffb661)),
                    value: 0.7),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "Please complete your profile for the better experience",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          )
        ],
      ),
    );
  }
}
