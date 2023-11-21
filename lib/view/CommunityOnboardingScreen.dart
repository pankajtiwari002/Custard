import 'dart:typed_data';

import 'package:custard_flutter/components/CommunityCard.dart';
import 'package:custard_flutter/components/CustardTextField.dart';
import 'package:custard_flutter/components/SlideShowContainer.dart';
import 'package:custard_flutter/utils/CustardColors.dart';
import 'package:custard_flutter/view/ChapterOboardingScreen.dart';
import 'package:custard_flutter/view/CongratsScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../components/CustardButton.dart';
import '../components/TitleBodyContainer.dart';
import '../controllers/CommunityOnboardingController.dart';
import '../utils/utils.dart';

class CommunityOnboardingScreen extends StatelessWidget {
  var controller = Get.put(CommunityOnboardingController());
  var selectedImage = Rxn<File>();
  CommunityOnboardingScreen({super.key});

  void onFinish() {
    Get.to(CongratsScreen(
      backgroundColor: Colors.red,
      image: const AssetImage('assets/avatar.png'),
      next: ChapterOboardingScreen(),
      message: 'Congratulation! \n Your profile is created',
      label: 'Join a Community',
      onPressed: onPressed,
    ));
  }

  Future<void> onPressed() async {
    bool res = await controller.createCommunity();
    if (res) {
      Get.to(() => ChapterOboardingScreen());
    } else {
      print("failed.........");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: SlideShowContainer(
            widgets: [_infoScreen(), _photoUploadScreen(), _tags()],
            onFinish: () {},
            controller: controller,
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: CustardButton(
              onPressed: () {
                if (controller.currPage.value < 2) {
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

  _infoScreen() {
    return Column(
      children: [
        const Text('What is the name of your communtiy?',
            style: TextStyle(
              color: Color(0xFF141414),
              fontSize: 18,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w700,
            )),
        CustardTextField(
            labelText: "Community Name", controller: controller.communityName),
        const Text('Write something about your community',
            style: TextStyle(
              color: Color(0xFF141414),
              fontSize: 18,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w700,
            )),
        CustardTextField(
            labelText: "About Community",
            controller: controller.aboutCommunity),
      ],
    );
  }

  _photoUploadScreen() {
    return Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          child: IconButton(
            onPressed: () {
              controller.currPage.value = controller.currPage.value - 1;
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
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

  _tags() {
    return Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          child: IconButton(
            onPressed: () {
              controller.currPage.value = controller.currPage.value - 1;
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
        Text(
          'Tags',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Color(0xFF090B0E),
              fontSize: 18,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w700),
        ),
        TextFormField(
            controller: controller.tagController,
            decoration: InputDecoration(
              label: Text("Community about"),
              hintText: "What is your Community About",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
            onFieldSubmitted: (value) {
              controller.tags.add(value);
              controller.tagController.text = "";
            }),
        SizedBox(
          height: 15,
        ),
        Obx(() => Wrap(
              children: controller.tags
                  .map(
                    (ele) => Container(
                      margin: const EdgeInsets.all(8),
                      child: Chip(
                        label: Text(ele),
                        deleteIcon: Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),
                        onDeleted: () {
                          controller.tags
                              .removeWhere((element) => (element == ele));
                        },
                        backgroundColor:
                            Colors.purple.withOpacity(0.3), // Background color of the chip
                        labelStyle:
                            TextStyle(color: CustardColors.appTheme), // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20.0), // Adjust the border radius as needed
                          side: BorderSide(
                              color: Colors.blue), // Border color and width
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ))
      ],
    );
  }
}
