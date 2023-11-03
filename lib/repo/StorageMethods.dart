import 'dart:io';

import 'package:custard_flutter/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  Future<String> uploadImageToStorage(String childName, Uint8List file,
      [bool isFeed = false]) async {
    //This is the profile image storage method...................
    try {
      Reference ref = await FirebaseStorage.instance
          .ref()
          .child(childName)
          .child("abcdefghi");
      if (isFeed) {
        String id = Uuid().v1();
        ref = ref.child(id);
      }
      UploadTask uploadTask = ref.putData(file);

      TaskSnapshot snap = await uploadTask;

      String downloadUrl = await snap.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print(e.toString());
      return 'error occur in image';
    }
  }

  Future<void> uploadImageToStorageByPath(List<String> imagePaths) async {
    try {
      var storage = FirebaseStorage.instance;
      for (String imagePath in imagePaths) {
        File file = File(imagePath);
        String fileName = imagePath.split('/').last;

        Reference ref = storage.ref().child('Gallery/$fileName');
        await ref.putFile(file);
        print('$fileName uploaded successfully!');
      }
    } catch (e) {
      print('Error uploading files: $e');
    }
  }
}
