import 'package:custard_flutter/controllers/SplashController.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final controller = Get.put(SplashController());
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF7B61FF),
      body: Center(
        child: Text(
          'Custard.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 45,
            fontFamily: 'Gilroy-Bold',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
