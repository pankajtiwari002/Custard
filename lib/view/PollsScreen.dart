import 'package:custard_flutter/components/CustardButton.dart';
import 'package:custard_flutter/components/RadioButtonTile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/DiscussionController.dart';

class PollsScreen extends StatelessWidget {
  DiscussionController controller = Get.find();

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
            Row(
              children: [
                Icon(Icons.menu),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: TextField(
                      controller: controller.options[0],
                      decoration: InputDecoration(
                        label: Text("Type Your option"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.menu),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: TextField(
                      controller: controller.options[1],
                      decoration: InputDecoration(
                        label: Text("Type Your option"),
                      ),
                    ),
                  ),
                ),
              ],
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
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustardButton(
                onPressed: () {
                  Map<String,dynamic>? mp = {
                    'question': controller.questionController.text,
                    'options': [],
                    'total': 0.obs
                  };
                  for(int i=0;i<controller.options.length;i++){
                    RxList<RxString> uid = RxList();
                    mp['options'].add({
                      'text': controller.options[i].text,
                      'uid': uid
                    });
                  }
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
