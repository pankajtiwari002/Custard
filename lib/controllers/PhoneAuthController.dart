import 'dart:async';

import 'package:custard_flutter/repo/AuthRepo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class PhoneAuthController extends GetxController {
  var count = 0;
  var isOtpSent = false;
  var phoneNumber = TextEditingController();
  var otp = TextEditingController();
  var uid = Rxn();
  Rx<bool> isTimerRunning = false.obs;
  Rx<int> seconds = 59.obs;
  Rx<bool> isShown = false.obs;

  Future<void> sendOtp() async{
    isOtpSent = true;
    AuthRepo.instance.phoneVerification(phoneNumber.text);
    update();
  }

  Future<void> resendOtp() async{
    isOtpSent = false;
    AuthRepo.instance.verifyOtp(otp.text);
    update();
  }

  Future<bool> verifyOtp() async{
    User? user = await AuthRepo.instance.verifyOtp(otp.text);
    if(user == null) {
      Get.snackbar("User not created", "message");
      return false;
    }
    uid.value = user.uid;
    return true;
  }

  void startTimer() {
    isTimerRunning.value = true;
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (!isTimerRunning.value) {
        timer.cancel();
      } else {
        seconds.value--;
        if(seconds.value==0){
          isShown.value=true;
          stopTimer();
        }
      }
    });
  }

  void stopTimer() {
    isTimerRunning.value = false;
  }
}