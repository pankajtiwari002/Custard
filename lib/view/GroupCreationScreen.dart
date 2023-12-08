import 'dart:typed_data';

import 'package:custard_flutter/components/CustardButton.dart';
import 'package:custard_flutter/components/CustardTextField.dart';
import 'package:custard_flutter/components/UserPhotosContainer.dart';
import 'package:custard_flutter/utils/constants.dart';
import 'package:custard_flutter/controllers/GroupCreationController.dart';
import 'package:custard_flutter/repo/notificationservice/LocaNotificationService.dart';
import 'package:custard_flutter/view/AddParticipants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../components/PhotosContainer.dart';

class GroupCreationScreen extends StatelessWidget {
  var controller = Get.put(GroupCreationController());
  RxList<Uint8List> images = RxList();
  GroupCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF242424),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              Get.back();
            }),
        title: Text(
          'Social Dance Tribe',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text('Group name',
                  style: TextStyle(
                      color: Color(0xFF141414),
                      fontSize: 16,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w600)),
              Material(
                child: CustardTextField(
                    labelText: "name", controller: controller.grpName),
              ),
              // Expanded(
              //   child: GridView.count(
              //     crossAxisCount: 3,
              //     children: List.generate(100, (index) {
              //       return Center(
              //         child: _photoTile(),
              //       );
              //     }),
              //   )
              // ),
              SizedBox(
                height: 10,
              ),
              PhotosContainer(),
              Divider(),
              SizedBox(
                height: 10,
              ),
              Text(
                'Participants',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF090B0E),
                  fontSize: 18,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Obx(
                () => ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.participants.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage("assets/avatar.png"),
                          radius: 24,
                        ),
                        title: Text(controller.participants[index]['name']),
                        trailing: Text(
                          'Added',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF00BC32),
                            fontSize: 12,
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }),
              ),
              // Spacer(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: CustardButton(
                  onPressed: () async {
                    Get.to(AddParticipationsScreens());
                    // LocalNotificationService().showProgressNotification();
                  },
                  buttonType: ButtonType.NEGATIVE,
                  label: "Add Participants"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: CustardButton(
                  onPressed: () async {
                    // OneSignal.Notifications.displayNotification(Constants.fCMToken);
                    print("Start Uploading");
                    await controller.uploadMutipleImages();
                    print("End uploading");
                  },
                  buttonType: ButtonType.NEGATIVE,
                  label: "Upload Images"),
            ),
          ],
        ),
      ),
    );
  }

  _photoTile() {
    return Image(image: NetworkImage("https://via.placeholder.com/100x100"));
  }
}
