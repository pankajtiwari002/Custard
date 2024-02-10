import 'dart:developer';
import 'dart:io';

import 'package:custard_flutter/controllers/DiscussionController.dart';
import 'package:custard_flutter/controllers/MainController.dart';
import 'package:custard_flutter/utils/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:workmanager/workmanager.dart';

class TrimmerView extends StatefulWidget {
  final File file;

  TrimmerView(this.file);

  @override
  _TrimmerViewState createState() => _TrimmerViewState();
}

class _TrimmerViewState extends State<TrimmerView> {
  final Trimmer _trimmer = Trimmer();
  DiscussionController controller = Get.find();
  double _startValue = 0.0;
  double _endValue = 0.0;
  MainController mainController = Get.find();
  bool _isPlaying = false;
  bool _progressVisibility = false;

  Future<String?> _saveVideo() async {
    String? _value;
    await _trimmer.saveTrimmedVideo(
      startValue: _startValue,
      endValue: _endValue,
      onSave: (outputPath) async {
        _value = outputPath;
        log("path: " + outputPath.toString());
        // controller.videoPath = outputPath;
        // log("path2: " + outputPath.toString());
        if (outputPath != null) {
          // File video = File(controller.videoPath!);
          print("andar gaya");
          // controller.video.value = await video.readAsBytes();
          // controller.video.value = null;
          print("video");
          await Workmanager().cancelAll();
          await Workmanager().registerOneOffTask(
              Uuid().v1(), Constants.chatVideoUpload,
              constraints: Constraints(networkType: NetworkType.connected),
              inputData: {
                "videoPath": outputPath,
                "text": "",
                "uid": mainController.currentUser!.uid,
                "communityId": mainController.currentCommunityId,
                "chapterId": mainController.currentCommunity.value!.chapters[0]
              });
          controller.videoPath = null;
        }
        Get.back();
      },
    );
    return _value;
  }

  void _loadVideo() {
    _trimmer.loadVideo(videoFile: widget.file);
  }

  @override
  void initState() {
    super.initState();

    _loadVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Video Edit",
          style: TextStyle(color: Colors.white),
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
          TextButton(
              onPressed: () async {
                _saveVideo();
              },
              child: Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: Builder(
        builder: (context) => Center(
          child: Container(
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Visibility(
                  visible: _progressVisibility,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                ),
                Expanded(
                  child: VideoViewer(trimmer: _trimmer),
                ),
                Center(
                  child: TrimViewer(
                    trimmer: _trimmer,
                    viewerHeight: 50.0,
                    viewerWidth: MediaQuery.of(context).size.width,
                    // maxVideoLength: const Duration(seconds: 10),
                    onChangeStart: (value) => _startValue = value,
                    onChangeEnd: (value) => _endValue = value,
                    onChangePlaybackState: (value) =>
                        setState(() => _isPlaying = value),
                  ),
                ),
                TextButton(
                  child: _isPlaying
                      ? Icon(
                          Icons.pause,
                          size: 80.0,
                          color: Colors.white,
                        )
                      : Icon(
                          Icons.play_arrow,
                          size: 80.0,
                          color: Colors.white,
                        ),
                  onPressed: () async {
                    bool playbackState = await _trimmer.videoPlaybackControl(
                      startValue: _startValue,
                      endValue: _endValue,
                    );
                    setState(() {
                      _isPlaying = playbackState;
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
