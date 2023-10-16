import 'dart:ffi';

import 'package:custard_flutter/components/CustardButton.dart';
import 'package:custard_flutter/utils/CustardColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SlideShowContainer extends StatelessWidget {
  List<Widget> widgets;
  var currPage = 0.obs;
  late var totalPages;
  Function() onFinish;
  
  SlideShowContainer({
    super.key,
    required this.widgets,
    required this.onFinish
  }) {
    totalPages = widgets.length;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _statusIndicator(currPage.value),
        ),
        Row(
          children: [
            Obx(() => Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: currPage.value == 0 ? false : true,
                child: IconButton(
                    onPressed: () {
                      if(currPage.value > 0) {
                        currPage--;
                      }else {
                        Get.snackbar("title", "message");
                      }
                    },
                    icon: const Icon(Icons.arrow_back)
                ),
              ),
            )],
        ),
        Obx(() => widgets[currPage.value]),
        const Spacer(flex: 1),
        CustardButton(
            onPressed: (){
              if(currPage.value < totalPages-1) {
                currPage++;
              }else {
                onFinish();
                Get.snackbar("title", "message");
              }
            },
            buttonType: ButtonType.NEGATIVE,
            label: "Next"
        )
      ],
    );
  }

  _statusIndicator(int count) => [
    for(int i=0; i<totalPages; i++) Expanded(
      child: Obx(() => Container(
          width: 0,
          height: 8,
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(25)),
              color: i <= currPage.value ? CustardColors.appTheme : CustardColors.buttonLight
          )
      )),
    )
  ];
}