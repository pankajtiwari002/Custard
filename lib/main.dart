import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:custard_flutter/constants.dart';
import 'package:custard_flutter/controllers/PhoneAuthController.dart';
import 'package:custard_flutter/firebase_options.dart';
import 'package:custard_flutter/repo/AuthRepo.dart';
import 'package:custard_flutter/repo/StorageMethods.dart';
import 'package:custard_flutter/view/ChapterOboardingScreen.dart';
import 'package:custard_flutter/view/CommunityOnboardingScreen.dart';
import 'package:custard_flutter/view/HomeScreen.dart';
import 'package:custard_flutter/view/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:workmanager/workmanager.dart';
import 'view/UserOnboardingScreen.dart';
import './repo/notificationservice/LocaNotificationService.dart';

List<Uint8List> convertStringsToUint8ListImages(List<String> stringImages) {
  List<Uint8List> decodedImages = [];
  for (var strImg in stringImages) {
    Uint8List decodedImage = base64Decode(strImg);
    decodedImages.add(decodedImage);
  }
  return decodedImages;
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (kDebugMode) {
      print("Starting work manager");
    }
    await Firebase.initializeApp();
    switch (task) {
      case Constants.photosUpload:
        // TODO: Remove this
        var user = await FirebaseAuth.instance.signInAnonymously();
        List<String> imagePaths = inputData!['imagePaths'].cast<String>();
        var uid = const Uuid();
        var map = { for (var v in imagePaths) "${user.user!.uid}_${uid.v1()}" : v};
        var s = await StorageMethods.uploadImageToStorageByPath(
          FirebaseStorage.instance,
          "gallery/",
          map
        );
        print(s);
        return Future.value(true);
      default: {
        return Future.value(false);
      }
    }
  });
}

Future<void> backgroundHandler(RemoteMessage message) async {
  	print(message.data.toString());
 	  print(message.notification!.title);
	}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  ).then((value) => Get.put(AuthRepo()));

  // Notification
  Constants.fCMToken = await FirebaseMessaging.instance.getToken();
  log('Token: ${Constants.fCMToken}');
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  // LocalNotificationService().initNotification();
  LocalNotificationService.initialize();


  // await OneSignal.Notifications.requestPermission(true);
  // await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  // OneSignal.initialize(Constants.oneSignalAppId);

  // await OneSignal.Notifications.clearAll();

  // OneSignal.User.pushSubscription.addObserver((state) {
  //     print(OneSignal.User.pushSubscription.optedIn);
  //     print(OneSignal.User.pushSubscription.id);
  //     print(OneSignal.User.pushSubscription.token);
  //     print(state.current.jsonRepresentation());
  //   });

  // OneSignal.Notifications.addPermissionObserver((state) {
  //   print("Has permission " + state.toString());
  // });
  
  // await OneSignal.Notifications.requestPermission(true);

  // OneSignal.Notifications.addForegroundWillDisplayListener((event){
  //   event.preventDefault();
  //   event.notification.display();
  // });

  // Background Services
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: kDebugMode,
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