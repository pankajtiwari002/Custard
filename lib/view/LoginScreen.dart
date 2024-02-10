import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custard_flutter/components/CustardButton.dart';
import 'package:custard_flutter/components/OtpContainer.dart';
import 'package:custard_flutter/components/PhoneContainer.dart';
import 'package:custard_flutter/components/TitleBodyContainer.dart';
import 'package:custard_flutter/controllers/MainController.dart';
import 'package:custard_flutter/view/ChapterOboardingScreen.dart';
import 'package:custard_flutter/view/CommunityOnboardingScreen.dart';
import 'package:custard_flutter/view/HomeScreen.dart';
import 'package:custard_flutter/view/UserOnboardingScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/PhoneAuthController.dart';
import '../repo/FirestoreMethods.dart';
import '../utils/constants.dart';

class LoginScreen extends StatelessWidget {
  final controller = Get.put(PhoneAuthController());
  MainController mainController = Get.find();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Custard.',
                style: TextStyle(
                  color: Color(0xFF7B61FF),
                  fontSize: 30,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              const Image(image: AssetImage('assets/temp.png')),
              SizedBox(
                height: 20,
              ),
              GetBuilder<PhoneAuthController>(builder: (_) {
                return controller.isOtpSent
                    ? TitleBodyContainer('Enter OTP',
                        'Confirm your OTP sent to ${controller.phoneNumber.text}')
                    : TitleBodyContainer('Sign Up with your phone number',
                        'Only the community you join can see your phone number');
              }),
              SizedBox(
                height: 40,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: GetBuilder<PhoneAuthController>(
                  builder: (_) => Material(
                    child: controller.isOtpSent
                        ? OtpContainer()
                        : PhoneContainer(),
                  ),
                ),
              ),
              // const Spacer(
              // flex: 1,
              // ),
            ],
          ),
        ),
        bottomNavigationBar: GetBuilder<PhoneAuthController>(builder: (_) {
          return !controller.isOtpSent
              ? Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 10)
                          .copyWith(top: 0),
                  child: CustardButton(
                    onPressed: () async {
                      try {
                        controller.seconds.value=59;
                        controller.startTimer();
                        await controller.sendOtp();
                      } catch (e) {
                        log(e.toString());
                      }
                    },
                    buttonType: ButtonType.POSITIVE,
                    label: 'Continue',
                    backgroundColor: Color(0xFF7B61FF),
                  ),
                )
              : Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 10)
                          .copyWith(top: 0),
                  child: CustardButton(
                    onPressed: () async {
                      try {
                        bool flag = await controller.verifyOtp();
                        if (flag) {
                          DocumentSnapshot snapshot = await FirebaseFirestore
                              .instance
                              .collection("users")
                              .doc(controller.uid.value)
                              .get();
                          if (snapshot.exists) {
                            if (snapshot.get("isFirstTime")) {
                              Get.to(() => CommunityOnboardingScreen());
                            controller.isOtpSent = false;
                            } else {
                              print(11);
                              final snap = await FirestoreMethods()
                                  .getData("users", controller.uid.value);
                              final prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString(
                                  Constants.usersPref, jsonEncode(snap));
                              prefs.setBool(Constants.isUserSignedInPref, true);
                              print(12);
                              String communityId = snap['communities'][0];
                              prefs.setString(Constants.currentCommunityId,
                                  communityId);
                              print(13);
                              await mainController
                                  .getAllUsefulData();
                              print(14);
                              Get.to(() => HomeScreen());
                            controller.isOtpSent = false;
                            }
                          } else {
                            Get.to(() => UserOnboardingScreen());
                            controller.isOtpSent = false;
                          }
                        } else {
                          throw Error();
                        }
                      } catch (e) {
                        print(15);
                        log(e.toString());
                      }
                    },
                    label: 'Verify and Continue',
                    buttonType: ButtonType.POSITIVE,
                    backgroundColor: Color(0xFF7B61FF),
                  ),
                );
        }),
      ),
    );
  }
}
