import 'dart:typed_data';
import 'package:custard_flutter/data/models/UserCommunity.dart';
import 'package:custard_flutter/data/models/community.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../repo/FirestoreMethods.dart';
import '../repo/StorageMethods.dart';

class CommunityOnboardingController extends GetxController {
  Rx<int> currPage = 0.obs;
  var communityName = TextEditingController();
  var aboutCommunity = TextEditingController();
  var tagController = TextEditingController();
  Rx<Uint8List?> image = Rxn();
  RxList<String> tags = RxList();
  var communityId;

  Future<bool> createCommunity(String uid) async {
    try {
      String galleryId = Uuid().v1();
      print(1);
      String communityImageUrl = await StorageMethods.uploadImageToStorage(
          "community", galleryId, image.value!);
      Community community = Community(
        benefits: "benefits",
        chapters: [],
        communityAbout: aboutCommunity.text,
        communityName: communityName.text,
        communityLink: "Link",
        communityProfilePic: communityImageUrl,
        galleryId: galleryId,
        tags: tags,
        theme: "theme",
      );
      print(2);
      communityId = Uuid().v1();
      UserCommunity userCommunity = UserCommunity(
        chapters: [],
        communityId: communityId,
        leaderboards: "leaderboards",
        onboardingAnswers: "onboardingAnswers",
        permissions: "permissions",
        status: "status",
        streak: "streak",
        uid: uid,
        userRole: "admin",
      );
      print(3);
      await FirestoreMethods()
          .onSave("communities", community.toJson(), communityId);
      print(4);
      await FirestoreMethods().onSave(
        "userCommunities",
        userCommunity.toJson()
      );
      return true;
    } catch (e) {
      print(5);
      return false;
    }
  }
}
