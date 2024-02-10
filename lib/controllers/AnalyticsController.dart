import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnalyticsController extends GetxController with GetTickerProviderStateMixin{
  late TabController analyticsController;
  late TabController engagementTabController;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    analyticsController = TabController(length: 2, vsync: this);
    engagementTabController = TabController(length: 3, vsync: this);
  }
}