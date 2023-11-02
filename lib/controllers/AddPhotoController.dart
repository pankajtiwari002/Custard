import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AddPhotoController extends GetxController {
  var grpName = TextEditingController();
  RxList<Uint8List> images = RxList();
  RxList<Map<String,dynamic>> members = [
    {
      "id": 0,
      "name": "Priya Bhatt"
    },
    {
      "id": 1,
      "name": "Priya Bhatt"
    },
    {
      "id": 2,
      "name": "Priya Bhatt"
    },
    {
      "id": 3,
      "name": "Priya Bhatt"
    },
    {
      "id": 4,
      "name": "Priya Bhatt"
    },
  ].obs;
  RxList<Map<String,dynamic>> participants = RxList();
  RxList<Map<String,dynamic>> tempParticipants = RxList();

}