import 'package:chewie/chewie.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoController extends GetxController {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  void initialize(String videoUrl) {
    videoPlayerController = VideoPlayerController.network(videoUrl);
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
    );
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.onClose();
  }
}
