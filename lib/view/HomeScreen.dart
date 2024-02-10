import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custard_flutter/components/AnalyticsButtonCard.dart';
import 'package:custard_flutter/components/CommunityTile.dart';
import 'package:custard_flutter/components/CustardAppBar.dart';
import 'package:custard_flutter/components/CustardButton.dart';
import 'package:custard_flutter/controllers/HomeController.dart';
import 'package:custard_flutter/controllers/MainController.dart';
import 'package:custard_flutter/utils/CustardColors.dart';
import 'package:custard_flutter/view/CommunityScreen.dart';
import 'package:custard_flutter/view/DiscussionScreen.dart';
import 'package:custard_flutter/view/EventsScreen.dart';
import 'package:custard_flutter/view/GalleryScreen.dart';
import 'package:custard_flutter/view/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'JoinCommunityScreen.dart';
import 'ProfileScreen.dart';

class HomeScreen extends StatelessWidget {
  final globalKey = GlobalKey<ScaffoldState>();
  HomeController controller = Get.put(HomeController());
  MainController mainController = Get.find();
  @override
  Widget build(BuildContext context) {
    mainController.homeGlobalKey = globalKey;
    return Scaffold(
      key: globalKey,
      // appBar: CustardAppBar.homeAppBar(_onAvatarTap),
      // appBar: Obx(() => [
      //   CustardAppBar.homeAppBar(_onAvatarTap),
      //   CustardAppBar.homeAppBar(_onAvatarTap),
      //   CustardAppBar.homeAppBar(_onAvatarTap),
      //   CustardAppBar.homeAppBar(_onAvatarTap),
      //   CustardAppBar.homeAppBar(_onAvatarTap),
      // ][mainController.currentPageIndex.value]) as PreferredSizeWidget,
      // drawerDragStartBehavior: DragStartBehavior.start,
      drawerEnableOpenDragGesture: false,
      drawer: FractionallySizedBox(
        widthFactor: 0.90,
        heightFactor: 1,
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Obx(() => Container(
                    height: 250,
                    child: Stack(
                      children: [
                        DrawerHeader(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(mainController
                                      .currentCommunity
                                      .value!
                                      .communityProfilePic),
                                  fit: BoxFit.cover)),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        mainController
                                            .homeGlobalKey.currentState
                                            ?.closeDrawer();
                                      }),
                                  IconButton(
                                      icon: Icon(
                                        Icons.settings,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {})
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: Get.size.width * 0.45 - 50,
                          child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(mainController
                                        .currentCommunity
                                        .value!
                                        .communityProfilePic),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(20),
                              )),
                        ),
                      ],
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              Obx(() => Text(
                    mainController.currentCommunity.value!.communityName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xFF090B0E),
                        fontSize: 16,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600),
                  )),
              Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  mainController.currentCommunity.value!.communityAbout,
                  style: TextStyle(
                      color: Color(0xFF546881),
                      fontSize: 14,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AnalyticsButtonCard(
                        leadingIcon: Icon(Icons.analytics,
                            color: CustardColors.appTheme),
                        title: "Analytics",
                        mainNum: "3333",
                        hikePercent: "42%",
                        onPressed: () {}),
                    AnalyticsButtonCard(
                        leadingIcon:
                            Icon(Icons.money, color: CustardColors.appTheme),
                        title: "Money Matrix",
                        mainNum: "3333",
                        hikePercent: "42%",
                        onPressed: () {})
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: TextButton.icon(
                    onPressed: () {
                      Get.to(() => CommunityScreen());
                    },
                    icon: SvgPicture.asset("assets/images/export1.svg"),
                    label: Text(
                      ' Open chapter’s page',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF7B61FF),
                        fontSize: 16,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )),
              Container(
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: Color(0xFFEBEBEB),
                    ),
                  ),
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: mainController.currentUser!.communities.length,
                  itemBuilder: (context, index) {
                    print(mainController.currentUser!.communities.length);
                    return FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection("communities")
                          .doc(mainController.currentUser!.communities[index])
                          .get(),
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: ListTile(
                                onTap: () async {
                                  mainController.homeGlobalKey.currentState
                                      ?.closeDrawer();
                                  EasyLoading.show(status: 'loading...');
                                  await mainController.getCommunity(
                                      mainController
                                          .currentUser!.communities[index]);
                                  EasyLoading.dismiss();
                                },
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: CachedNetworkImageProvider(
                                      snapshot.data!['communityProfilePic']),
                                ),
                                title: Text(
                                  snapshot.data!['communityName'],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }
                        }
                        return Container();
                      }),
                    );
                  }),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: ListTile(
                  onTap: () {
                    globalKey.currentState!.closeDrawer();
                    Get.to(() => JoinCommunityScreen());
                  },
                  leading: Icon(Icons.add),
                  title: Text(
                    'Add more',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              // CommunityTile(
              //     image: AssetImage("assets/avatar.png"),
              //     tilte: "Social Dance Tribe"),
              // CommunityTile(
              //     image: AssetImage("assets/avatar.png"),
              //     tilte: "Social Dance Tribe"),
              // CommunityTile(
              //     image: AssetImage("assets/avatar.png"),
              //     tilte: "Social Dance Tribe")
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => CupertinoTabBar(
          backgroundColor: Colors.white,
          border: Border(top: BorderSide(color: Colors.transparent)),
          onTap: (value) {
            if (value == 1) {
              Get.to(() => DiscussionScreen());
            } else {
              mainController.currentPageIndex.value = value;
            }
          },
          currentIndex: mainController.currentPageIndex.value,
          items: [
            BottomNavigationBarItem(
                icon: mainController.currentPageIndex.value == 0
                    ? SvgPicture.asset("assets/images/home_selected.svg")
                    : SvgPicture.asset("assets/images/home.svg"),
                label: "home"),
            BottomNavigationBarItem(
                icon: mainController.currentPageIndex.value == 1
                    ? SvgPicture.asset("assets/images/people_selected.svg")
                    : SvgPicture.asset("assets/images/people.svg"),
                label: "Discussion"),
            BottomNavigationBarItem(
                icon: mainController.currentPageIndex.value == 2
                    ? SvgPicture.asset("assets/images/calendar_selected.svg")
                    : SvgPicture.asset("assets/images/calendar.svg"),
                label: "Events"),
            BottomNavigationBarItem(
                icon: mainController.currentPageIndex.value == 3
                    ? SvgPicture.asset("assets/images/gallery_selected.svg")
                    : SvgPicture.asset("assets/images/task-square.svg"),
                label: "Gallery"),
            BottomNavigationBarItem(
                icon: CircleAvatar(
                  radius: 16,
                  backgroundImage:
                      NetworkImage(mainController.currentUser!.profilePic),
                ),
                label: "Profile"),
          ],
        ),
      ),

      // bottomNavigationBar: Obx(() => NavigationBar(
      //   onDestinationSelected: (idx) {
      //     mainController.currentPageIndex.value = idx;
      //   },
      //   indicatorColor: CustardColors.appTheme,
      //   selectedIndex: mainController.currentPageIndex.value,
      //   destinations: [
      //     NavigationDestination(
      //         icon: Icon(Icons.home,color: mainController.currentPageIndex.value==0 ? Colors.white : Colors.black,),
      //         label: "Home"
      //     ),
      //     NavigationDestination(
      //         icon: Icon(Icons.group,color: mainController.currentPageIndex.value==1 ? Colors.white : Colors.black,),
      //         label: "Discussions"
      //     ),
      //     NavigationDestination(
      //         icon: Icon(Icons.event,color: mainController.currentPageIndex.value==2 ? Colors.white : Colors.black,),
      //         label: "Events"
      //     ),
      //     NavigationDestination(
      //         icon: Icon(Icons.browse_gallery,color: mainController.currentPageIndex.value==3 ? Colors.white : Colors.black,),
      //         label: "Gallery"
      //     ),
      //     NavigationDestination(
      //         icon: Icon(Icons.verified_user,color: mainController.currentPageIndex.value==4 ? Colors.white : Colors.black,),
      //         label: "Profile"
      //     )
      //   ],
      // )),
      body: Obx(() => [
            HomePage(),
            DiscussionScreen(),
            EventsScreen(),
            const GalleryScreen(),
            ProfileScreen(
              currentUser: true,
            ),
          ][mainController.currentPageIndex.value]),
    );
  }

  _onAvatarTap() {
    globalKey.currentState?.openDrawer();
  }
}
