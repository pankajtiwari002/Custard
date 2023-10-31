import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FirestoreMethods extends GetxController{
  Future<void> onSave(String collection,var body,[String? docId]) async{
    try {
      if(docId!=null){
        await FirebaseFirestore.instance.collection(collection).doc(docId).set(body);
      }
      else{
        await FirebaseFirestore.instance.collection(collection).doc().set(body);
      }
    } catch (e) {
      log(e.toString());
      throw e;
    }
  }
}