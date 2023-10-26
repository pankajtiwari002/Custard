import 'package:custard_flutter/firebase_options.dart';
import 'package:custard_flutter/repo/AuthRepo.dart';
import 'package:custard_flutter/view/CommunityOnboardingScreen.dart';
import 'package:custard_flutter/view/CommunityScreen.dart';
import 'package:custard_flutter/view/HomeScreen.dart';
import 'package:custard_flutter/view/LoginScreen.dart';
import 'package:custard_flutter/view/RoleScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
  .then((value) => Get.put(AuthRepo()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, background: Colors.white),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      home: RoleScreen(),
    );
  }
}