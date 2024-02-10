import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoleController extends GetxController {
  Rx<int> index = 2.obs;
  List<int> oldIndex = [];
  List<Widget> appBarTitle = [
    Text(
      'Roles',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontFamily: 'Gilroy',
        fontWeight: FontWeight.w600,
        height: 0.09,
        letterSpacing: 0.20,
      ),
    ),
    Text(
      'Create a new role',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontFamily: 'Gilroy',
        fontWeight: FontWeight.w600,
        height: 0.09,
        letterSpacing: 0.20,
      ),
    ),
    Text(
      'Roles',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontFamily: 'Gilroy',
        fontWeight: FontWeight.w600,
        height: 0.09,
        letterSpacing: 0.20,
      ),
    ),
    Column(
      children: [
        Text(
          'School',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF7B61FF),
            fontSize: 18,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
            height: 0.09,
            letterSpacing: 0.20,
          ),
        ),
        Text(
          'Role',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF546881),
            fontSize: 14,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w500,
            height: 0.11,
            letterSpacing: 0.20,
          ),
        )
      ],
    ),
    Column(
      children: [
        Text(
          'School',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF7B61FF),
            fontSize: 18,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
            height: 0.09,
            letterSpacing: 0.20,
          ),
        ),
        Text(
          'Role',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF546881),
            fontSize: 14,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w500,
            height: 0.11,
            letterSpacing: 0.20,
          ),
        )
      ],
    ),
  ];
}
