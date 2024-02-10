import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FirestoreMethods extends GetxController{
  Future<void> onSave(String collection,var body,[String? docId]) async{
    // log("Firestore start");
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

  Future<void> updateData(String collection,String docId,Map<String,dynamic> body) async{
    try {
        await FirebaseFirestore.instance.collection(collection).doc(docId).update(body);
    } catch (e) {
      log(e.toString());
      throw e;
    }
  }

  Future<Map<String,dynamic>> getData(String collection,String docId) async{
    try{
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection(collection).doc(docId).get();
      if(documentSnapshot.exists){
        Map<String,dynamic> data =  documentSnapshot.data() as Map<String,dynamic>;
        data['uid'] = docId;
        return data;
      }
      else{
        print("Not Exist");
        return {};
      }
    }catch(e){
      print("jkl: " + e.toString());
      return {};
    }
  }

  
}