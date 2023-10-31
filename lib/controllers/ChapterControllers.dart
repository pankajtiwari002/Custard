import 'package:custard_flutter/data/models/chapter.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../repo/FirestoreMethods.dart';

class ChapterControllers extends GetxController {
  var locationController = TextEditingController();
  var bioController = TextEditingController();
  var priceController = TextEditingController();
  var memberApproval = false;
  Rx<int> tabSelected = 0.obs;

  Future<bool> createChapter() async {
    try {
      String chapter_id = Uuid().v1();
      Chapter chapter = Chapter(
        aboutChapter: bioController.text,
        analiticsID: "analiticsID",
        approvalFlow: "approvalFlow",
        approvalRequired: "approvalRequired",
        chapter_id: chapter_id,
        community_id: "bRDU2SzTa6qhmaLN5gkt",
        location: locationController.text,
        price: tabSelected.value==0 ? priceController.text : "0.0",
        theme: "theme",
      );
      await FirestoreMethods().onSave("chapters", chapter.toJson(),chapter_id);
      return true;
    } catch (e) {
      return false;
    }
  }
}
