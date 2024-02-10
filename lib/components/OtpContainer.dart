import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';

import '../controllers/PhoneAuthController.dart';

class OtpContainer extends StatelessWidget {
  final PhoneAuthController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OtpTextField(
          numberOfFields: 6,
          showCursor: false,
          keyboardType: TextInputType.number,
          showFieldAsBox: true,
          fieldWidth: 50,
          mainAxisAlignment: MainAxisAlignment.center,
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          onSubmit: (otp) => {controller.otp.text = otp},
        ),
        Obx(() => Row(
              children: [
                Text("00:${controller.seconds.value}"),
                TextButton(onPressed: controller.isShown.value ? () {
                  controller.isShown.value=false;
                  controller.seconds.value = 59;
                  controller.startTimer();
                } : null, child: Text("Resend OTP"))
              ],
            ))
      ],
    );
  }
}
