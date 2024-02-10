import 'package:custard_flutter/controllers/CommunityOnboardingController.dart';
import 'package:custard_flutter/data/models/community.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'DashedBox.dart';

class CommunityCard extends StatelessWidget {
  List<Widget> widgets;
  CommunityOnboardingController controller = Get.find();
  
  CommunityCard({
    super.key,
    required this.widgets
  });


  @override
  Widget build(BuildContext context) {
    var reqWidgets = [
      Image(image: MemoryImage(controller.image.value!)),
      Text(
        controller.communityName.text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF061237),
          fontSize: 24,
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w700,
        ),
      ),
    ];
    widgets.forEach((element) {
      reqWidgets.add(element);
    });
    
    return Padding(
      padding: EdgeInsets.all(18),
      child: Card(
        color: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: reqWidgets,
          ),
        ),
      )
    );
  }
}