import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:custard_flutter/controllers/LocationController.dart';
import 'package:custard_flutter/repo/FirestoreMethods.dart';
import 'package:custard_flutter/repo/StorageMethods.dart';
import 'package:custard_flutter/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/user.dart';

class UserOnboardingController extends GetxController {
  Rx<int> currPage = 0.obs;
  var nameController = TextEditingController();
  var bioController = TextEditingController();
  Rx<String?> gender = Rxn();
  Rx<Uint8List?> image = Rxn();
  String? phone;
  bool? isVerified;
  late BuildContext context;
  String city = "city";
  String uid;

  UserOnboardingController({required this.uid, required this.context});

  @override
  void onInit(){
    print("start");
    LocationController().getLocation(context).then((value){
      city = value;
      print("city: " + city);
    });
    super.onInit();
  }

  Future<bool> joinUser() async {
    try {
      String imageUrl = await StorageMethods.uploadImageToStorage("profile", uid, image.value!);
      User user = User(
          name: nameController.text,
          bio: bioController.text,
          gender: gender.value!,
          isPhoneVerified: true,
          lastLocation: city,
          phone: phone!,
          profilePic: imageUrl,
          communities: [],
          uid: uid
          );

      log(user.toJson().toString());
      
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await FirestoreMethods().onSave("users", user.toJson(),uid);
      prefs.setString(Constants.usersPref, jsonEncode(user.toJson()));
      prefs.setBool(Constants.isUserSignedInPref, true);
      return true;
    } catch (e) {
      return false;
    }
  }
}
