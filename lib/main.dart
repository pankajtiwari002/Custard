import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:custard_flutter/Global.dart';
import 'package:custard_flutter/WorkManagerMethods.dart';
import 'package:custard_flutter/controllers/MainController.dart';
import 'package:custard_flutter/utils/constants.dart';
import 'package:custard_flutter/controllers/PhoneAuthController.dart';
import 'package:custard_flutter/firebase_options.dart';
import 'package:custard_flutter/repo/AuthRepo.dart';
import 'package:custard_flutter/repo/StorageMethods.dart';
import 'package:custard_flutter/view/HomeScreen.dart';
import 'package:custard_flutter/view/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:workmanager/workmanager.dart';
import './repo/notificationservice/LocaNotificationService.dart';
import 'data/models/gallery.dart';
import 'repo/FirestoreMethods.dart';

// List<Uint8List> convertStringsToUint8ListImages(List<String> stringImages) {
//   List<Uint8List> decodedImages = [];
//   for (var strImg in stringImages) {
//     Uint8List decodedImage = base64Decode(strImg);
//     decodedImages.add(decodedImage);
//   }
//   return decodedImages;
// }

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (kDebugMode) {
      print("Starting work manager");
    }
    await Firebase.initializeApp();
    switch (task) {
      case Constants.photosUpload:
        // TODO: Remove this
        try {
          print("hello");
          var user = await FirebaseAuth.instance.signInAnonymously();
          List<String> imagePaths = inputData!['imagePaths'].cast<String>();
          var uid = const Uuid();
          var map = {
            for (var v in imagePaths) "${user.user!.uid}_${uid.v1()}": v
          };
          // log("tiwari");
          List<String> s = await StorageMethods.uploadImageToStorageByPath(
              FirebaseStorage.instance, "gallery/", map);
          print("pankaj");
          String galleryId = Uuid().v1();
          Gallery gallery = Gallery(
              chapterId: "467f0590-d529-1d71-a532-11007c9f039a",
              communityId: "bRDU2SzTa6qhmaLN5gkt",
              eventId: "eventId",
              galleryId: galleryId,
              createdOn: DateTime.now(),
              participants: [],
              thumbnails: "thumbnails",
              urls: s);
          // log("firestore calls");
          await FirestoreMethods()
              .onSave("gallery", gallery.toJson(), galleryId);
          return Future.value(true);
        } catch (e) {
          print("XXX $e");
          return Future.error(e);
        }
      case Constants.chatDocumentUpload:
        try {
          print("Document WorkManager");
          String uid = Uuid().v1();
          String type = "TEXT";
          String? documentUrl;
          print("documentPath: ${inputData!["documentPath"]}");
          if (inputData!["documentPath"] != null) {
            type = "DOCUMENT";
            File document = File(inputData["documentPath"]);
            documentUrl = await StorageMethods.uploadDocument(
                'chat/document', Uuid().v1(), document);
          }
          final DatabaseReference databaseReference = FirebaseDatabase.instance
              .ref()
              .child("communityChats/chapterId/messages");
          DatabaseReference newMessage = databaseReference.push();
          String messageId = newMessage.key!;
          DateTime time = DateTime.now();
          int epochTime = time.millisecondsSinceEpoch;
          Map<String, dynamic> messageJson = {
            "document": documentUrl,
            "from": inputData!["uid"],
            "messageId": messageId,
            "text": inputData!["text"],
            "time": epochTime,
            "type": type
          };
          print("Document Json Form");

          await newMessage.set(messageJson);
          print("data upload");
          return Future.value(true);
        } catch (e) {
          print("errore: $e");
          return Future.error(e);
        }
      case Constants.chatVideoUpload:
        try {
          String uid = Uuid().v1();
          String type = "TEXT";
          String? videoUrl;
          print("videoPath: ${inputData!["videoPath"]}");
          if (inputData!["videoPath"] != null) {
            type = "VIDEO";
            File file = File(inputData["videoPath"]);
            Uint8List video = await file.readAsBytes();
            videoUrl = await StorageMethods.uploadImageToStorage(
                'chat/video', Uuid().v1(), video);
          }
          final DatabaseReference databaseReference = FirebaseDatabase.instance
              .ref()
              .child("communityChats/chapterId/messages");
          DatabaseReference newMessage = databaseReference.push();
          String messageId = newMessage.key!;
          DateTime time = DateTime.now();
          int epochTime = time.millisecondsSinceEpoch;
          Map<String, dynamic> messageJson = {
            "from": inputData!["uid"],
            "video": videoUrl,
            "messageId": messageId,
            "text": inputData["text"],
            "time": epochTime,
            "type": type
          };
          print("Json Form");

          await newMessage.set(messageJson);
          print("data upload");
          return Future.value(true);
        } catch (e) {
          print("errore: $e");
          return Future.error(e);
        }
      case Constants.chatAudioUpload:
        try {
          print("audio workmanager");
          String uid = Uuid().v1();
          String type = "Text";
          String? audioUrl;
          if (inputData!["audioPath"] != null) {
            type = "AUDIO";
            File audio = File(inputData["audioPath"]);
            audioUrl = await StorageMethods.uploadDocument(
                'chat/audio', Uuid().v1(), audio);
          }
          final DatabaseReference databaseReference = FirebaseDatabase.instance
              .ref()
              .child("communityChats/chapterId/messages");
          DatabaseReference newMessage = databaseReference.push();
          String messageId = newMessage.key!;
          DateTime time = DateTime.now();
          int epochTime = time.millisecondsSinceEpoch;
          Map<String, dynamic> messageJson = {
            "audio": audioUrl,
            "audioLen": inputData["audioLen"],
            "from": inputData!["uid"],
            "messageId": messageId,
            "time": epochTime,
            "type": type
          };
          print("Json Form");
          await newMessage.set(messageJson);
          print("data upload");
          return Future.value(true);
        } catch (e) {
          print("errore: $e");
          return Future.error(e);
        }
      case Constants.chatImageUpload:
        // step1: upload image
        //2. get image url
        //3 create a message(messageId)
        //4 create a json that we are going to store in a realtime database
        //5 save data in a realtime database
        try {
          // String uid = Uuid().v1();
          String type = "TEXT";
          String? imageUrl;
          print("imagePath: ${inputData!["imagePath"]}");
          if (inputData!["imagePath"] != null) {
            type = "IMAGE";
            File file = File(inputData["imagePath"]);
            Uint8List image = await file.readAsBytes();
            imageUrl = await StorageMethods.uploadImageToStorage(
                'chat/images', Uuid().v1(), image);
          }
          print("imageUrl: $imageUrl");

          final DatabaseReference databaseReference = FirebaseDatabase.instance
              .ref()
              .child("communityChats/chapterId/messages");
          DatabaseReference newMessage = databaseReference.push();
          String messageId = newMessage.key!;
          DateTime time = DateTime.now();
          int epochTime = time.millisecondsSinceEpoch;
          print("messageId: $messageId");
          Map<String, dynamic> messageJson = {
            "from": inputData!["uid"],
            "image": imageUrl,
            "messageId": messageId,
            "text": inputData["text"],
            "time": epochTime,
            "type": type
          };
          print("Json Form");

          await newMessage.set(messageJson);
          print("data upload");
          return Future.value(true);
        } catch (e) {
          print("errore: $e");
          return Future.error(e);
        }

      default:
        {
          print("case : $task");
          print("pankaj");
          return Future.value(false);
        }
    }
  });
}

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(AuthRepo()));

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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  MainController controller = Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple, background: Colors.white),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      home: Obx((){
        if(controller.loading.value){
          return Scaffold();
        }
        else{
          return controller.prefs.getBool(Constants.isUserSignedInPref)!=null && controller.prefs.getBool(Constants.isUserSignedInPref)! ? HomeScreen() : LoginScreen();
        }
      }),
    );
  }
}
