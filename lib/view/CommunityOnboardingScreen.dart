import 'dart:typed_data';

import 'package:custard_flutter/components/CommunityCard.dart';
import 'package:custard_flutter/components/CustardTextField.dart';
import 'package:custard_flutter/components/SlideShowContainer.dart';
import 'package:custard_flutter/controllers/MainController.dart';
import 'package:custard_flutter/controllers/PhoneAuthController.dart';
import 'package:custard_flutter/utils/CustardColors.dart';
import 'package:custard_flutter/view/ChapterOboardingScreen.dart';
import 'package:custard_flutter/view/CongratsScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../components/CustardButton.dart';
import '../components/TitleBodyContainer.dart';
import '../controllers/CommunityOnboardingController.dart';
import '../utils/utils.dart';

class CommunityOnboardingScreen extends StatelessWidget {
  var controller = Get.put(CommunityOnboardingController());
  // MainController mainController = Get.find();
  PhoneAuthController phoneAuthController = Get.find();
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
    EasyLoading.show(status: "Creating...");
    // EasyLoading.dismiss();
    // print(mainController.currentUser.toString());
    bool res = await controller.createCommunity(phoneAuthController.uid.value);
    if (res) {
      EasyLoading.dismiss();
      Get.to(() => ChapterOboardingScreen());
    } else {
      EasyLoading.showError("Failed");
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
            buttonType: ButtonType.POSITIVE,
            label: "Next",
            backgroundColor: Color(0xFF7B61FF),
          ),
        ),
      ),
    );
  }

  _infoScreen() {
    return Column(
      children: [
        SvgPicture.asset("assets/images/Frame.svg"),
        SizedBox(
          height: 32,
        ),
        const Text('What is the name of your communtiy?',
            style: TextStyle(
              color: Color(0xFF141414),
              fontSize: 18,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w700,
            )),
        SizedBox(
          height: 18,
        ),
        CustardTextField(
            labelText: "Community Name", controller: controller.communityName,maxLength: 50,),
        SizedBox(
          height: 32,
        ),
        const Text('Write something about your community',
            style: TextStyle(
              color: Color(0xFF141414),
              fontSize: 18,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w700,
            )),
        SizedBox(
          height: 18,
        ),
        CustardTextField(
            labelText: "About Community",
            controller: controller.aboutCommunity,maxLength: 500,),
      ],
    );
  }

  _photoUploadScreen() {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                controller.currPage.value = controller.currPage.value - 1;
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
            Text(
              'Upload Community Profile Picture',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF090B0E),
                fontSize: 18,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 32,
        ),
        Obx(() => controller.image.value == null
            ? CircleAvatar(
                radius: 75,
                backgroundColor: Color(0xFF4F61FF),
                child: Text(
                  'D',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 78.10,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w700,
                  ),
                ))
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
                  if (file != null) {
                    final path = file.path;
                    CroppedFile? croppedFile = await ImageCropper().cropImage(
                      sourcePath: path,
                      aspectRatioPresets: [
                        CropAspectRatioPreset.square,
                        CropAspectRatioPreset.ratio3x2,
                        CropAspectRatioPreset.original,
                        CropAspectRatioPreset.ratio4x3,
                        CropAspectRatioPreset.ratio16x9
                      ],
                      uiSettings: [
                        AndroidUiSettings(
                            toolbarTitle: 'Edit',
                            toolbarColor: Color(0xff62c9d5),
                            toolbarWidgetColor: Colors.white,
                            initAspectRatio: CropAspectRatioPreset.square,
                            lockAspectRatio: true),
                        // IOSUiSettings(
                        //   title: 'Cropper',
                        // ),
                        // WebUiSettings(
                        //   context: context,
                        // ),
                      ],
                    );
                    if (croppedFile != null) {
                      controller.image.value = await croppedFile.readAsBytes();
                    }
                  }
                },
                child: Row(
                  children: [
                    SvgPicture.asset("assets/images/export.svg"),
                    Text(
                      ' Upload picture',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF7B61FF),
                        fontSize: 14,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
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
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
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
                          color: const Color(0xFF7B61FF),
                        ),
                        onDeleted: () {
                          controller.tags
                              .removeWhere((element) => (element == ele));
                        },
                        backgroundColor:
                            Color(0x217B61FF), // Background color of the chip
                        labelStyle:
                            TextStyle(color: Color(0xFF7B61FF)), // Text color
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
