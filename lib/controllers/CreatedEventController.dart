import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custard_flutter/repo/StorageMethods.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../data/models/event.dart';
import '../repo/FirestoreMethods.dart';

class CreatedEventController extends GetxController {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController capacity = TextEditingController();
  Rx<bool> isApproved = false.obs;
  Rx<bool> isFreeEvent = true.obs;
  Rx<bool> isRemoveLimit = true.obs;
  Rx<Uint8List?> image = Rxn();
  DateTime startDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  DateTime endDate = DateTime.now();
  TimeOfDay endTime = TimeOfDay.now();
  RxList<dynamic> hosted = RxList();
  Rx<bool> isDate = false.obs;

  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dateTime = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);

    return DateFormat.jm().format(dateTime); // 'jm' formats as 'h:mm a'
  }

  Future<void> createEvent(String communityId) async {
    try {
      log("start creting event");
      String id = Uuid().v1();
      DateTime date = DateTime(startDate.year, startDate.month,
          startDate.day, startTime.hour, startTime.minute);
      int dateTime = date.millisecondsSinceEpoch;
      log("3");
      String coverPhotoUrl =
          await StorageMethods.uploadImageToStorage("events", id, image.value!);
      log("1");
      Event event = Event(
          id: id,
          title: title.text,
          description: description.text,
          dateTime: dateTime,
          location: GeoPoint(12, 13),
          ticketPrice: price.text.trim()=="" ? 0.0 : double.parse(price.text),
          capacity: capacity.text.trim() !='' ? 0 : int.parse(capacity.text),
          hostedBy: [],
          coverPhotoUrl: coverPhotoUrl,
          isFreeEvent: isFreeEvent.value,
          isApproved: isApproved.value,
          isRemoveLimit: isRemoveLimit.value,
          communityId: communityId
          );
      log("2");
      await FirestoreMethods().onSave("events", event.toJson(), id);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
