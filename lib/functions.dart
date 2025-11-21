import 'package:vedeo_app/globals.dart';
import 'package:video_player/video_player.dart';

Future<void> play(String url) async {
  if (url.isEmpty) return;
  if (videoPlayerController.value.isInitialized) {
    await videoPlayerController.dispose();
  }
  videoPlayerController = VideoPlayerController.networkUrl(
    Uri.parse(url),
    videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
  );
  videoPlayerController.setLooping(false);
  
  return videoPlayerController
      .initialize()
      .then((value) => videoPlayerController.play());
}