import 'package:custard_flutter/controllers/AddPhotoController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddParticipationsScreens extends StatelessWidget {
  AddPhotoController controller = Get.find();

  isContains(RxList<Map<String, dynamic>> list, int id) {
    for (int i = 0; i < list.length; i++) {
      if (list[i]['id'] == id) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => controller.tempParticipants.length > 0 ? Text("${controller.tempParticipants.length} Person added") : Text('Add Participants'),),
        actions: [
          Obx(
            () => Visibility(
              visible: controller.tempParticipants.length > 0,
              child: TextButton(
                onPressed: () {
                  controller.participants.addAll(controller.tempParticipants);
                  controller.tempParticipants.value = [];
                  Get.back();
                },
                child: Text('save',style: TextStyle(fontSize: 18),),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: controller.members.length,
          itemBuilder: (context, index) {
            return Obx(() => ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage("assets/avatar.png"),
                    radius: 24,
                  ),
                  title: Text(controller.members[index]['name']),
                  trailing: TextButton(
                      onPressed: () {
                        if (!isContains(controller.participants, index)) {
                          print(1);
                          if (!isContains(controller.tempParticipants, index)) {
                            print(2);
                            controller.tempParticipants
                                .add(controller.members[index]);
                          } else {
                            print(3);
                            controller.tempParticipants.removeWhere(
                                (element) => element['id'] == index);
                          }
                        }
                      },
                      child: isContains(controller.participants, index)
                          ? Text(
                              'Added',
                              style: TextStyle(color: Colors.green),
                            )
                          : isContains(controller.tempParticipants, index)
                              ? Text(
                                  'Remove',
                                  style: TextStyle(color: Colors.red),
                                )
                              : Text('Add user')),
                ));
          }),
    );
  }
}
