import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class EventController extends GetxController{
  List userEvents = List.empty(growable: true);
  String uid;

  EventController({required this.uid});

  Future<void> getUserEvent() async{
    final snapshot = await FirebaseFirestore.instance.collection("userEvents").where("uid",isEqualTo: uid).get();
    userEvents = snapshot.docs;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUserEvent();
  }
}