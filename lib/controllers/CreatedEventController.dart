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
  Rx<bool> isFreeEvent = false.obs;
  Rx<bool> isRemoveLimit = false.obs;
  Rx<Uint8List?> image = Rxn();
  DateTime initialDate = DateTime.now();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  RxList<dynamic> hosted = RxList();
  Rx<bool> isDate = false.obs;

  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dateTime = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);

    return DateFormat.jm().format(dateTime); // 'jm' formats as 'h:mm a'
  }

  Future<void> createEvent() async {
    try {
      String id = Uuid().v1();
      DateTime date = DateTime(selectedDate.year, selectedDate.month,
          selectedDate.day, selectedTime.hour, selectedTime.minute);
      int dateTime = date.millisecondsSinceEpoch;
      String coverPhotoUrl =
          await StorageMethods.uploadImageToStorage("events", id, image.value!);
      Event event = Event(
          id: id,
          title: title.text,
          description: description.text,
          dateTime: dateTime,
          location: GeoPoint(12, 13),
          ticketPrice: double.parse(price.text),
          capacity: int.parse(capacity.text),
          hostedBy: [],
          coverPhotoUrl: coverPhotoUrl,
          isFreeEvent: isFreeEvent.value,
          isApproved: isApproved.value,
          isRemoveLimit: isRemoveLimit.value);
      await FirestoreMethods().onSave("events", event.toJson(), id);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
