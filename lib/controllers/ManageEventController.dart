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

class ManageEventController extends GetxController with GetSingleTickerProviderStateMixin{
  RxList<dynamic> registered = ["hey"].obs;
  RxList<dynamic> invited = ["hey"].obs;
  RxList<dynamic> approval_pending = ["hey"].obs;
  Rx<String> filter = "All Guests".obs;
  Rx<bool> isFreeEvent = false.obs;
  Rx<bool> isRemoveLimit = false.obs;
  Rx<bool> isRegistrationOpen = true.obs;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController capacity = TextEditingController();
  Rx<Uint8List?> image = Rxn();
  String eventId = "";
  DateTime startDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  DateTime endDate = DateTime.now();
  TimeOfDay endTime = TimeOfDay.now();
  Rx<bool> isDate = false.obs;
  late TabController tabController;
  late ScrollController scrollController;

  void reachToInsight(){
    tabController.animateTo(2);
    // scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dateTime = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);

    return DateFormat.jm().format(dateTime); // 'jm' formats as 'h:mm a'
  }

  Future<void> updateEvent() async {
    try {
      Map<String,dynamic> mp = {
        "description": descriptionController.text,
        "title": titleController.text,
        "isFreeEvent": isFreeEvent.value,
        "isRemoveLimit":isRemoveLimit.value,
        "ticketPrice": (isFreeEvent.value || price.text.trim() == "") ? 0.0 : double.parse(price.text),
        "capacity": (isRemoveLimit.value || capacity.text.trim() !='') ? 0 : int.parse(capacity.text),
      };
      if(image.value != null){
        mp["coverPhotoUrl"] =  StorageMethods.uploadImageToStorage("events", Uuid().v1(), image.value!);
      }
      if(isDate.value){
        DateTime date = DateTime(startDate.year, startDate.month,
          startDate.day, startTime.hour, startTime.minute);
        mp["dateTime"] = date.millisecondsSinceEpoch;
      }
      await FirestoreMethods().updateData("events", eventId, mp);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    scrollController = ScrollController();
  }
  // List<dynamic> registered = ["uid"];
}