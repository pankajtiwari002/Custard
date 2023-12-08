import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:custard_flutter/components/CustardButton.dart';
import 'package:custard_flutter/components/CustardTextField.dart';
import 'package:custard_flutter/controllers/PhoneAuthController.dart';
import 'package:custard_flutter/controllers/UserOnboardingController.dart';
import 'package:custard_flutter/utils/CustardColors.dart';
import 'package:custard_flutter/utils/utils.dart';
import 'package:custard_flutter/view/CommunityOnboardingScreen.dart';
import 'package:custard_flutter/view/CongratsScreen.dart';
import 'package:custard_flutter/view/HomeScreen.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

import '../components/SlideShowContainer.dart';
import '../components/TitleBodyContainer.dart';
import 'JoinCommunityScreen.dart';

class UserOnboardingScreen extends StatelessWidget {
  // var selectedImage = Rxn<File>();
  late UserOnboardingController controller;
  PhoneAuthController phoneAuthController = Get.find();
  UserOnboardingScreen({super.key});

  onFinish() {
    Get.to(CongratsScreen(
      backgroundColor: Colors.red,
      image: const AssetImage('assets/avatar.png'),
      next: JoinCommunityScreen(),
      message: 'Congratulation! \n Your profile is created',
      label: 'Join a Community',
      onPressed: onPressed,
    ));
  }

  Future<void> onPressed() async {
    bool res = await controller.joinUser();
    if (res) {
      Get.offAll(HomeScreen());
    } else {
      print("failed.........");
    }
  }

  @override
  Widget build(BuildContext context) {
    controller = Get.put(UserOnboardingController(uid: phoneAuthController.uid.value, context: context));
    controller.phone = phoneAuthController.phoneNumber.text;
    controller.isVerified = true;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
            padding: const EdgeInsets.all(12),
            child: SlideShowContainer(
                widgets: [
                  _nameScreen(),
                  _genderScreen(),
                  _photoScreen(),
                  _bioScreen(),
                  _locationScreen()
                ],
                onFinish: () {},
                controller: controller,
              ),
            ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: CustardButton(
              onPressed: () {
                if (controller.currPage.value < 4) {
                  controller.currPage.value = controller.currPage.value + 1;
                } else {
                  onFinish();
                  Get.snackbar("title", "message");
                }
              },
              buttonType: ButtonType.NEGATIVE,
              label: "Next"),
        ),
      ),
    );
  }

  _nameScreen() {
    return Column(
      children: [
        TitleBodyContainer("Hi! Priya Bhatt",
            "It’s your brand new profile! Wanna change it up? You can do that from your account settings."),
        const SizedBox(height: 24),
        CustardTextField(
            labelText: "Name", controller: controller.nameController)
      ],
    );
  }

  _genderScreen() {
    return Column(
      children: [
        TitleBodyContainer("Hi! Prteek",
            "It’s your brand new profile! Wanna change it up? You can do that from your account settings."),
        const SizedBox(height: 24),
        CustomRadioButton(
          buttonLables: const ["Male", "Female", "Others"],
          buttonValues: const ["MALE", "FEMALE", "OTHERS"],
          radioButtonValue: (value) {
            controller.gender.value = value;
            Get.snackbar("title", value);
          },
          height: 50,
          horizontal: true,
          unSelectedColor: Colors.white,
          selectedColor: CustardColors.appTheme,
          enableShape: true,
        )
      ],
    );
  }

  _photoScreen() {
    return Column(
      children: [
        TitleBodyContainer("Hi! Priya Bhatt",
            "It’s your brand new profile! Wanna change it up? You can do that from your account settings."),
        Obx(() => controller.image.value == null
            ? CircleAvatar(
                radius: 75,
                backgroundImage: AssetImage('assets/avatar.png'),
              )
            : CircleAvatar(
                radius: 75,
                backgroundImage: MemoryImage(controller.image.value!),
              )),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () async {
                   XFile? file = await pickImage(ImageSource.gallery);
                  Uint8List? image = null;
                  if(file!=null){
                    image = await file.readAsBytes();
                  }
                  controller.image.value = image;
                },
                child: const Row(
                  children: [Icon(Icons.upload), Text("Upload picture")],
                ))
          ],
        )
      ],
    );
  }

  _bioScreen() {
    return Column(
      children: [
        TitleBodyContainer("Hi! Priya Bhatt",
            "It’s your brand new profile! Wanna change it up? You can do that from your account settings."),
        CustardTextField(labelText: "Bio", controller: controller.bioController)
      ],
    );
  }

  _locationScreen() {
    print("city: ");
    log(controller.city);
    return Column(
      children: [
        TitleBodyContainer("Hi! Priya Bhatt",
            "It’s your brand new profile! Wanna change it up? You can do that from your account settings."),
        SizedBox(
          height: 50,
        ),
        Container(
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    'https://img.freepik.com/free-vector/location_53876-25530.jpg?w=2000')),
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
          ),
        )
      ],
    );
  }
}
