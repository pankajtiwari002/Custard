import 'package:custard_flutter/utils/CustardColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustardButton extends StatelessWidget {
  void Function() onPressed;
  ButtonType buttonType;
  String label;
  Color? backgroundColor;
  Color? textColor;

  CustardButton({
    super.key,
    required this.onPressed,
    required this.buttonType,
    required this.label,
    this.textColor,
    this.backgroundColor
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          elevation: 12.0,
          backgroundColor: backgroundColor ?? switch(buttonType) {
            ButtonType.POSITIVE => CustardColors.appTheme,
            ButtonType.NEGATIVE => CustardColors.buttonLight,
            ButtonType.TEXT => Colors.red,
          },
          minimumSize: const Size.fromHeight(40),
          padding: const EdgeInsets.all(18)
      ),
      child: Text(
          label,
        style: TextStyle(
          color: textColor ?? switch(buttonType) {
            ButtonType.POSITIVE => Colors.white,
            ButtonType.NEGATIVE => CustardColors.appTheme,
            ButtonType.TEXT => Colors.white,
          },
          fontSize: 16,
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w700,
          height: 0,
        ),
      ),
    );
  }
}

enum ButtonType{
  POSITIVE,
  NEGATIVE,
  TEXT
}