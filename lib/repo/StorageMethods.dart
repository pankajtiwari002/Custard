import 'dart:convert';
import 'dart:io';

import 'package:custard_flutter/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  static Future<String> uploadImageToStorage(
      String location,
      String fileName,
      Uint8List file,
      [bool isFeed = false]
  ) async {
    //This is the profile image storage method...................
    try {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child(location)
          .child(fileName);
      if (isFeed) {
        String id = Uuid().v1();
        ref = ref.child(id);
      }
      UploadTask uploadTask = ref.putData(file);
      TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return 'error occur in image';
    }
  }

  static Future<List> uploadImageToStorageByPath(
      FirebaseStorage storage,
      String location,
      Map<String, String> imagePaths,
  ) async {
    var data = <String>[];

    for(var name in imagePaths.keys) {
      File imageFile = File(imagePaths[name]!);

      try {
        var task = storage.ref()
            .child(location)
            .child("$name.${imageFile.path.split('.').last}")
            .putFile(imageFile);

        task.snapshotEvents.listen((event) {
          print("progress: ${event.bytesTransferred}");
        },
          onDone: () {
            "image uploaded: $name";
          }
        ).onError((error) {
          print("error in uploading image: $name");
        });

        var res = await task;
        var url = await res.ref.getDownloadURL();

        data.add(url);
        print('Image uploaded $url');
      } catch (e) {
        print('Error uploading image: $e');
      }
    }

    return data;
  }

  static Future<String?> saveImageToCache(
      Uint8List imageBytes,
      String imageName,
  ) async {
    try {
      final cacheDirectory = await getTemporaryDirectory();
      final String filePath = '${cacheDirectory.path}/$imageName';
      final File imageFile = File(filePath);
      await imageFile.writeAsBytes(imageBytes);
      return filePath;
    } catch (e) {
      print('Error saving image to cache: $e');
      return null;
    }
  }
}
