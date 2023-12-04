import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BankDetailsController extends GetxController{
  TextEditingController benificiarNameController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController bankIFSCController = TextEditingController();
  TextEditingController upiController = TextEditingController();

  Rx<bool> allOk(){
    return (benificiarNameController.text.trim() != "" && accountNumberController.text.trim() !="" && bankIFSCController.text.trim() !="").obs;
  }
}