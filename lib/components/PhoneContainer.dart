
import 'package:custard_flutter/components/CustardTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controllers/PhoneAuthController.dart';

class PhoneContainer extends StatelessWidget {
  final PhoneAuthController controller = Get.find();

  PhoneContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustardTextField(
        labelText: "Phone Number",
        controller: controller.phoneNumber
    );
  }
}