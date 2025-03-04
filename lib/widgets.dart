import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:vedeo_app/model/gif_list.dart';
import 'package:vedeo_app/properties/app_constants.dart' as properties;

class BlankScreen extends StatefulWidget {
  const BlankScreen({super.key});

  @override
  State<BlankScreen> createState() => _BlankScreenState();
}

class _BlankScreenState extends State<BlankScreen> {
  var imageData = [];

  Future<void> readJsonData() async {
    var gifJsonFromURL = await http.get(
        Uri.parse(properties.vedeoAppLandingFramesDataUrl));
    final list = json.decode(gifJsonFromURL.body) as List<dynamic>;
    var readJsonData = list.map((e) => Imagelist.fromJson(e)).toList();
    setState(() {
      imageData = readJsonData;
    });
  }

  @override
  void initState() {
    readJsonData();
    super.initState();
  }

  final random = Random();

  @override
  Widget build(BuildContext context) {
    int randomNum = random.nextInt(imageData.length);
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.contain,
            image: NetworkImage(
                "${properties.vedeoAppLandingFrameUrl}$randomNum.gif")),
      ),
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: Transform.flip(
            flipX: true,
            child: IconButton(
              icon: Icon(Icons.auto_fix_high),
              color: Colors.orange,
              iconSize: 48,
              onPressed: () {
                _reloadLandingFrame();
              },
            ),
          ),
        ),
      ),
    );
  }

  void _reloadLandingFrame() {
    setState(() {});
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox.square(
            dimension: 25,
            child: CircularProgressIndicator(),
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