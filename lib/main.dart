import 'dart:convert';
import 'dart:typed_data';
import 'package:custard_flutter/constants.dart';
import 'package:custard_flutter/controllers/PhoneAuthController.dart';
import 'package:custard_flutter/firebase_options.dart';
import 'package:custard_flutter/repo/AuthRepo.dart';
import 'package:custard_flutter/repo/StorageMethods.dart';
import 'package:custard_flutter/view/HomeScreen.dart';
import 'package:custard_flutter/view/LoginScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workmanager/workmanager.dart';
import 'view/UserOnboardingScreen.dart';

List<Uint8List> convertStringsToUint8ListImages(List<String> stringImages) {
  List<Uint8List> decodedImages = [];
  for (var strImg in stringImages) {
    Uint8List decodedImage = base64Decode(strImg);
    decodedImages.add(decodedImage);
  }
  return decodedImages;
}

void callbackDispatcher() {
  print("Hello");
  Workmanager().executeTask((task, inputData) async {
    print("Workmanager call");
    await Firebase.initializeApp();
    print(inputData!["imagePaths"].toString());
    switch (task) {
      case Constants.photosUpload:
        List<String> imagePaths = inputData!['imagePaths'].cast<String>();
        StorageMethods().uploadImageToStorageByPath(imagePaths);
        // List<String> imageUrls = [];
        // List<Uint8List> images = convertStringsToUint8ListImages(inputData!['images']);
        // print("deconversion successfull");
        // for(int i=0;i<images.length;i++){
        //   print("Hello ${i}");
        //   String imageUrl = await StorageMethods().uploadImageToStorage("Gallery", images[i]);
        //   if(imageUrl == 'error occur in image'){
        //     return Future.value(false);
        //   }
        //   imageUrls.add(imageUrl);
        // }
        print("SuccessFull Upload");
        break;
    }
    return Future.value(true);
  });
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
  .then((value) => Get.put(AuthRepo()));
  await Workmanager().initialize(
    callbackDispatcher,
    // isInDebugMode: true,
  );
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
      home: HomeScreen(),
    );
  }
}