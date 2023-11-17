import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiscussionController extends GetxController {
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
  RxInt totalSelected = 0.obs;
  RxMap<String, dynamic> reply = RxMap<String, dynamic>({});
  TextEditingController messageController = TextEditingController();
  Rx<Uint8List?> image = Rx<Uint8List?>(null);
  Rx<File?> document = Rxn();
  final isCompleteAudioRecording = false.obs, isRecording = false.obs;
  final isRecordingPlay = false.obs;
  final isRecordingIndex = -1.obs;

  final isMultipleOption = false.obs;
  final isHideLisveResult = false.obs;

  final questionController = TextEditingController();
  List<TextEditingController> options = [
    TextEditingController(),
    TextEditingController()
  ];
  // AudioP
}
