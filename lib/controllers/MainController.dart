import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custard_flutter/data/models/community.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import '../repo/notificationservice/LocaNotificationService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/user.dart';
import '../utils/constants.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';

class MainController extends GetxController {
  var currentPageIndex = 0.obs;
  Rx<bool> loading = true.obs;
  Rx<String> role = "user".obs;
  late SharedPreferences prefs;
  String? currentCommunityId;
  Rx<Community?> currentCommunity = Rxn();
  User? currentUser;
  late var homeGlobalKey;

  Future<void> getCommunity(String id) async {
    currentCommunityId = id;
    final communityData = await FirebaseFirestore.instance
        .collection("communities")
        .doc(currentCommunityId)
        .get();
    final snap = await FirebaseFirestore.instance
        .collection("userCommunities")
        .where("community_id", isEqualTo: id)
        .where("uid", isEqualTo: currentUser!.uid)
        .get();
    if(snap.docs.length>0){
      role.value = snap.docs[0]['userRole'];
    }
    else{
      role.value = "admin";
    }
    currentCommunity.value = Community.fromSnap(communityData.data()!);
    print(currentCommunityId);
    print(currentUser!.uid);
    // print(currentCommunity.value!.chapters[0]);
  }

  getAllUsefulData() async {
    prefs = await SharedPreferences.getInstance();
    bool flag = prefs.getBool(Constants.isUserSignedInPref) != null &&
        prefs.getBool(Constants.isUserSignedInPref)!;
    print("Het");
    print(flag);
    if (flag) {
      try {
        print("current User");
        String userData = prefs.getString(Constants.usersPref)!;
        print("userData: " + userData);
        // Map<String,dynamic> mp = {"name": "pankaj","profilePic": "https://firebasestorage.googleapis.com/v0/b/custard-kmp.appspot"};
        Map<String, dynamic> data = jsonDecode(userData);
        print(data["name"].toString());
        currentUser = User.fromSnap(data);
        currentCommunityId = prefs.getString(Constants.currentCommunityId);
        final communityData = await FirebaseFirestore.instance
            .collection("communities")
            .doc(currentCommunityId)
            .get();
        currentCommunity.value = Community.fromSnap(communityData.data()!);
        final snap = await FirebaseFirestore.instance
            .collection("userCommunities")
            .where("community_id", isEqualTo: currentCommunityId)
            .where("uid", isEqualTo: currentUser!.uid)
            .get();
        role.value = snap.docs.length == 0 ? "user" : snap.docs[0]['userRole'];
        print("user: " + currentUser.toString());
        print(currentCommunityId);
        print(currentCommunity.value!.chapters[0]);
      } catch (e) {
        print(15);
        print(e.toString());
      }
    }
    loading.value = false;
  }

  @override
  void onInit() {
    loading.value = true;
    @override
    void onInit() {
      super.onInit();

      // 1. This method call when app in terminated state and you get a notification
      // when you click on notification app open from terminated state and you can get notification data in this method
      FirebaseMessaging.instance.getInitialMessage().then(
        (message) {
          print("FirebaseMessaging.instance.getInitialMessage");
          if (message != null) {
            print("New Notification");
            // if (message.data['_id'] != null) {
            //   Navigator.of(context).push(
            //     MaterialPageRoute(
            //       builder: (context) => DemoScreen(
            //         id: message.data['_id'],
            //       ),
            //     ),
            //   );
            // }
          }
        },
      );
      // 2. This method only call when App in forground it mean app must be opened
      FirebaseMessaging.onMessage.listen(
        (message) {
          print("FirebaseMessaging.onMessage.listen");
          if (message.notification != null) {
            print(message.notification!.title);
            print(message.notification!.body);
            print("message.data11 ${message.data}");
            LocalNotificationService().createanddisplaynotification(message);
          }
        },
      );

      // 3. This method only call when App in background and not terminated(not closed)
      FirebaseMessaging.onMessageOpenedApp.listen(
        (message) {
          print("FirebaseMessaging.onMessageOpenedApp.listen");
          if (message.notification != null) {
            print(message.notification!.title);
            print(message.notification!.body);
            print("message.data22 ${message.data['_id']}");
          }
        },
      );
    }

    getAllUsefulData();
    super.onInit();
  }
}
