import 'package:custard_flutter/components/CustardButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CongratsScreen extends StatelessWidget {
  Color backgroundColor;
  ImageProvider<Object> image;
  String message;
  String label;
  Widget next;

  CongratsScreen({
    super.key,
    required this.backgroundColor,
    required this.image,
    required this.next,
    required this.message,
    required this.label
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Image(image: image),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w700
              ),
            ),
            const Spacer(
              flex: 1,
            ),
            CustardButton(
              onPressed: () {
                Get.snackbar("title", "$next");
                Get.to(next);
              },
              buttonType: ButtonType.POSITIVE,
              label: label,
              backgroundColor: Colors.white,
              textColor: backgroundColor,
            )
          ],
        ),
      )
    );
  }
}