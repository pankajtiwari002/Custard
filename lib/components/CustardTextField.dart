import 'package:custard_flutter/utils/CustardColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustardTextField extends StatelessWidget {
  int? maxLength;
  String labelText;
  String? helperText;
  TextEditingController controller;

  CustardTextField({
    super.key,
    required this.labelText,
    required this.controller,
    this.maxLength,
    this.helperText
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: CustardColors.appTheme,
      maxLength: maxLength,
      decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(54)),
              borderSide: BorderSide(color: Colors.grey)
          ),
          labelText: labelText,
          helperText: helperText
        ),
      controller: controller,
    );
  }
}