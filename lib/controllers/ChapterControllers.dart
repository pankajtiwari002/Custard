import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custard_flutter/data/models/chapter.dart';
import 'package:custard_flutter/data/models/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../repo/FirestoreMethods.dart';
import '../utils/constants.dart';

class ChapterControllers extends GetxController {
  Rx<int> currPage = 0.obs;
  var locationController = TextEditingController();
  var bioController = TextEditingController();
  var priceController = TextEditingController();
  Rx<int> tabSelected = 0.obs;
  User? user;
  Rx<bool> memberApproval = false.obs;

  Future<bool> createChapter(String uid, String communityId) async {
    try {
      String chapter_id = Uuid().v1();
      Chapter chapter = Chapter(
        aboutChapter: bioController.text,
        analiticsID: "analiticsID",
        approvalFlow: "approvalFlow",
        approvalRequired: "approvalRequired",
        chapter_id: chapter_id,
        community_id: communityId,
        location: locationController.text,
        price: tabSelected.value == 0 ? priceController.text : "0.0",
        theme: "theme",
      );
      await FirestoreMethods().onSave("chapters", chapter.toJson(), chapter_id);
      await FirestoreMethods().updateData("users", uid, {"isFirstTime": false});
      final snap = await FirebaseFirestore.instance
          .collection("userCommunities")
          .where("uid", isEqualTo: uid)
          .where("community_id", isEqualTo: communityId)
          .get();
      
      List<dynamic> chapters = snap.docs[0]['chapters'].toList();
      chapters.add(chapter_id);
      await FirestoreMethods().updateData(
          "userCommunities", snap.docs[0].id, {"chapters": chapters});
      await FirestoreMethods().updateData("communities", communityId, {"chapters": chapters});
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> usr = await FirestoreMethods().getData("users", uid);
      user = User.fromSnap(usr);
      prefs.setString(Constants.currentCommunityId, communityId);
      prefs.setString(Constants.usersPref, jsonEncode(user!.toJson()));
      prefs.setBool(Constants.isUserSignedInPref, true);
      return true;
    } catch (e) {
      return false;
    }
  }
}
