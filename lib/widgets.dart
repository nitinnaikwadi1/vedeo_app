import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';
import 'package:vedeo_app/model/gif_list.dart';
import 'package:vedeo_app/properties/app_constants.dart' as properties;
import 'package:video_player/video_player.dart';

class BlankScreen extends StatefulWidget {
  const BlankScreen({super.key});

  @override
  State<BlankScreen> createState() => _BlankScreenState();
}

class _BlankScreenState extends State<BlankScreen> {
  String contentBackgImage = '';

  Future<void> readJsonData() async {
    var gifJsonFromURL =
        await http.get(Uri.parse(properties.vedeoAppLandingFramesDataUrl));
    final list = json.decode(gifJsonFromURL.body) as List<dynamic>;
    var readJsonData = list.map((e) => Imagelist.fromJson(e)).toList();
    readJsonData.shuffle();

    setState(() {
      contentBackgImage = readJsonData[0].url;
    });
  }

  @override
  void initState() {
    readJsonData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return contentBackgImage == ''
        ? LoadingIndicator(
            colors: properties.kDefaultRainbowColors,
            indicatorType: Indicator.ballRotate,
            strokeWidth: 3,
            pause: false,
          )
        : Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: NetworkImage(
                    "${properties.vedeoAppLandingFrameUrl}$contentBackgImage"),
              ),
            ),
          );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.pink,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox.square(
            dimension: 120,
            child: LoadingIndicator(
              colors: properties.kDefaultRainbowColors,
              indicatorType: Indicator.pacman,
              strokeWidth: 3,
              pause: false,
            ),
          ),
          SizedBox(width: 20),
          Text(
            'Playing...',
            style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}

class ControlsOverlay extends StatelessWidget {
  const ControlsOverlay({required this.controller});

  static const List<double> _examplePlaybackRates = <double>[
    0.5,
    1.0,
    1.5,
    2.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 50),
            reverseDuration: const Duration(milliseconds: 200),
            child: controller.value.isPlaying
                ? const SizedBox.shrink()
                : const ColoredBox(
                    color: Colors.orange,
                    child: Center(
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.orange,
                        size: 100.0,
                        semanticLabel: 'Play',
                      ),
                    ),
                  ),
          ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed in _examplePlaybackRates)
                  PopupMenuItem<double>(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}
