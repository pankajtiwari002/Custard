import 'dart:developer';
import 'package:custard_flutter/components/CustardButton.dart';
import 'package:custard_flutter/components/EventCard.dart';
import 'package:custard_flutter/view/AcceptOrRejectScreen.dart';
import 'package:custard_flutter/view/RoleScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../components/HighlightContainer.dart';
import '../controllers/CommunityController.dart';

class CommunityScreen extends StatelessWidget {
  CommunityScreen({super.key});

  final controller = Get.put(CommunityController());

  void _showMoreBottomSheet() {
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
                        onTap: (){
                          Get.to(() => RoleScreen());
                        },
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
    );
  }

  void _showFilterBottomSheet() {
    Get.bottomSheet(
      ClipRRect(
        borderRadius: const BorderRadius.only(
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
                padding: const EdgeInsets.only(
                    top: 20, bottom: 0, left: 30, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
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
              const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text('Memner Role'),
                    trailing: Text("Any"),
                  ),
                  ListTile(
                    title: Text('Location'),
                    trailing: Text("Any"),
                  ),
                  ListTile(
                    title: Text('Skills'),
                    trailing: Text("Any"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addARoleBottomSheet() {
    Get.bottomSheet(
      ClipRRect(
        borderRadius: const BorderRadius.only(
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
                padding: const EdgeInsets.only(
                    top: 20, bottom: 0, left: 30, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
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
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Color.fromARGB(255, 194, 192, 192)),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                      label: Text("Add a role"),
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void openEditAboutSheet() {
    controller.editAbout.text = controller.about.value;
    print(controller.about.value);
    Get.bottomSheet(
      ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: controller.editAbout,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    labelText: 'About the Community',
                  ),
                  maxLines: 10,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustardButton(
                  onPressed: () {
                    controller.about.value = controller.editAbout.text;
                    Get.back();
                  },
                  buttonType: ButtonType.POSITIVE,
                  label: 'Save Changes',
                  backgroundColor: Color(0xFF665EE0),
                  textColor: Colors.white,
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                    child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Discard",
                          style:
                              TextStyle(color: Color(0xFF665EE0), fontSize: 18),
                        ))),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
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
                                    onPressed: () {
                                      Get.back();
                                    },
                                    icon: const Icon(Icons.arrow_back_ios),
                                    color: Colors.white,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _showMoreBottomSheet();
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
                      Tab(text: 'Settings'),
                    ],
                    labelColor: const Color(0xFF7B61FF),
                    unselectedLabelColor: Colors.black,
                    indicatorColor: const Color(0xFF7B61FF),
                    indicatorWeight: 3.0,
                  ),
                  Container(
                    // height: size.height * 1.15,
                    constraints: BoxConstraints(
                        maxHeight: size.height * 0.9,
                        minHeight: size.height * 0.4),
                    child: TabBarView(
                      controller: controller.tabController,
                      children: [
                        details(controller, openEditAboutSheet),
                        member(controller, context, _showDialog,
                            _showFilterBottomSheet, _addARoleBottomSheet),
                        access(),
                        settings(),
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

details(CommunityController controller, Function openEditAboutSheet) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    child: SingleChildScrollView(
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
              IconButton(
                  onPressed: () {
                    openEditAboutSheet();
                  },
                  icon: Icon(Icons.edit))
            ],
          ),
          Text(controller.about.value),
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
    ),
  );
}

member(
    CommunityController controller,
    BuildContext context,
    Function showDialog,
    Function showFilterBottomSheet,
    Function addARoleBottomSheet) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SingleChildScrollView(
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
                        addARoleBottomSheet();
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
                  Row(
                    children: [
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                              hintText: 'Search Member',
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showFilterBottomSheet();
                        },
                        icon: const Icon(
                          Icons.tune,
                          color: Colors.grey,
                        ),
                      ),
                    ],
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
                    primary: false,
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
                                Text(
                                  "view Answer  ",
                                  style: TextStyle(
                                      color: Color(0xFF7B61FF), fontSize: 15),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded,
                                    color: Color(0xFF7B61FF))
                              ],
                            ));
                      },
                    ),
                  ],
                ),
              ))
        ],
      ),
    ),
  );
}

access() {
  return Padding(
    padding: const EdgeInsets.all(12),
    child: Column(children: [
      SizedBox(
        height: 20,
      ),
      Text(
        'Mountaineers Pricing Features',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
          height: 0.08,
        ),
      ),
      SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Free',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.toggle_on,
                color: Color(0xFF7B61FF),
                size: 60,
              )),
          Text(
            'Paid',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
      Container(
        padding: EdgeInsets.only(left: 40),
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle_outlined,
                  color: Color(0xFF7B61FF),
                ),
                SizedBox(width: 10),
                Text(
                  'Socialize & make new friends.',
                  style: TextStyle(
                    color: Color(0xFF010101),
                    fontSize: 14,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle_outlined,
                  color: Color(0xFF7B61FF),
                ),
                SizedBox(width: 10),
                Text(
                  'Attend exclusive events.',
                  style: TextStyle(
                    color: Color(0xFF010101),
                    fontSize: 14,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle_outlined,
                  color: Color(0xFF7B61FF),
                ),
                SizedBox(width: 10),
                Text(
                  'Enhance creativity & expression.',
                  style: TextStyle(
                    color: Color(0xFF010101),
                    fontSize: 14,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle_outlined,
                  color: Color(0xFF7B61FF),
                ),
                SizedBox(width: 10),
                Text(
                  'Stay updated with dance trends.',
                  style: TextStyle(
                    color: Color(0xFF010101),
                    fontSize: 14,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle_outlined,
                  color: Color(0xFF7B61FF),
                ),
                SizedBox(width: 10),
                Text(
                  'Opportunities for collaborations.',
                  style: TextStyle(
                    color: Color(0xFF010101),
                    fontSize: 14,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      SizedBox(
        height: 30,
      ),
      Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Rs 149 ',
              style: TextStyle(
                color: Color(0xFF090B0E),
                fontSize: 32,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
            TextSpan(
              text: 'only',
              style: TextStyle(
                color: Color(0xFF090B0E),
                fontSize: 18,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 20),
      Container(
        width: double.infinity,
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF7B61FF),
          ),
          onPressed: () {},
          icon: Icon(Icons.edit, color: Colors.white),
          label: Text(
            "Edit",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    ]),
  );
}

settings() {
  return Column(children: [
    SizedBox(
      height: 20,
    ),
    ListTile(
      title: Text("Invite People"),
      trailing: Icon(
        Icons.person_3_outlined,
        color: Color(0xFF7B61FF),
      ),
    ),
    ListTile(
      title: Text("Privacy Settings"),
      trailing: Icon(
        Icons.security_outlined,
        color: Color(0xFF7B61FF),
      ),
    ),
    SizedBox(height: 2),
    Divider(),
    SizedBox(height: 2),
    SwitchListTile(
      value: true,
      title: Text("Mute this Chapter"),
      onChanged: (val) {}
    ),
    SwitchListTile(
      title: Text("Notification Settings"),
      value: true, 
      onChanged: (val) {}
    ),
    SizedBox(height: 2),
    Divider(),
    SizedBox(height: 2),
    ListTile(
      title: Text("Open Foundation Page",style: TextStyle(color: Color(0xFF7B61FF))),
      trailing: Icon(
        Icons.link,
        color: Color(0xFF7B61FF),
      ),
    ),
  ]);
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
