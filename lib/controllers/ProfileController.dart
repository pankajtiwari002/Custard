import 'dart:convert';
import 'package:custard_flutter/repo/FirestoreMethods.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Global.dart';
import '../data/models/user.dart';
import '../utils/constants.dart';

class ProfileController extends GetxController {
  late SharedPreferences prefs;
  User? user = User(
      name: "name",
      bio: "",
      gender: "male",
      isPhoneVerified: true,
      lastLocation: "",
      phone: "",
      profilePic:
          "https://cdn4.sharechat.com/compressed_gm_40_img_640743_155b79a3_1699902638340_sc.jpg?tenant=sc&referrer=api-gateway&f=340_sc.jpg",
      communities: [],
      uid: "",
      isFirstTime: false,
      role: "user"
      );
  bool isCurrentUser = false;
  String uid = "";
  Rx<bool> isLoading = true.obs;
  getProfileData() async {
    if(!isCurrentUser){
      print("uid: $uid");
      Map<String, dynamic> json =
          await FirestoreMethods().getData("users", uid);
      user = User.fromSnap(json);
    }
    // bool flag = prefs.getBool(Constants.isUserSignedInPref) != null &&
    //     prefs.getBool(Constants.isUserSignedInPref)!;
    // print("Het");
    // print(flag);
    // if (flag && isCurrentUser) {
    //   print("current User");
    //   String userData = prefs.getString(Constants.usersPref)!;
    //   print("userData: " + userData);
    //   // Map<String,dynamic> mp = {"name": "pankaj","profilePic": "https://firebasestorage.googleapis.com/v0/b/custard-kmp.appspot"};
    //   Map<String, dynamic> data = jsonDecode(userData);
    //   print(data["name"].toString());
    //   user = User.fromSnap(data);
    //   Global.currentUser = user;
    //   print("user: " + user.toString());
    // } else if (uid != "") {
    //   print("uid: $uid");
    //   Map<String, dynamic> json =
    //       await FirestoreMethods().getData("users", uid);
    //   user = User.fromSnap(json);
    // }
    isLoading.value = false;
  }

  @override
  void onInit() {
    print("init");
    getProfileData();
    super.onInit();
  }
}
