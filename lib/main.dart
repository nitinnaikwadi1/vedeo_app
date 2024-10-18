import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vedeo_app/globals.dart';
import 'package:vedeo_app/widgets.dart';
import 'package:vedeo_app/functions.dart';
import 'package:vedeo_app/model/vedeo_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Vedeolist>> readJsonData() async {
    var vedeoJsonFromURL = await http.get(
        Uri.parse("https://nitinnaikwadi1.github.io/vedeobase/videoList.json"));
    final list = json.decode(vedeoJsonFromURL.body) as List<dynamic>;
    return list.map((e) => Vedeolist.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage("assets/images/brand.png")),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 80,
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: ValueListenableBuilder(
                    valueListenable: videoFuture,
                    builder: (context, value, child) {
                      return AspectRatio(
                        aspectRatio: 16 / 9,
                        child: value == null
                            ? BlankScreen()
                            : FutureBuilder(
                                future: value,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return AspectRatio(
                                        aspectRatio: videoPlayerController
                                            .value.aspectRatio,
                                        child: Stack(
                                          alignment: Alignment.bottomCenter,
                                          children: <Widget>[
                                            VideoPlayer(videoPlayerController),
                                            _ControlsOverlay(
                                                controller:
                                                    videoPlayerController),
                                            VideoProgressIndicator(
                                                videoPlayerController,
                                                allowScrubbing: true),
                                          ],
                                        ));
                                  } else {
                                    return const LoadingWidget();
                                  }
                                },
                              ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 20,
              child: FutureBuilder(
                  future: readJsonData(),
                  builder: (context, data) {
                    if (data.hasError) {
                      return Center(child: Text('${data.error}'));
                    } else {
                      if (data.hasData) {
                        var items = data.data as List<Vedeolist>;
                        return ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: InkWell(
                                onTap: () {
                                  videoFuture.value = play(items[index].url);
                                },
                                child: Container(
                                  height: 140,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              items[index].thumb.toString()))),
                                  alignment: Alignment.center,
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Container(
                          height: double.infinity,
                          color: Colors.redAccent,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox.square(
                                dimension: 25,
                                child: CircularProgressIndicator(),
                              )
                            ],
                          ),
                        );
                      }
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({required this.controller});

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
