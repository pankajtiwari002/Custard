import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class InvitePeopleController extends GetxController {
  List userEvents = List.empty(growable: true);
  String eventId;
  Rx<bool> isLoading = false.obs;

  InvitePeopleController({required this.eventId});

  Future<void> getUserEvent() async {
    isLoading.value = true;
    log("eventId: " + eventId);
    final snapshot = await FirebaseFirestore.instance
        .collection("userEvents")
        .where("eventId", isEqualTo: eventId).get();
    userEvents = snapshot.docs;
    log(userEvents.toString());
    isLoading.value = false;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUserEvent();
  }
}
