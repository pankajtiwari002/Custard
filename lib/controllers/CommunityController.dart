import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunityController extends GetxController with GetSingleTickerProviderStateMixin{
  String role;
  late TabController tabController;
  Rx<int> tabIndex = 0.obs;
  Rx<bool> isPending = false.obs;
  Rx<int> memberIndex = 0.obs;
  Rx<String> about = "This case study aligns with the goals outlined in Executive Order [Specify the Executive Order Number if applicable]. The Executive Order emphasizes the modernization of government operations through the adoption of innovative technology solutions, with a focus on streamlining processes and enhancing digital services.".obs;
  TextEditingController editAbout = new TextEditingController();
  Rx<bool> paid = true.obs;

  CommunityController({required this.role});

  @override
  void onInit(){
    super.onInit();
    tabController = TabController(length: role == "admin" ? 4 : 3, vsync: this);
    tabController.addListener(() {
      tabIndex = tabController.index.obs;
    });
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}