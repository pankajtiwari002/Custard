import 'package:custard_flutter/components/AnalyticsButtonCard.dart';
import 'package:custard_flutter/components/CommunityTile.dart';
import 'package:custard_flutter/components/CustardAppBar.dart';
import 'package:custard_flutter/components/CustardButton.dart';
import 'package:custard_flutter/utils/CustardColors.dart';
import 'package:custard_flutter/view/GalleryScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  var currentPageIndex = 0.obs;
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: CustardAppBar.homeAppBar(_onAvatarTap),
      // appBar: Obx(() => [
      //   CustardAppBar.homeAppBar(_onAvatarTap),
      //   CustardAppBar.homeAppBar(_onAvatarTap),
      //   CustardAppBar.homeAppBar(_onAvatarTap),
      //   CustardAppBar.homeAppBar(_onAvatarTap),
      //   CustardAppBar.homeAppBar(_onAvatarTap),
      // ][currentPageIndex.value]) as PreferredSizeWidget,
      drawer: FractionallySizedBox(
        widthFactor: 0.90,
        heightFactor: 1,
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/avatar.png"),
                        fit: BoxFit.cover
                    )
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(icon: Icon(Icons.close), onPressed: () {}),
                        IconButton(icon: Icon(Icons.settings), onPressed: () {})
                      ],
                    ),
                    Expanded(
                        child: ClipRRect(
                          child: Image(
                              image: AssetImage('assets/avatar.png')
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        )
                    )

                  ],
                ),
              ),
              Text(
                'The Mountaineers',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF090B0E),
                  fontSize: 16,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  "This case study aligns with the goals outlined in Executive Order [Specify the Executive Order Number if applicable]. The Exececutive and the bar",
                  style: TextStyle(
                      color: Color(0xFF546881),
                      fontSize: 14,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w400
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AnalyticsButtonCard(
                        leadingIcon: Icon(Icons.analytics, color: CustardColors.appTheme),
                        title: "Analytics",
                        mainNum: "3333",
                        hikePercent: "42%",
                        onPressed: () {}
                    ),
                    AnalyticsButtonCard(
                        leadingIcon: Icon(Icons.money, color: CustardColors.appTheme),
                        title: "Money Matrix",
                        mainNum: "3333",
                        hikePercent: "42%",
                        onPressed: () {}
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: CustardButton(
                  onPressed: () {},
                  buttonType: ButtonType.POSITIVE,
                  label: "Open Chapter Page",
                  backgroundColor: Colors.white,
                  textColor: CustardColors.appTheme,
                ),
              ),
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
              CommunityTile(
                image: AssetImage("assets/avatar.png"),
                tilte: "Social Dance Tribe"
              ),
              CommunityTile(
                  image: AssetImage("assets/avatar.png"),
                  tilte: "Social Dance Tribe"
              ),
              CommunityTile(
                  image: AssetImage("assets/avatar.png"),
                  tilte: "Social Dance Tribe"
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(() => NavigationBar(
        onDestinationSelected: (idx) {
          currentPageIndex.value = idx;
        },
        indicatorColor: CustardColors.appTheme,
        selectedIndex: currentPageIndex.value,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home),
              label: "Home"
          ),
          NavigationDestination(
              icon: Icon(Icons.group),
              label: "Discussions"
          ),
          NavigationDestination(
              icon: Icon(Icons.event),
              label: "Events"
          ),
          NavigationDestination(
              icon: Icon(Icons.browse_gallery),
              label: "Gallery"
          ),
          NavigationDestination(
              icon: Icon(Icons.verified_user),
              label: "Profile"
          )
        ],
      )),
      body: Obx(() => [
        Container(
          color: Colors.red,
          alignment: Alignment.center,
          child: const Text('Page 1'),
        ),
        Container(
          color: Colors.green,
          alignment: Alignment.center,
          child: const Text('Page 2'),
        ),
        Container(
          color: Colors.blue,
          alignment: Alignment.center,
          child: const Text('Page 3'),
        ),
        const GalleryScreen(),
        Container(
          color: Colors.blue,
          alignment: Alignment.center,
          child: const Text('Page 5'),
        )
      ][currentPageIndex.value]),
    );
  }

  _onAvatarTap() {
      globalKey.currentState?.openDrawer();
  }
}