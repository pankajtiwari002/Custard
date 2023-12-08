import 'package:custard_flutter/data/models/user.dart';
import 'package:get/get.dart';

import '../repo/FirestoreMethods.dart';

class MessageCardController{
  late User user;
  Rx<bool> isLoading = true.obs;

  Future<void> initUser(String uid) async{
    Map<String,dynamic> json = await FirestoreMethods().getData("users",uid);
    user = User.fromSnap(json);
    isLoading.value = false;
  }
}