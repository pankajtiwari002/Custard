import 'package:get/get.dart';

class ManageEventController extends GetxController{
  RxList<dynamic> registered = ["hey"].obs;
  RxList<dynamic> invited = ["hey"].obs;
  RxList<dynamic> approval_pending = ["hey"].obs;
  Rx<String> filter = "All Guests".obs;
  // List<dynamic> registered = ["uid"];
}