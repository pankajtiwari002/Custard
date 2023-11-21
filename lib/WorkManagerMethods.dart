import 'dart:developer';
import 'dart:io';
import 'package:custard_flutter/constants.dart';
import 'package:custard_flutter/repo/StorageMethods.dart';
import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'data/models/gallery.dart';
import 'repo/FirestoreMethods.dart';

class WorkManagerMethods {
  static void callbackDispatcher() {
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
        case Constants.chatImageUpload:
          // step1: upload image
          //2. get image url
          //3 create a message(messageId)
          //4 create a json that we are going to store in a realtime database
          //5 save data in a realtime database
          try {
            String uid = Uuid().v1();
            String type = "TEXT";
            String? imageUrl;
            print("imagePath: ${inputData!["imagePath"]}");
            print("kasakai");
            if (inputData!["imagePath"] != null) {
              type = "IMAGE";
              File file = File(inputData["imagePath"]);
              Uint8List image = await file.readAsBytes();
              imageUrl = await StorageMethods.uploadImageToStorage(
                  'chat/images', Uuid().v1(), image);
            }
            // else if (inputData["videoPath"] != null) {
            //   type = "VIDEO";
            //   File file = File(inputData["videoPath"]);
            //   Uint8List video = await file.readAsBytes();
            //   videoUrl = await StorageMethods.uploadImageToStorage(
            //       'chats/video', Uuid().v1(), video);
            // } else if (inputData["documentPath"] != null) {
            //   type = "DOCUMENT";
            //   File document = File(inputData["documentPath"]);
            //   documentUrl = await StorageMethods.uploadDocument(
            //       'chats/document', Uuid().v1(), document);
            // }
            String messageId = Uuid().v1();
            DateTime time = DateTime.now();
            int epochTime = time.millisecondsSinceEpoch;
            Map<String, dynamic> messageJson = {
              "from": "userId",
              "image": imageUrl,
              "messageId": messageId,
              "text": inputData["text"],
              "time": epochTime,
              "type": type
            };
            print("Json Form");

            final DatabaseReference databaseReference = FirebaseDatabase
                .instance
                .ref()
                .child("communityChats/chapterId/messages/$messageId");

            await databaseReference.push().set(messageJson);
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
            String messageId = Uuid().v1();
            DateTime time = DateTime.now();
            int epochTime = time.millisecondsSinceEpoch;
            Map<String, dynamic> messageJson = {
              "from": "userId",
              "video": videoUrl,
              "messageId": messageId,
              "text": inputData["text"],
              "time": epochTime,
              "type": type
            };
            print("Json Form");

            final DatabaseReference databaseReference = FirebaseDatabase
                .instance
                .ref()
                .child("communityChats/chapterId/messages/$messageId");

            await databaseReference.push().set(messageJson);
            print("data upload");
            return Future.value(true);
          } catch (e) {
            print("errore: $e");
            return Future.error(e);
          }
        case Constants.chatDocumentUpload:
          try {
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
            String messageId = Uuid().v1();
            DateTime time = DateTime.now();
            int epochTime = time.millisecondsSinceEpoch;
            Map<String, dynamic> messageJson = {
              "document": documentUrl,
              "from": "userId",
              "messageId": messageId,
              "text": inputData!["text"],
              "time": epochTime,
              "type": type
            };
            print("Json Form");

            final DatabaseReference databaseReference = FirebaseDatabase
                .instance
                .ref()
                .child("communityChats/chapterId/messages/$messageId");

            await databaseReference.push().set(messageJson);
            print("data upload");
            return Future.value(true);
          } catch (e) {
            print("errore: $e");
            return Future.error(e);
          }
        case Constants.chatAudioUpload:
          try {
            String uid = Uuid().v1();
            String type = "TEXT";
            String? audioUrl;
            if (inputData!["audioPath"] != null) {
              type = "AUDIO";
              File audio = File(inputData["audioPath"]);
              audioUrl = await StorageMethods.uploadDocument(
                  'chat/audio', Uuid().v1(), audio);
            }
            String messageId = Uuid().v1();
            DateTime time = DateTime.now();
            int epochTime = time.millisecondsSinceEpoch;
            Map<String, dynamic> messageJson = {
              "audio": audioUrl,
              "audioLen": inputData["audioLen"],
              "from": "userId",
              "messageId": messageId,
              "time": epochTime,
              "type": type
            };
            print("Json Form");
            final DatabaseReference databaseReference = FirebaseDatabase
                .instance
                .ref()
                .child("communityChats/chapterId/messages/$messageId");

            await databaseReference.push().set(messageJson);
            print("data upload");
            return Future.value(true);
          } catch (e) {
            print("errore: $e");
            return Future.error(e);
          }
        default:
          {
            print("pankaj: $task");
            return Future.value(false);
          }
      }
    });
  }
}
