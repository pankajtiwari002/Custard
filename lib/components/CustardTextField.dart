import 'dart:ffi';

import 'package:custard_flutter/utils/CustardColors.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustardTextField extends StatelessWidget {
  int? maxLength;
  String labelText;
  String? helperText;
  TextEditingController controller;

  Rx<int> length = 0.obs;
  Icon? prefixIcon;
  CustardTextField(
      {super.key,
      required this.labelText,
      required this.controller,
      this.maxLength,
      this.helperText,
      this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          cursorColor: CustardColors.appTheme,
          maxLength: maxLength,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(54)),
                borderSide: BorderSide(color: Colors.grey)),
            labelText: labelText,
            helperText: helperText,
            prefixIcon: prefixIcon,
          ),
          controller: controller,
          minLines: 1,
          maxLines: 5,
        ),
      ],
    );
  }
}
