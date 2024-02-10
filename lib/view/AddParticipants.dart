import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custard_flutter/controllers/GroupCreationController.dart';
import 'package:flutter/cupertino.dart';
import '../controllers/MainController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddParticipationsScreens extends StatelessWidget {
  GroupCreationController controller = Get.find();
  MainController mainController = Get.find();

  isContains(RxList<Rx<String>> list, Rx<String> id) {
    return list.contains(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => controller.tempParticipants.length > 0
              ? Text("${controller.tempParticipants.length} Person added")
              : Text('Add Participants'),
        ),
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
                child: Text(
                  'save',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("userCommunities")
            .where('community_id', isEqualTo: mainController.currentCommunityId)
            .where('chapters',
                arrayContains:
                    mainController.currentCommunity.value!.chapters[0])
            .get(),
        builder: ((context, snapshot) {
          if ((snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) &&
              snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, index) {
                return FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("users")
                        .doc(snapshot.data!.docs[index]['uid'])
                        .get(),
                    builder: (context, snap) {
                      if ((snap.connectionState == ConnectionState.active ||
                              snap.connectionState == ConnectionState.done) &&
                          snap.hasData) {
                        return ListTile(
                          title: Text(snap.data!['name']),
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(snap.data!['profilePic']),
                            radius: 16,
                          ),
                          trailing: TextButton(onPressed: () {
                            if (!isContains(controller.participants,
                                snap.data!.id.obs)) {
                              if (isContains(controller.tempParticipants,
                                  snap.data!.id.obs)) {
                                controller.tempParticipants.removeWhere(
                                    (element) =>
                                        element ==
                                        snap.data!.id.obs);
                              } else {
                                controller.tempParticipants
                                    .add(snap.data!.id.obs);
                              }
                            }
                          }, child: Obx(() {
                            if (isContains(controller.participants,
                                snap.data!.id.obs)) {
                              return Text(
                                'Added',
                                style: TextStyle(color: Colors.green),
                              );
                            }

                            if (isContains(controller.tempParticipants,
                                snap.data!.id.obs)) {
                              return Text(
                                'Remove',
                                style: TextStyle(color: Colors.red),
                              );
                            }
                            return Text('Add user');
                          })),
                        );
                      }
                      return Container();
                    });
              },
            );
          }
          return Container();
        }),
      ),
      // body: ListView.builder(
      //     itemCount: controller.members.length,
      //     itemBuilder: (context, index) {
      //       return Obx(() => ListTile(
      //             leading: CircleAvatar(
      //               backgroundImage: AssetImage("assets/avatar.png"),
      //               radius: 24,
      //             ),
      //             title: Text(controller.members[index]['name']),
      //             trailing: TextButton(
      //                 onPressed: () {
      //                   if (!isContains(controller.participants, index)) {
      //                     print(1);
      //                     if (!isContains(controller.tempParticipants, index)) {
      //                       print(2);
      //                       controller.tempParticipants
      //                           .add(controller.members[index]);
      //                     } else {
      //                       print(3);
      //                       controller.tempParticipants.removeWhere(
      //                           (element) => element['id'] == index);
      //                     }
      //                   }
      //                 },
      //                 child: isContains(controller.participants, index)
      //                     ? Text(
      //                         'Added',
      //                         style: TextStyle(color: Colors.green),
      //                       )
      //                     : isContains(controller.tempParticipants, index)
      //                         ? Text(
      //                             'Remove',
      //                             style: TextStyle(color: Colors.red),
      //                           )
      //                         : Text('Add user')),
      //           ));
      //     }),
    );
  }
}
