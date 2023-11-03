import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:custard_flutter/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:workmanager/workmanager.dart';

class GroupCreationController extends GetxController {
  var grpName = TextEditingController();
  RxList<Uint8List> images = RxList();
  List<String> imagePaths = [];
  RxList<Map<String, dynamic>> members = [
    {"id": 0, "name": "Priya Bhatt"},
    {"id": 1, "name": "Priya Bhatt"},
    {"id": 2, "name": "Priya Bhatt"},
    {"id": 3, "name": "Priya Bhatt"},
    {"id": 4, "name": "Priya Bhatt"},
  ].obs;
  RxList<Map<String, dynamic>> participants = RxList();
  RxList<Map<String, dynamic>> tempParticipants = RxList();

  List<String> convertUint8ListImagesToStrings(List<Uint8List> Images) {
    List<String> encodedImages = [];
    for (var img in Images) {
      String encodedImage = base64Encode(img);
      encodedImages.add(encodedImage);
    }
    return encodedImages;
  }

  Future<void> uploadMutipleImages() async {
    // List<String> Images = convertUint8ListImagesToStrings(images.value);
    // Map<String, dynamic> mp = {"images": Images};
    String uniqueId = Uuid().v1();
    // print("Conversion Successful");
    // print(Images.toString());
    // await Workmanager().registerOneOffTask(uniqueId, Constants.photosUpload,
    //     constraints: Constraints(networkType: NetworkType.connected),
    //     inputData: mp);
    // print("Pankaj\nTiwari");
    print(imagePaths.toString());
     await Workmanager().registerOneOffTask("1", Constants.photosUpload,
        constraints: Constraints(networkType: NetworkType.connected,),
        inputData: {'imagePaths' : imagePaths});
    // images.value = [];
  }
}
