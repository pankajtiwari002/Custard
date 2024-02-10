import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custard_flutter/components/CustardButton.dart';
import 'package:custard_flutter/components/CustardTextField.dart';
import 'package:custard_flutter/controllers/JoinCommunityController.dart';
import 'package:custard_flutter/controllers/MainController.dart';
import 'package:custard_flutter/controllers/PhoneAuthController.dart';
import 'package:custard_flutter/data/models/UserCommunity.dart';
import 'package:custard_flutter/repo/FirestoreMethods.dart';
import 'package:custard_flutter/utils/constants.dart';
import 'package:custard_flutter/view/HomePage.dart';
import 'package:custard_flutter/view/HomeScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JoinCommunityScreen extends StatelessWidget {
  JoinCommunityController controller = Get.put(JoinCommunityController());
  // PhoneAuthController phoneAuthController = Get.find();
  MainController mainController = Get.find();

  void openMyDialog() {
    Get.dialog(Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Get.back(); // Close the dialog
                  },
                ),
              ],
            ),
            Text(
              'Hi! Priya Bhatt',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              'You have a referral to join this community',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  openBottomSheet();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF665EE0)),
                child: Text('Request to Join',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
            TextButton(
              onPressed: () {
                // Explore Only Button Pressed
              },
              child: Text('Explore Only',
                  style: TextStyle(color: Color(0xFF665EE0))),
            ),
          ],
        ),
      ),
    ));
  }

  void openBottomSheet() {
    Get.bottomSheet(
      ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Hi! Priya Bhatt',
                  style: TextStyle(
                    color: Color(0xFF090B0E),
                    fontSize: 24,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Do you have a referral to join this communtiy?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF090B0E),
                    fontSize: 12,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 30),
                CustardTextField(
                    labelText: "Write the referral Code",
                    controller: controller.referralController),
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF665EE0)),
                    child:
                        Text('Join Now', style: TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(height: 8.0),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Explore Only',
                    style: TextStyle(color: Color(0xFF665EE0)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Recommended Communities',
                style: TextStyle(
                  color: Color(0xFF141414),
                  fontSize: 18,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 5,
              ),
              FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("communities")
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active ||
                        snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: ((context, index) {
                              return customCard(snapshot.data!.docs[index]);
                            }));
                      } else
                        return Container();
                    } else
                      return Container();
                  }),
              SizedBox(
                height: 5,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Start with your 15 days free trial. *',
                      style: TextStyle(
                        color: Color(0xFF090B0E),
                        fontSize: 12,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    TextSpan(
                      text: 'No Credit Card Needed',
                      style: TextStyle(
                        color: Color(0xFF090B0E),
                        fontSize: 12,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                    TextSpan(
                      text: '*',
                      style: TextStyle(
                        color: Color(0xFF090B0E),
                        fontSize: 12,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }

  customCard(QueryDocumentSnapshot snap) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white,
      elevation: 1,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              snap.get('communityProfilePic'), // Add your image URL here
              fit: BoxFit.cover,
              width: 300,
              height: 150,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
            child: Text(
              snap.get('communityName'),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0).copyWith(top: 3),
            child: Text(
              snap.get('communityAbout'),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'INR 99',
                    style: TextStyle(
                      color: Color(0xFF546881),
                      fontSize: 14,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Joining Fee',
                    style: TextStyle(
                      color: Color(0xFF546881),
                      fontSize: 12,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '1200+',
                    style: TextStyle(
                      color: Color(0xFF546881),
                      fontSize: 14,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Joined',
                    style: TextStyle(
                      color: Color(0xFF546881),
                      fontSize: 12,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Social Dance Tribe Host',
                    style: TextStyle(
                      color: Color(0xFF546881),
                      fontSize: 14,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Community Creator',
                    style: TextStyle(
                      color: Color(0xFF546881),
                      fontSize: 12,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Obx(
            () => Visibility(
              visible: !controller.isCardExpanded.contains(snap.id),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      // Explore Button Pressed
                      controller.isCardExpanded.add(snap.id);
                    },
                    child: Text('Explore the Community'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF7B61FF),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      try {
                        print(1);
                        UserCommunity userCommunity = UserCommunity(
                            chapters: snap.get("chapters"),
                            communityId: snap.id,
                            leaderboards: "leaderboards",
                            onboardingAnswers: "onboardingAnswers",
                            permissions: "permissions",
                            status: "status",
                            streak: "streak",
                            uid: mainController.currentUser!.uid,
                            userRole: "user");
                            print("userCommunity");
                        print(2);
                        await FirestoreMethods()
                            .onSave("userCommunities", userCommunity.toJson());
                            print(3);
                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(mainController.currentUser!.uid)
                            .update({
                          "communities": FieldValue.arrayUnion([snap.id]), 
                        });
                        print(4);
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString(Constants.currentCommunityId, snap.id);
                        print(5);
                        mainController.currentUser!.communities.add(snap.id);
                        prefs.setString(Constants.usersPref, jsonEncode(mainController.currentUser!.toJson()));
                        print(6);
                        await mainController.getAllUsefulData();
                        Get.offAll(() => HomeScreen());
                      } catch (e) {
                        print(7);
                        print(e.toString());
                      }
                      // openMyDialog();
                    },
                    child: Text(
                      'Join Now',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () => Visibility(
                visible: controller.isCardExpanded.contains(snap.id),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        imageCotainer(),
                        imageCotainer(),
                        imageCotainer(),
                        imageCotainer(),
                        imageCotainer(),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7B61FF),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            openMyDialog();
                          },
                          child: const Text("Join the Community",
                              style: TextStyle(color: Colors.white))),
                    )
                  ],
                )),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

imageCotainer() {
  return Container(
    height: 50,
    width: 50,
    decoration: BoxDecoration(
      image: DecorationImage(
          image: NetworkImage(
              "https://i0.wp.com/www.heyuguys.com/images/2021/05/The-Get-Together.jpg?fit=1500%2C844&ssl=1"),
          fit: BoxFit.cover),
      borderRadius: BorderRadius.circular(5),
    ),
  );
}
