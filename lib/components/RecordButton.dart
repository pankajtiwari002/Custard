// import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:uuid/uuid.dart';
import 'package:workmanager/workmanager.dart';
import 'package:record/record.dart';
import '../controllers/MainController.dart';
import '../utils/constants.dart';
import '../controllers/DiscussionController.dart';
import '../src/Global.dart';
import '../src/FlowShader.dart';
import '../src/LottieAnimation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RecordButton extends StatefulWidget {
  const RecordButton(
      {Key? key, required this.controller, required this.lockController})
      : super(key: key);

  final AnimationController controller;
  final AnimationController lockController;

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  static const double size = 55;
  final record = AudioRecorder();
  DiscussionController discussionController = Get.find();
  final double lockerHeight = 200;
  double timerWidth = 0;
  double cancelSliderHeight = 65;

  late Animation<double> buttonScaleAnimation;
  late Animation<double> timerAnimation;
  late Animation<double> lockerAnimation;

  // bool isLocked = false;
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
      discussionController.isPlay.value = true;
      discussionController.audioPath = await getFilePath();
      discussionController.startTimer();
      // record.start(RecordConfig(), path:discussionController.audioPath!);
      RecordMp3.instance.start(discussionController.audioPath!, (type) {});
      // discussionController.start = DateTime.now();
      // while(true){
      //   if(controller.isCompleteAudioRecording.value) break;
      //   Future.delayed(Duration(seconds: 1)).then((value){
      //     controller.currentDuration.value = controller.currentDuration.value+ Duration(seconds: 1);
      //   });
      // }
    }
  }

  Future<void> stopRecord() async {
    log("Recording stop");
    bool s = RecordMp3.instance.stop();
    // String? s = await record.stop();
    discussionController.stopTimer();
    discussionController.isPlay.value = false;
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
    widget.lockController.addListener(() {
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
        parent: widget.lockController,
        curve: const Interval(0.2, 1, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    RecordMp3.instance.stop();
    discussionController.isLocked.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        cancelSlider(),
        lockSlider(),
        audioButton(),
        // if (isLocked) timerLocked(),
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
      // right: 0,
      bottom: 0,
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
        height: cancelSliderHeight,
        curve: Curves.easeIn,
        width: timerWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
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
              // SizedBox(
              //   height: 20,
              // ),
              Visibility(
                visible: discussionController.isLocked.value,
                child: Container(
                  // color: Colors.green,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                          onTap: () {
                            log("delete");
                            print("delete");
                            discussionController
                                .isCompleteAudioRecording.value = false;
                            stopRecord();
                            discussionController
                                .isCompleteAudioRecording.value = false;
                            discussionController.seconds.value = 0;
                            discussionController.isRecording.value = false;
                            File(discussionController.audioPath!).delete();
                            cancelSliderHeight = 65;
                            setState(() {});
                            Future.delayed(Duration(seconds: 1)).then((value) {
                              widget.controller.reverse();
                              discussionController.isLocked.value = false;
                            });
                          },
                          child: Container(
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          )),
                      Obx(() {
                        if (discussionController.isPlay.value) {
                          return InkWell(
                              onTap: () {
                                log("pause");
                                RecordMp3.instance.pause();
                                discussionController.isPlay.value = false;
                              },
                              child: Icon(
                                Icons.pause_circle_outline,
                                color: Colors.red,
                                size: 34,
                              ));
                        } else {
                          return InkWell(
                              onTap: () {
                                log("resume");
                                RecordMp3.instance.resume();
                                discussionController.isPlay.value = true;
                              },
                              child: Icon(
                                Icons.play_circle_outline_outlined,
                                color: Colors.red,
                                size: 34,
                              ));
                        }
                      }),
                      InkWell(
                        onTap: () async {
                          log("send");
                          print("send");
                          stopRecord();
                          Duration audioLen = Duration(seconds: discussionController.seconds.value);
                          int audioLength = audioLen.inMilliseconds;
                          discussionController.isCompleteAudioRecording.value =
                              false;
                          discussionController.isRecording.value = false;
                          MainController mainController = Get.find();
                          discussionController.seconds.value = 0;
                          await Workmanager().registerOneOffTask(
                              Uuid().v1(), Constants.chatAudioUpload,
                              constraints: Constraints(
                                  networkType: NetworkType.connected),
                              inputData: {
                                "audioPath": discussionController.audioPath,
                                "audioLen": audioLength,
                                "uid": mainController.currentUser!.uid,
                                "communityId":
                                    mainController.currentCommunityId,
                                "chapterId": mainController
                                    .currentCommunity.value!.chapters[0]
                              });
                        },
                        child: SvgPicture.asset("assets/images/send.svg"),
                      ),
                      const SizedBox(width: 0),
                    ],
                  ),
                ),
              )
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
                discussionController.isLocked.value = false;
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
    return Obx(() {
      if (!discussionController.isLocked.value) {
        return GestureDetector(
          child: Transform.scale(
            scale: buttonScaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: discussionController.isCompleteAudioRecording.value
                  ? Icon(
                      Icons.send,
                      color: Colors.white,
                    )
                  : discussionController.isLocked.value
                      ? Icon(
                          Icons.stop,
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
              MainController mainController = Get.find();
              discussionController.seconds.value = 0;
              await Workmanager().registerOneOffTask(
                  Uuid().v1(), Constants.chatAudioUpload,
                  constraints: Constraints(networkType: NetworkType.connected),
                  inputData: {
                    "audioPath": discussionController.audioPath,
                    "audioLen": audioLength,
                    "uid": mainController.currentUser!.uid,
                    "communityId": mainController.currentCommunityId,
                    "chapterId":
                        mainController.currentCommunity.value!.chapters[0]
                  });
            } else if (discussionController.isLocked.value) {
              log("stop record");
              await stopRecord();
              // File(discussionController.audioPath!).delete();
              cancelSliderHeight = 65;
              widget.controller.reverse();
              // await Future.delayed(Duration(seconds: 1));
              discussionController.isRecordingPlay.value = false;
              discussionController.isCompleteAudioRecording.value = true;
              discussionController.isLocked.value = false;
            }
          },
          onLongPressDown: (_) async {
            debugPrint("onLongPressDown");
            bool hasPermission = await checkPermission();
            if (hasPermission) widget.controller.forward();
            widget.lockController.forward();
          },
          onLongPressEnd: (details) async {
            debugPrint("onLongPressEnd");

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
                widget.lockController.reverse();
                discussionController.isRecording.value = false;
                discussionController.isCompleteAudioRecording.value = false;
              });
            } else if (checkIsLocked(details.localPosition)) {
              // stopRecord();
              // File(discussionController.audioPath!).delete();
              // discussionController.isRecordingPlay.value=false;
              // discussionController.isCompleteAudioRecording.value=false;
              // widget.controller.reverse();
              //
              // Vibrate.feedback(FeedbackType.heavy);
              // debugPrint("Locked recording");
              // debugPrint(details.localPosition.dy.toString());
              // widget.controller.reverse();
              widget.lockController.reverse();
              // widget.controller.reverse();
              cancelSliderHeight = 90;
              Vibrate.feedback(FeedbackType.heavy);
              Future.delayed(Duration(seconds: 1)).then((val) {
                discussionController.isLocked.value = true;
                setState(() {});
              });
            } else {
              widget.controller.reverse();
              widget.lockController.reverse();
              Vibrate.feedback(FeedbackType.success);
              stopRecord();
            }
          },
          onLongPressCancel: () {
            debugPrint("onLongPressCancel");
            widget.controller.reverse();
            widget.lockController.reverse();
          },
          onLongPress: () async {
            bool hasPermission = await checkPermission();
            if (hasPermission) {
              showLottie = false;
              debugPrint("onLongPress");
              Vibrate.feedback(FeedbackType.success);
              startRecord();
            }
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
        );
      }
      return SizedBox(
        height: 55,
        width: 55,
      );
    });
  }

  bool checkIsLocked(Offset offset) {
    return (offset.dy < -35);
  }

  bool isCancelled(Offset offset, BuildContext context) {
    return (offset.dx < -(MediaQuery.of(context).size.width * 0.2));
  }
}
