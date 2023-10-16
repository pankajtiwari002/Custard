
import 'package:custard_flutter/view/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;

class AuthRepo extends GetxController {
  static AuthRepo get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  var verificationID = "".obs;

  @override
  void onReady() {
    firebaseUser = Rx<User?> (_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialState);
  }

  _setInitialState (User? user) => {
    // user == null ? Get.offAll(() =>  LoginScreen()) : Get.offAll(() => LoginScreen())
  };

  Future<void> phoneVerification(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) async {
          await _auth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) {
          developer.log(
            "abc",
            name: "hello",
            error: "${error.message}"
          );
          Get.snackbar("Auth Error", "${error.message}");
        },
        codeSent: (verificationId, forceResendingToken) {
          verificationID.value = verificationId;
        },
        codeAutoRetrievalTimeout: (verificationId) {
          verificationID.value = verificationId;
        }
    );
  }

  Future<bool> verifyOtp(String otp) async {
    var cred = await _auth
        .signInWithCredential(PhoneAuthProvider.credential(verificationId: verificationID.value, smsCode: otp));
    return cred.user != null ? true : false;
  }
}