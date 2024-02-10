import 'package:custard_flutter/components/CustardButton.dart';
import 'package:custard_flutter/components/SlideShowContainer.dart';
import 'package:custard_flutter/controllers/FeedBackController.dart';
import 'package:custard_flutter/controllers/MainController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'dart:developer';

class FeedBackScreen extends StatelessWidget {
  FeedBackScreen({super.key});

  var controller = Get.put(FeedBackController());
  MainController mainController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Feedback',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
            letterSpacing: 0.20,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.close,
                color: Colors.white,
              ))
        ],
      ),
      body: SlideShowContainer(
          widgets: [firstScreen(), firstScreen(), firstScreen(), lastScreen()],
          onFinish: () {},
          controller: controller),
      bottomNavigationBar: Container(
        constraints: BoxConstraints(maxHeight: 200),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Obx(() => Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: CustardButton(
                    buttonType: ButtonType.POSITIVE,
                    label: controller.currPage.value == 3 ? "Submit" : "Next",
                    onPressed: controller.currPage.value == 3 &&
                            controller.feedbackController.text.trim() == '' ? null : () {
                      if (controller.currPage.value == 3) {
                        Get.back();
                        mainController.currentPageIndex.value = 0;
                      }
                      controller.currPage.value++;
                    },
                    backgroundColor: Color(0xFF7B61FF),
                    textColor: Colors.white,
                  ),
                )),
            Obx(() => Visibility(
                visible: controller.currPage.value == 3,
                child: TextButton(
                    onPressed: () {
                      Get.back();
                      mainController.currentPageIndex.value = 0;
                    },
                    child: Text(
                      'Skip & submit',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF7B61FF),
                        fontSize: 16,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w400,
                      ),
                    ))))
          ],
        ),
      ),
    );
  }

  Widget firstScreen() {
    return Container(
      child: Column(
        children: [
          Text(
            'Thank you for attending the event! Your feedback is valuable to us. ',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF546881),
              fontSize: 15,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Text(
            'How satisfied were you with the event?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF090B0E),
              fontSize: 24,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Image.asset("assets/images/Bitmap.png"),
          SizedBox(
            height: 5,
          ),
          Obx(() =>
              Text(controller.ratingText[controller.ratinng.value.toInt()])),
          SizedBox(
            height: 20,
          ),
          Obx(() => RatingBar.builder(
                initialRating: controller.ratinng.value,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 60.0,
                itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rat) {
                  controller.ratinng.value = rat;
                  log(rat.toString());
                },
              )),
          SizedBox(
            height: 20,
          ),
          Obx(
            () => Slider(
              value: controller.ratinng.value,
              min: 1,
              max: 5,
              // divisions: 5, // Number of discrete divisions
              // label: '$_sliderValue',
              onChanged: (value) {
                controller.ratinng.value = value;
                log("$value");
              },
            ),
          )
        ],
      ),
    );
  }

  Widget lastScreen() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text(
            'Write your feedback',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF090B0E),
              fontSize: 24,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Your feedback is valuable to us!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF929497),
              fontSize: 16,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: controller.feedbackController,
            onChanged: controller.onUpdateFeedback,
            decoration: InputDecoration(
                hintText: "Write your feedback here",
                hintStyle: TextStyle(
                  color: Color(0xFF929497),
                  fontSize: 16,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w500,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignOutside,
                    color: Color(0xFFD1D2D3),
                  ),
                  borderRadius: BorderRadius.circular(8),
                )),
            maxLines: 5,
          ),
        ],
      ),
    );
  }
}
