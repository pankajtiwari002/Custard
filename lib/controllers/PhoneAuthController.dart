import 'package:custard_flutter/repo/AuthRepo.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class PhoneAuthController extends GetxController {
  var count = 0;
  var isOtpSent = false;
  var phoneNumber = TextEditingController();
  var otp = TextEditingController();

  void sendOtp() {
    isOtpSent = true;
    // AuthRepo.instance.phoneVerification(phoneNumber.text);
    update();
  }

  void resendOtp() {
    isOtpSent = false;
    // AuthRepo.instance.verifyOtp(otp.text);
    update();
  }
}