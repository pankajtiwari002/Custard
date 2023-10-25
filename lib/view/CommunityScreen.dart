import 'dart:developer';

import 'package:custard_flutter/components/EventCard.dart';
import 'package:custard_flutter/view/AcceptOrRejectScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../components/HighlightContainer.dart';
import '../controllers/CommunityController.dart';

class CommunityScreen extends StatelessWidget {
  CommunityScreen({super.key});

  final controller = Get.put(CommunityController());

  void _showBottomSheet() {
    Get.bottomSheet(
      ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
        child: Container(
          // height: 400,
          padding: EdgeInsets.only(bottom: 20),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(top: 20, bottom: 0, left: 30, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'More Options',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                ),
              ),
              const Divider(),
              Obx(
                () => Visibility(
                  visible: controller.tabIndex == 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.people),
                        title: Text('Theme Customization'),
                      ),
                      ListTile(
                        leading: Icon(Icons.people),
                        title: Text('Roles'),
                      ),
                      ListTile(
                        leading: Icon(Icons.remove_red_eye),
                        title: Text('Member View'),
                      ),
                      ListTile(
                        leading: Icon(Icons.share),
                        title: Text('Share Page'),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: controller.tabIndex == 1,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.people,
                          color: Colors.red,
                        ),
                        title: Text(
                          'Kick Priya Bhatt',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.block,
                          color: Colors.red,
                        ),
                        title: Text(
                          'Ban Priya Bhatt',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(200),
        topRight: Radius.circular(200),
      )),
    );
  }

  void _showDialog() {
    Get.dialog(
      Dialog(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Remove Request?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'Are you sure want to delete the request of Priya Bhatt',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(
                  onPressed: () {
                    // Add functionality for 'YES' button
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF665EE0),
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Text('YES'),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              TextButton(
                onPressed: () {
                  // Add functionality for Text Button
                  Get.back();
                },
                child: Text(
                  'CANCEL',
                  style: TextStyle(color: Color(0xFF665EE0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: size.height,
          child: SingleChildScrollView(
            child: DefaultTabController(
              length: 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: size.width,
                        height: size.height * 0.25,
                        child: Image.asset(
                          'assets/images/background.jpeg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.arrow_back_ios),
                                    color: Colors.white,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _showBottomSheet();
                                    },
                                    icon: const Icon(Icons.more_vert),
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: Container(
                                width: 150,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      elevation: 12.0,
                                      backgroundColor: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      // minimumSize: const Size.fromHeight(40),
                                      padding: const EdgeInsets.all(5)),
                                  child: const Text(
                                    "Replace Image",
                                    style: TextStyle(
                                      color: Color(0xFF7B61FF),
                                      fontSize: 16,
                                      fontFamily: 'Gilroy',
                                      fontWeight: FontWeight.w700,
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.05,
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 150,
                                  width: 150,
                                  // alignment: Alignment.topLeft,
                                  decoration: BoxDecoration(
                                    image: const DecorationImage(
                                        image: AssetImage(
                                            'assets/images/background.jpeg'),
                                        fit: BoxFit.cover),
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 40,
                                    ),
                                    Text(
                                      "#ASTRONAUTS",
                                      style: TextStyle(
                                          color: Colors.amber,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18),
                                    ),
                                    Text(
                                      "The Mountainers",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                    Text(
                                      "Jaipur, Rajasthan",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Spread Positivity With daily Affirmations',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: size.width * 0.9,
                              height: 70,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color(0x30FFB661),
                              ),
                              child: const Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Today's Affirmation:",
                                    style: TextStyle(
                                      color: Color(0xFF4B3A00),
                                      fontSize: 14,
                                      fontFamily: 'Gilroy',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '"Your potential is endless. Go conquer the day!"',
                                    style: TextStyle(
                                      color: Color(0xFF546881),
                                      fontSize: 12,
                                      fontFamily: 'Gilroy',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: size.width,
                    height: 30,
                    color: Color.fromARGB(255, 247, 247, 242),
                  ),
                  TabBar(
                    controller: controller.tabController,
                    tabs: const [
                      Tab(text: 'Details'),
                      Tab(text: 'Member'),
                      Tab(text: 'Access'),
                    ],
                    labelColor: const Color(0xFF7B61FF),
                    unselectedLabelColor: Colors.black,
                    indicatorColor: const Color(0xFF7B61FF),
                    indicatorWeight: 3.0,
                  ),
                  Container(
                    height: size.height * 1.15,
                    child: TabBarView(
                      controller: controller.tabController,
                      children: [
                        details(),
                        member(controller, context, _showDialog),
                        Text('Access Content')
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

details() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Text(
              'About',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.edit))
          ],
        ),
        const Text(
            "This case study aligns with the goals outlined in Executive Order [Specify the Executive Order Number if applicable]. The Executive Order emphasizes the modernization of government operations through the adoption of innovative technology solutions, with a focus on streamlining processes and enhancing digital services."),
        Row(
          children: [
            const Text(
              'Our Events',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.edit))
          ],
        ),
        Container(
          alignment: Alignment.topLeft,
          height: 300,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: 4,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return EventCard();
              }),
        ),
        Row(
          children: [
            const Text(
              'Highlights',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.edit))
          ],
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
        Row(
          children: [
            const Text(
              'Hosts',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
          ],
        ),
        Container(
          alignment: Alignment.topLeft,
          height: 100,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: 3,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                    ),
                    radius: 40,
                  ),
                );
              }),
        ),
      ],
    ),
  );
}

member(
    CommunityController controller, BuildContext context, Function showDialog) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            CustomContainer(
              text: "108 Member",
              controller: controller,
              containerIndex: 0,
            ),
            const SizedBox(
              width: 10,
            ),
            CustomContainer(
              text: "4 Pending Approval",
              controller: controller,
              containerIndex: 1,
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Obx(
          () => Visibility(
            visible: controller.memberIndex == 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  width: 400,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add the function to be executed when the button is pressed
                    },
                    style: ElevatedButton.styleFrom(
                        // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: BorderSide(color: Color(0xFF7B61FF)),
                        ),
                        backgroundColor: Colors.white),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        '+ Invite Member',
                        style: TextStyle(color: Color(0xFF7B61FF)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const TextField(
                  decoration: InputDecoration(
                      hintText: 'Search Member',
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      suffixIcon: Icon(
                        Icons.filter,
                        color: Colors.grey,
                      ),
                      border: InputBorder.none),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'HOSTS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF546881),
                        fontSize: 14,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '1 online',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFFFB661),
                        fontSize: 12,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
                ListView.builder(
                  itemCount: 2,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return const ListTile(
                      title: Text("Priya Bhatt"),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdXX7GO70tKqiGR95LplD2avbw4oIOGll9jJBNCnvT&s"),
                        radius: 16,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '24 days streak ',
                                  style: TextStyle(
                                    color: Color(0xFFFF6161),
                                    fontSize: 14,
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text: '🔥',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Icon(Icons.more_vert)
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'School',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF546881),
                        fontSize: 14,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '1 online',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFFFB661),
                        fontSize: 12,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
                ListView.builder(
                  itemCount: 1,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: const Text("Priya Bhatt"),
                      leading: const CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdXX7GO70tKqiGR95LplD2avbw4oIOGll9jJBNCnvT&s"),
                        radius: 16,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '24 days streak ',
                                  style: TextStyle(
                                    color: Color(0xFFFF6161),
                                    fontSize: 14,
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text: '🔥',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.more_vert))
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        Obx(() => Visibility(
              visible: controller.memberIndex == 1,
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'HOSTS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF546881),
                          fontSize: 14,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '1 online',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFFFB661),
                          fontSize: 12,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                  ListView.builder(
                    itemCount: 4,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          Get.to(() => AcceptOrRejectScreen());
                        },
                        title: const Text("Priya Bhatt"),
                        leading: const CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdXX7GO70tKqiGR95LplD2avbw4oIOGll9jJBNCnvT&s"),
                          radius: 16,
                        ),
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
                                onPressed: () {
                                  showDialog();
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.red,
                                )),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ))
      ],
    ),
  );
}

class CustomContainer extends StatelessWidget {
  // final bool selected;
  final String text;
  final CommunityController controller;
  final int containerIndex;
  CustomContainer(
      {required this.text,
      required this.controller,
      required this.containerIndex});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // controller.isPending.value = !controller.isPending.value;
        controller.memberIndex.value = containerIndex;
        // print(controller.isPending.value.toString());
      },
      child: Obx(
        () => Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: controller.memberIndex.value == containerIndex
                  ? Color(0x3DFFB661)
                  : Color(0xFFF7F9FC)),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: controller.memberIndex.value == containerIndex
                    ? Color(0xFFFF8900)
                    : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
