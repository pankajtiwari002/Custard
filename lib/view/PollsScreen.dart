import 'dart:math';

import 'package:custard_flutter/components/CustardButton.dart';
import 'package:custard_flutter/components/RadioButtonTile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../Global.dart';
import '../controllers/DiscussionController.dart';

class PollsScreen extends StatelessWidget {
  DiscussionController controller = Get.find();

  isAddNewField() {
    for (int i = 0; i < controller.options.length; i++) {
      if (controller.options[i].text.trim() == "") return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Poll',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Question',
                style: TextStyle(
                  color: Color(0xFF090B0E),
                  fontSize: 16,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextField(
                controller: controller.questionController,
                decoration: InputDecoration(
                  label: Text("Ask your Question"),
                ),
              ),
              Obx(
                () => ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: controller.options.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Icon(Icons.menu),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child: TextField(
                                controller: controller.options[index],
                                decoration: InputDecoration(
                                  label: Text("Type Your option"),
                                ),
                                onChanged: (val) {
                                  if (isAddNewField()) {
                                    controller.options
                                        .add(TextEditingController());
                                    controller.optionsLen.value =
                                        controller.options.length + 1;
                                  }
                                  if (val.trim() == "" &&
                                      controller.options.length > 2) {
                                    controller.options.removeAt(index);
                                    controller.optionsLen.value =
                                        controller.options.length - 1;
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              ),
              SizedBox(
                height: 10,
              ),
              ExpansionTile(
                title: Text("Polls Setting"),
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20)),
                collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.grey)),
                children: [
                  Obx(
                    () => SwitchListTile(
                      title: Text("Multiple Option"),
                      value: controller.isMultipleOption.value,
                      onChanged: (val) {
                        controller.isMultipleOption.value = val;
                      },
                    ),
                  ),
                  Obx(
                    () => SwitchListTile(
                      title: Text("Hide Live Result"),
                      value: controller.isHideLisveResult.value,
                      onChanged: (val) {
                        controller.isHideLisveResult.value = val;
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustardButton(
                onPressed: () async {
                  Map<String, dynamic>? mp = {
                    'question': controller.questionController.text,
                    'options': [],
                    'total': 0.obs,
                    'MultipleOptions': controller.isMultipleOption.value,
                    'HideLiveResult': controller.isHideLisveResult.value
                  };
                  if (controller.options.length <= 2) {
                    Get.snackbar("Minimum 2 option",
                        "There should be minimum 2 option in polls");
                    return;
                  }
                  for (int i = 0; i < controller.options.length - 1; i++) {
                    RxList<RxString> uid = RxList();
                    mp['options']
                        .add({'text': controller.options[i].text, 'uids': uid});
                  }
                  List<dynamic> options = [];
                  for(int i=0;i<mp['options'].length;i++){
                    Map<String,dynamic> option = {
                      'text': mp['options'][i]['text'],
                      'uids': []
                    };
                    options.add(option);
                  }
                  final DatabaseReference databaseReference = FirebaseDatabase
                      .instance
                      .ref()
                      .child("communityChats/chapterId/messages");
                  DatabaseReference newMessage = await databaseReference.push();
                  String messageId = newMessage.key!;
                  DateTime time = DateTime.now();
                  int epochTime = time.millisecondsSinceEpoch;
                  Map<String, dynamic> messageJson = {
                    "pollQuestion": controller.questionController.text,
                    'MultipleOptions': controller.isMultipleOption.value,
                    'HideLiveResult': controller.isHideLisveResult.value,
                    'pollOptions': options,
                    "total": 0,
                    "from": Global.currentUser!.uid,
                    "messageId": messageId,
                    "time": epochTime,
                    "type": "POLLS"
                  };

                  await newMessage.set(messageJson);
                  controller.messages.add(RxMap({
                    'profileUrl':
                        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y3VzdG9tZXIlMjBwcm9maWxlfGVufDB8fDB8fHww&w=1000&q=80',
                    'name': 'Pankaj',
                    'imageUrl': null,
                    'documentUrl': null,
                    'audioMessageUrl': null,
                    'polls': mp,
                    'textMessage': controller.messageController.text,
                    'repliedMessage': null,
                    'date': DateTime.now(),
                    'prevDate': DateTime.now().subtract(Duration(days: 2)),
                    'owner': true,
                    "isSelected": false
                  }));
                  Get.back();
                },
                buttonType: ButtonType.POSITIVE,
                label: "Send"),
            SizedBox(
              height: 5,
            ),
            TextButton(
                onPressed: () {},
                child: Text(
                  "Discard",
                  style: TextStyle(color: Colors.purple, fontSize: 16),
                ))
          ],
        ),
      ),
    );
  }
}
