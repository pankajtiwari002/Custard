import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:custard_flutter/constants.dart';
import 'package:custard_flutter/data/models/gallery.dart';
import 'package:custard_flutter/repo/FirestoreMethods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
    try {
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
          constraints: Constraints(
            networkType: NetworkType.connected,
          ),
          inputData: {'imagePaths': imagePaths});
      // images.value = [];
    } catch (e) {
      print("Hello error $e");
    }
  }

  Future<void> uploadOnFirestore(List<String> imageUrls) async {
    try {
      // var user = await FirebaseAuth.instance.signInAnonymously();
      // log("upload on firestore");
      String galleryId = Uuid().v1();
      Gallery gallery = Gallery(
          chapterId: "467f0590-d529-1d71-a532-11007c9f039a",
          communityId: "bRDU2SzTa6qhmaLN5gkt",
          eventId: "eventId",
          galleryId: galleryId,
          createdOn: DateTime.now(),
          participants: [],
          thumbnails: "thumbnails",
          urls: imageUrls);
      // log("firestore calls");
      await FirestoreMethods().onSave("gallery", gallery.toJson(), galleryId);
    } catch (e) {
      print(0);
      log(e.toString());
    }
  }
}
