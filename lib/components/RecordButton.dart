import 'dart:async';
import 'dart:io';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:uuid/uuid.dart';
import 'package:workmanager/workmanager.dart';

import '../constants.dart';
import '../controllers/DiscussionController.dart';
import '../src/AudioState.dart';
import '../src/Global.dart';
import '../src/FlowShader.dart';
import '../src/LottieAnimation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RecordButton extends StatefulWidget {
  const RecordButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final AnimationController controller;

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  static const double size = 55;
  DiscussionController discussionController = Get.find();
  final double lockerHeight = 200;
  double timerWidth = 0;

  late Animation<double> buttonScaleAnimation;
  late Animation<double> timerAnimation;
  late Animation<double> lockerAnimation;

  bool isLocked = false;
  bool showLottie = false;

  String _formatDuration(int seconds) {
    Duration duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  int i = 0;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/test_${i++}.mp3";
  }

  void startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      discussionController.isRecording.value = true;
      discussionController.audioPath = await getFilePath();
      discussionController.startTimer();
      RecordMp3.instance.start(discussionController.audioPath!, (type) {});
      discussionController.start = DateTime.now();
      // while(true){
      //   if(controller.isCompleteAudioRecording.value) break;
      //   Future.delayed(Duration(seconds: 1)).then((value){
      //     controller.currentDuration.value = controller.currentDuration.value+ Duration(seconds: 1);
      //   });
      // }
    }
  }

  void stopRecord() {
    bool s = RecordMp3.instance.stop();
    discussionController.end = DateTime.now();
    if (s) {
      discussionController.isRecording.value = false;
      discussionController.isCompleteAudioRecording.value = true;
    }
  }

  @override
  void initState() {
    super.initState();
    buttonScaleAnimation = Tween<double>(begin: 1, end: 1.5).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticInOut),
      ),
    );
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    timerWidth = MediaQuery.of(context).size.width - 2 * Globals.defaultPadding;
    timerAnimation =
        Tween<double>(begin: timerWidth + Globals.defaultPadding, end: 60)
            .animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0.2, 1, curve: Curves.easeIn),
      ),
    );
    lockerAnimation =
        Tween<double>(begin: lockerHeight + Globals.defaultPadding, end: 0)
            .animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0.2, 1, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        lockSlider(),
        cancelSlider(),
        audioButton(),
        if (isLocked) timerLocked(),
      ],
    );
  }

  Widget lockSlider() {
    return Positioned(
      bottom: -lockerAnimation.value - 6,
      child: Container(
        height: lockerHeight,
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Globals.borderRadius),
          color: Colors.black,
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const FaIcon(
              FontAwesomeIcons.lock,
              size: 20,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            FlowShader(
              direction: Axis.vertical,
              child: Column(
                children: const [
                  Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.white,
                  ),
                  Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.white,
                  ),
                  Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cancelSlider() {
    return Positioned(
      right: -timerAnimation.value - 8,
      child: Container(
        height: 65,
        width: timerWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              showLottie
                  ? const LottieAnimation()
                  : Obx(() => Text(
                        '${_formatDuration(discussionController.seconds.value)}',
                        style: TextStyle(color: Colors.black),
                      )),
              FlowShader(
                child: Row(
                  children: const [
                    Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.grey,
                    ),
                    Text(
                      "Slide to cancel",
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
                duration: const Duration(seconds: 3),
                flowColors: const [Colors.white, Colors.grey],
              ),
              const SizedBox(width: size),
            ],
          ),
        ),
      ),
    );
  }

  Widget timerLocked() {
    return Positioned(
      right: 0,
      child: Container(
        height: size,
        width: timerWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 25),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              Vibrate.feedback(FeedbackType.success);
              discussionController.isRecording.value = false;
              discussionController.isCompleteAudioRecording.value = false;
              setState(() {
                isLocked = false;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  _formatDuration(discussionController.seconds.value),
                  style: TextStyle(color: Colors.black),
                ),
                // FlowShader(
                //   child: const Text(
                //     "Tap lock to stop",
                //     style: TextStyle(color: Colors.black),
                //   ),
                //   duration: const Duration(seconds: 3),
                //   flowColors: const [Colors.black, Colors.grey],
                // ),
                const Center(
                  child: FaIcon(
                    FontAwesomeIcons.lock,
                    size: 18,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget audioButton() {
    return Obx(() => GestureDetector(
          child: Transform.scale(
            scale: buttonScaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: discussionController.isCompleteAudioRecording.value
                  ? Icon(
                      Icons.send,
                      color: Colors.white,
                    )
                  : SvgPicture.asset("assets/images/microphone-2.svg"),
              height: size,
              width: size,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          onTap: () async {
            if (discussionController.isCompleteAudioRecording.value) {
              Duration audioLen = discussionController.end!
                  .difference(discussionController.start!);
              int audioLength = audioLen.inMilliseconds;
              discussionController.isCompleteAudioRecording.value = false;
              discussionController.isRecording.value = false;
              await Workmanager().registerOneOffTask(
                  Uuid().v1(), Constants.chatAudioUpload,
                  constraints: Constraints(networkType: NetworkType.connected),
                  inputData: {
                    "audioPath": discussionController.audioPath,
                    "audioLen": audioLength
                  });
            }
          },
          onLongPressDown: (_) {
            debugPrint("onLongPressDown");
            widget.controller.forward();
          },
          onLongPressEnd: (details) async {
            debugPrint("onLongPressEnd");
            discussionController.stopTimer();

            if (isCancelled(details.localPosition, context)) {
              Vibrate.feedback(FeedbackType.heavy);
              discussionController.seconds.value = 0;
              stopRecord();
              File(discussionController.audioPath!).delete();
              setState(() {
                showLottie = true;
              });
              // showLottie = false;
              Future.delayed(Duration(milliseconds: 1500)).whenComplete(() {
                discussionController.seconds.value = 0;
                widget.controller.reverse();
                discussionController.isRecording.value = false;
                discussionController.isCompleteAudioRecording.value = false;
              });
            } else if (checkIsLocked(details.localPosition)) {
              stopRecord();
              File(discussionController.audioPath!).delete();
              discussionController.isRecordingPlay.value=false;
              discussionController.isCompleteAudioRecording.value=false;
              widget.controller.reverse();

              Vibrate.feedback(FeedbackType.heavy);
              // debugPrint("Locked recording");
              // debugPrint(details.localPosition.dy.toString());
              // setState(() {
              //   isLocked = true;
              // });
            } else {
              widget.controller.reverse();
              Vibrate.feedback(FeedbackType.success);
              stopRecord();
            }
          },
          onLongPressCancel: () {
            debugPrint("onLongPressCancel");
            widget.controller.reverse();
          },
          onLongPress: () async {
            showLottie=false;
            debugPrint("onLongPress");
            Vibrate.feedback(FeedbackType.success);
            startRecord();
            // timer = Timer.periodic(const Duration(seconds: 1), (_) {
            //   final minDur = DateTime.now().difference(startTime!).inMinutes;
            //   final secDur =
            //       DateTime.now().difference(startTime!).inSeconds % 60;
            //   String min = minDur < 10 ? "0$minDur" : minDur.toString();
            //   String sec = secDur < 10 ? "0$secDur" : secDur.toString();
            //   setState(() {
            //     recordDuration = "$min:$sec";
            //   });
            // });
          },
        ));
  }

  bool checkIsLocked(Offset offset) {
    return (offset.dy < -35);
  }

  bool isCancelled(Offset offset, BuildContext context) {
    return (offset.dx < -(MediaQuery.of(context).size.width * 0.2));
  }
}
