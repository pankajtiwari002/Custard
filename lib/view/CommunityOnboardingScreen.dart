import 'package:custard_flutter/components/CommunityCard.dart';
import 'package:custard_flutter/components/CustardTextField.dart';
import 'package:custard_flutter/components/SlideShowContainer.dart';
import 'package:custard_flutter/view/ChapterOboardingScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../components/TitleBodyContainer.dart';
import '../controllers/CommunityOnboardingController.dart';

class CommunityOnboardingScreen extends StatelessWidget {
  var controller = Get.put(CommunityOnboardingController());
  var selectedImage = Rxn<File>();

  CommunityOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SlideShowContainer(
          widgets: [
            _infoScreen(),
            _photoUploadScreen(),
            _tags()
          ],
          onFinish: () {
            Get.to(ChapterOboardingScreen());
          }
        ),
      ),
    );
  }

  _infoScreen() {
    return Column(
      children: [
        const Text(
          'What is the name of your communtiy?',
          style: TextStyle(
            color: Color(0xFF141414),
            fontSize: 18,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w700,
          )
        ),
        CustardTextField(
            labelText: "Community Name",
            controller: controller.communityName
        ),
        const Text(
            'Write something about your community',
            style: TextStyle(
              color: Color(0xFF141414),
              fontSize: 18,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w700,
            )
        ),
        CustardTextField(
            labelText: "About Community",
            controller: controller.aboutCommunity
        ),
      ],
    );
  }

  _photoUploadScreen() {
    return Column(
      children: [
        TitleBodyContainer(
            "Hi! Priya Bhatt",
            "It’s your brand new profile! Wanna change it up? You can do that from your account settings."
        ),
        Obx(() =>  selectedImage.value == null ?
          CircleAvatar(
            radius: 75,
            backgroundImage: AssetImage('assets/avatar.png'),
          )
            :
          CircleAvatar(
            radius: 75,
            backgroundImage: FileImage(selectedImage.value!),
          )
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  _pickImage();
                },
                child: const Row(
                  children: [
                    Icon(Icons.upload),
                    Text("Upload picture")
                  ],
                )
            )
          ],
        )
      ],
    );
  }

  _tags() {
    return Column(
      children: [
        Text(
          'Tags',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF090B0E),
            fontSize: 18,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w700
          ),
        ),
        CustardTextField(
            labelText: "Community Name",
            controller: controller.tags
        )
      ],
    );
  }

  Future _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(image == null) return;
    selectedImage.value = File(image.path);
  }
}