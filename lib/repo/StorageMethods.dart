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
}