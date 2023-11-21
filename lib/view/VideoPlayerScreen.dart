import 'package:custard_flutter/controllers/VideoController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerScreen extends StatelessWidget {
  VideoController controller = Get.put(VideoController());

  VideoPlayerScreen({required String videoUrl}) {
    controller.initialize(videoUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            'Video',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          )),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Chewie(
            controller: controller.chewieController,
          ),
        ),
      ),
    );
  }
}
