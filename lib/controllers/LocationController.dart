// import 'dart:developer';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';

class LocationController{
  Future<String> getLocation(BuildContext context) async{
    try {
      loc.Location location = new loc.Location();
      var _permissionGranted = await location.hasPermission();
      if (_permissionGranted == loc.PermissionStatus.granted) {
        log("423");
        final currentLocation = await location.getLocation();
        List<Placemark> placemark = await placemarkFromCoordinates(
            currentLocation.latitude!, currentLocation.longitude!);
        Placemark place = placemark[0];
        print(place.toString());
        return place.locality ?? 'Null';
      } else {
        location.requestPermission();
        return "Delhi";
      }
    } catch (e) {
      print(e);
      return "error";
    }
  }
}