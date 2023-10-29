import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoleController extends GetxController{
  Widget Function() function;
  RoleController({required this.function});
  late Rx<Widget Function()> currFunction;
  
  @override
  void onInit(){
    super.onInit();
    currFunction = function.obs;
  }

}