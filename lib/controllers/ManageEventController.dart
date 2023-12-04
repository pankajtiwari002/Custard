import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageEventController extends GetxController{
  RxList<dynamic> registered = ["hey"].obs;
  RxList<dynamic> invited = ["hey"].obs;
  RxList<dynamic> approval_pending = ["hey"].obs;
  Rx<String> filter = "All Guests".obs;
  Rx<bool> isFreeEvent = false.obs;
  Rx<bool> isRemoveLimit = false.obs;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  
  RxMap<String,dynamic> data = RxMap({
    "title": "The Art of Living",
    "imageUrl": "https://images.unsplash.com/photo-1524601500432-1e1a4c71d692?auto=format&fit=crop&q=80&w=1000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fGdyb3VwfGVufDB8fDB8fHww",
    "description": " Jumping foxes dance swiftly under the moonlit sky, creating a mesmerizing spectacle of nature's beauty. Jumping foxes dance swiftly under the moonlit sky, creating a mesmerizing spectacle of nature's beauty.",
  });
  // List<dynamic> registered = ["uid"];
}