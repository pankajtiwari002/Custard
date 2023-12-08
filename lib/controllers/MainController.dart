import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/user.dart';
import '../utils/constants.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';

class MainController extends GetxController{
  Rx<bool> loading = true.obs;
  late SharedPreferences prefs;
  User? currentUser;

  initializedSharedPreference() async{
    prefs = await SharedPreferences.getInstance();
    bool flag = prefs.getBool(Constants.isUserSignedInPref)!=null && prefs.getBool(Constants.isUserSignedInPref)!;
    print("Het");
    print(flag);
    if(flag){
      print("current User");
      String userData = prefs.getString(Constants.usersPref)!;
      print("userData: " + userData);
      // Map<String,dynamic> mp = {"name": "pankaj","profilePic": "https://firebasestorage.googleapis.com/v0/b/custard-kmp.appspot"};
      Map<String,dynamic> data =  jsonDecode(userData);
      print(data["name"].toString());
      currentUser = User.fromSnap(data);
      print("user: " + currentUser.toString());
      loading.value= false;
    }
  }

  @override
  void onInit(){
    loading.value = true;
    initializedSharedPreference();
    super.onInit();
  }
}