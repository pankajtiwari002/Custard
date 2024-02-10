import 'package:custard_flutter/controllers/MainController.dart';
import 'package:custard_flutter/controllers/ProfileController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  MainController mainController = Get.find();
  String uid;
  bool currentUser;
  ProfileController controller = Get.put(ProfileController());
  ProfileScreen({super.key, this.uid = "", this.currentUser = false}) {
    controller.isLoading.value = true;
    controller.isCurrentUser = currentUser;
    controller.uid = uid;
    controller.getProfileData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return Container();
        } else {
          return Stack(
            children: [
              Container(
                height: size.height * 0.55,
                width: double.infinity,
                child: Image.network(
                  currentUser
                      ? mainController.currentUser!.profilePic
                      : controller.user!.profilePic,
                  fit: BoxFit.cover,
                ),
              ),
              controller.isCurrentUser
                  ? Container()
                  : Container(
                      padding: EdgeInsets.only(top: 20),
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                    ),
              Container(
                alignment: Alignment.bottomCenter,
                height: MediaQuery.of(context).size.height,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.5,
                  padding: const EdgeInsets.only(
                    top: 32,
                    left: 24,
                    right: 24,
                    bottom: 32
                  ),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(height: 17,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentUser
                                    ? mainController.currentUser!.name
                                    : controller.user!.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF090B0E),
                                  fontSize: 16,
                                  fontFamily: 'Gilroy',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Container(
                                width: 100,
                                child: Stack(
                                  children: [
                                    SvgPicture.asset(
                                    "assets/images/Design_Badges.svg"),
                                    Positioned(
                                      left: 10,
                                      child: SvgPicture.asset(
                                      "assets/images/Design_Badges1.svg"),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          if (!currentUser)
                            SizedBox(
                              width: 120,
                              child: TextButton(
                                style: ButtonStyle(
                                  side: MaterialStateProperty.all(
                                      BorderSide(color: Color(0xFF7B61FF))),
                                ),
                                onPressed: () {},
                                child: const Text(
                                  'Chat now',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF7B61FF),
                                    fontSize: 16,
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      Text(
                        'Mutual Chapters',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF090B0E),
                          fontSize: 16,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              currentUser
                                  ? mainController.currentUser!.profilePic
                                  : controller.user!.profilePic,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              currentUser
                                  ? mainController.currentUser!.profilePic
                                  : controller.user!.profilePic,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              currentUser
                                  ? mainController.currentUser!.profilePic
                                  : controller.user!.profilePic,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'About',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF090B0E),
                          fontSize: 16,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        currentUser
                            ? mainController.currentUser!.bio
                            : controller.user!.bio,
                        style: TextStyle(
                          color: Color(0xFF546881),
                          fontSize: 14,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Skills',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF090B0E),
                          fontSize: 16,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Wrap(
                        spacing: 5,
                        children: [
                          Chip(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            label: Text('Photography'),
                          ),
                          Chip(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            label: Text('Designing'),
                          ),
                          Chip(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            label: Text('Web Dev'),
                          ),
                        ],
                      ),
                      Text(
                        'Socials',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF090B0E),
                          fontSize: 16,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Wrap(
                        spacing: 10,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            // color: Colors.red,
                            child: Image.network(
                              "https://img.freepik.com/premium-vector/purple-gradiend-social-media-logo_197792-1883.jpg",
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            // color: Colors.red,
                            child: Image.network(
                              "https://logowik.com/content/uploads/images/twitter-x5265.logowik.com.webp",
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            // color: Colors.red,
                            child: Image.network(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSXxbIq3iItCF95s2226mSDGDLsgOn0xWaTZg&usqp=CAU",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        }
      }),
    );
  }
}
