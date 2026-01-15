import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

VideoPlayerController videoPlayerController =
    VideoPlayerController.networkUrl(Uri.parse(''));

ValueNotifier<Future<void>?> videoFuture = ValueNotifier(null);

// function to get the differnce of dates in days - number
int daysBetweenDateRange(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}
