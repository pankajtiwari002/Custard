import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiscussionController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxList<Map<String, dynamic>> messages = RxList<Map<String, dynamic>>([
    RxMap<String, dynamic>({
      'profileUrl':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y3VzdG9tZXIlMjBwcm9maWxlfGVufDB8fDB8fHww&w=1000&q=80',
      'name': 'Pankaj',
      'imageUrl': null,
      'repliedMessage': null,
      'textMessage':
          'Having worked on the first Pixel Watch, nothing makes me more happy to see this piece of wearable evolve. ',
      'date': DateTime.now(),
      'prevDate': DateTime.now().subtract(Duration(minutes: 2)),
      'owner': true,
      "isSelected": false
    }),
    RxMap<String, dynamic>(
      {
        'profileUrl':
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y3VzdG9tZXIlMjBwcm9maWxlfGVufDB8fDB8fHww&w=1000&q=80',
        'name': 'Pankaj',
        'imageUrl': null,
        'repliedMessage': null,
        'textMessage': 'Pure beauty in hardware and software design',
        'date': DateTime.now(),
        'prevDate': DateTime.now().subtract(Duration(minutes: 2)),
        'owner': true,
        "isSelected": false
      },
    ),
    RxMap(
      {
        'profileUrl':
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y3VzdG9tZXIlMjBwcm9maWxlfGVufDB8fDB8fHww&w=1000&q=80',
        'name': 'Aman Gairola',
        'imageUrl':
            "https://images.unsplash.com/photo-1524601500432-1e1a4c71d692?auto=format&fit=crop&q=80&w=1000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fGdyb3VwfGVufDB8fDB8fHww",
        'textMessage': 'Message 2',
        'repliedMessage': null,
        'date': DateTime.now(),
        'prevDate': DateTime.now().subtract(Duration(minutes: 4)),
        'owner': false,
        "isSelected": false
      },
    ),
    // Add more messages as needed...
  ]);
  late AnimationController animationController;
  @override
  void onInit() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    super.onInit();
  }

  RxList<String> selectedMessage = RxList();
  RxInt totalSelected = 0.obs;
  RxMap<String, dynamic> reply = RxMap<String, dynamic>({});
  TextEditingController messageController = TextEditingController();
  Rx<Uint8List?> image = Rx<Uint8List?>(null);
  String? imagePath;
  String? imageUrl;
  Rx<Uint8List?> video = Rx<Uint8List?>(null);
  String? videoPath;
  String? videoUrl;
  Rx<File?> document = Rxn();
  String? documentPath;
  String? audioPath;
  final isCompleteAudioRecording = false.obs, isRecording = false.obs;
  final isRecordingPlay = false.obs;
  final recordingMessageId = "-1".obs;
  final recordingMessageIndex = -1.obs;
  final isMultipleOption = false.obs;
  final isHideLisveResult = false.obs;
  final questionController = TextEditingController();
  RxList<TextEditingController> options =
      RxList([TextEditingController(), TextEditingController()]);
  Rx<bool> isImageUploading = false.obs;
  Rx<int> optionsLen = 2.obs;
  Rx<int> selectedButton = 0.obs;
  Rx<Duration> audioListened = Duration(seconds: 0).obs;
  Rx<Duration> currentDuration = Duration(seconds: 0).obs;
  // Rx<String> seconds = "00".obs;
  // Rx<String> minutes = "00".obs;
  DateTime? start, end;

  var isTimerRunning = false.obs;
  var seconds = 0.obs;

  void startTimer() {
    isTimerRunning.value = true;
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (!isTimerRunning.value) {
        timer.cancel();
      } else {
        seconds.value++;
      }
    });
  }

  void stopTimer() {
    isTimerRunning.value = false;
  }

  // double lockerHeight = 200;
  // late Animation<double> lockerAnimation;
  // AudioP
}
