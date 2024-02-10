import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JoinCommunityController extends GetxController{
  TextEditingController referralController = TextEditingController();
  // Rx<bool> isCardExpanded = false.obs;
  RxList<String> isCardExpanded = RxList();
}