import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custard_flutter/data/models/event.dart';
import 'package:custard_flutter/repo/FirestoreMethods.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class EventCalendarController extends GetxController {
  Rx<double> height = 120.0.obs;
  Rx<double> initialY = 0.0.obs;
  DateTime focusedDay = DateTime.now();
  CalendarFormat calendarFormat = CalendarFormat.month;
  Rx<int> selectedIndex = (-1).obs;
  DateTime currentDate = DateTime.now();
  List<DateTime> dateList = [];
  // String uid;
  RxList<Map<String, dynamic>> events = RxList();
  Rx<bool> isLoading = true.obs;
  List<DateTime> weekDates = [];
  // EventCalendarController({required this.uid});

  bool isDateEqual(int epochTime,DateTime date) {
    DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(epochTime);
    return dateTime.year == date.year &&
        dateTime.month == date.month &&
        dateTime.day == date.day;
  }

  // Future<void> findEvent() async {
  //   // final snapshot = await FirebaseFirestore.instance.collection("userEvents").get();
  //   // List<String> userEvent = List.empty(growable: true);
  //   // print("eventId");
  //   // for(int i=0;i<snapshot.docs.length;i++){
  //   //   if(snapshot.docs[i].data()['uid'] == uid){
  //   //     print(snapshot.docs[i].data()['eventId']);
  //   //     userEvent.add(snapshot.docs[i].data()['eventId']);
  //   //   }
  //   // }

  //   // for(int i=0;i<userEvent.length;i++){
  //   //   final snap = await FirebaseFirestore.instance.collection("events").doc(userEvent[i]).get();
  //   //   DateTime date = DateTime.fromMillisecondsSinceEpoch(snap.data()!['dateTime']);

  //   // }
  
  //   final snapshot =
  //       await FirebaseFirestore.instance.collection("events").get();
  //   print(snapshot.docs.length);
  //   String eventId = "";
  //   for (int i = 0; i < 7; i++) {
  //     print("i: $i");
  //     int ind = 0;
  //     bool flag = false;
  //     for (int j = 0; j < snapshot.docs.length; j++) {
  //         print("hi $j");
  //         print(dateList[i].toString());
  //         print(DateTime.fromMillisecondsSinceEpoch(snapshot.docs[j].data()['dateTime']));
  //       if (isDateEqual(snapshot.docs[j].data()['dateTime'],dateList[i])) {
  //         eventId = snapshot.docs[j].data()['id'];
  //         ind = j;
  //         flag = true;
  //         break;
  //       }
  //     }
  //     if (flag) {
  //       final snap =
  //           await FirebaseFirestore.instance.collection("userEvents").get();
  //       bool f = true;
  //       for (int j = 0; j < snap.docs.length; j++) {
  //         if (snap.docs[j].data()['uid'] == uid &&
  //             snap.docs[j].data()['eventId'] == eventId) {
  //             events.add(snapshot.docs[ind].data());
  //             f=false;
  //             break;
  //         }
  //       }
  //       if(f) events.add({});
  //     }
  //     else{
  //       events.add({});
  //     }
  //   }
  //   isLoading.value = false;
  // }

  // Populate the dateList with dates from today to the next 7 days
  @override
  void onInit() {
    super.onInit();
    // isLoading.value = true;
    // for (int i = 0; i < 7; i++) {
    //   dateList.add(currentDate.add(Duration(days: i)));
    // }
    // findEvent();
  }
}
