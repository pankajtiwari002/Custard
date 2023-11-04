import 'dart:typed_data';
import 'package:custard_flutter/data/models/community.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../repo/FirestoreMethods.dart';
import '../repo/StorageMethods.dart';

class CommunityOnboardingController extends GetxController {
  var communityName = TextEditingController();
  var aboutCommunity = TextEditingController();
  var tagController = TextEditingController();
  Rx<Uint8List?> image = Rxn();
  RxList<String> tags = RxList();

  Future<bool> createCommunity() async {
    try {
      String communityImageUrl =
          await StorageMethods.uploadImageToStorage("profile", "SD", image.value!);
      String galleryId = Uuid().v1();
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

      await FirestoreMethods().onSave("communities", community.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }
}
