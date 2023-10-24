import 'package:custard_flutter/components/CustardButton.dart';
import 'package:custard_flutter/components/OtpContainer.dart';
import 'package:custard_flutter/components/PhoneContainer.dart';
import 'package:custard_flutter/components/TitleBodyContainer.dart';
import 'package:custard_flutter/view/UserOnboardingScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';

import '../controllers/PhoneAuthController.dart';

class LoginScreen extends StatelessWidget {
  final controller = Get.put(PhoneAuthController());

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text(
              'Custard.',
              style: TextStyle(
                color: Color(0xFF7B61FF),
                fontSize: 30,
                height: 0.03,
              ),
            ),
            const Image(image: AssetImage('assets/temp.png')),
            GetBuilder<PhoneAuthController>(
                builder: (_) {
                  return controller.isOtpSent ?
                  TitleBodyContainer(
                      'Enter OTP',
                      'Confirm your OTP sent to ${controller.phoneNumber.text}'
                  )
                      :
                  TitleBodyContainer(
                      'Sign Up with your phone number',
                      'Only the community you join can see your phone number'
                  );
                }
            ),
            GetBuilder<PhoneAuthController>(
              builder: (_) => Material(
                child: controller.isOtpSent ?
                OtpContainer() : PhoneContainer(),
              ),
            ),
            const Spacer(
              flex: 1,
            ),
            GetBuilder<PhoneAuthController>(builder: (_) {
              return !controller.isOtpSent ?
              CustardButton(
                  onPressed: () {
                    controller.sendOtp();
                  },
                  buttonType: ButtonType.POSITIVE,
                  label: 'Continue'
              )
                  :
              CustardButton(
              onPressed: () {
                Get.to(UserOnboardingScreen());
              },
              label: 'Verify and Continue',
              buttonType: ButtonType.POSITIVE
              );
            })
          ],
        ),
      ),
    );
  }
}