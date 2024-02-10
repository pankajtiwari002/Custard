import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class FeedBackController extends GetxController {
  Rx<int> currPage = 0.obs;
  Rx<double> ratinng = 1.0.obs;
  RxList<String> ratingText =
      RxList(["No much!", "No much!", "Good", "Happy!", "Happy!", "Happy!"]);
  Rx<String> feedback = "".obs;
  TextEditingController get feedbackController =>
      TextEditingController(text: feedback.value);

  void onUpdateFeedback(String val) {
    feedback.value = val;
  }
}
