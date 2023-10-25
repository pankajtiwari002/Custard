import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunityController extends GetxController with GetSingleTickerProviderStateMixin{
  late TabController tabController;
  Rx<int> tabIndex = 0.obs;
  Rx<bool> isPending = false.obs;
  Rx<int> memberIndex = 0.obs;

  @override
  void onInit(){
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
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