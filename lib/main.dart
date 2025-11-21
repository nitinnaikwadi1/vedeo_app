import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;
import 'package:vedeo_app/functions.dart';
import 'package:vedeo_app/globals.dart';
import 'package:vedeo_app/model/vedeo_list.dart';
import 'package:vedeo_app/properties/app_constants.dart' as properties;
import 'package:vedeo_app/widgets.dart';
import 'package:video_player/video_player.dart';
import 'package:gif/gif.dart';

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

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  String headerGifImage = 'baloons.gif';
  String footerGifImage = 'aligator_bird.gif';

  late final GifController _gifController;

  Future<List<Vedeolist>> readJsonData() async {
    var vedeoJsonFromURL =
        await http.get(Uri.parse(properties.vedeoAppVideoDataUrl));

    final list = json.decode(vedeoJsonFromURL.body) as List<dynamic>;
    list.shuffle();
    return list.map((e) => Vedeolist.fromJson(e)).toList();
  }

  @override
  void initState() {
    super.initState();

    _gifController = GifController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(properties.vedeoAppDashboardBackgcUrl)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 83,
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      width: 198,
                      child: Gif(
                        autostart: Autostart.loop,
                        image: NetworkImage(
                          "${properties.vedeoAppAnimalFramesUrl}$headerGifImage",
                        ),
                        fit: BoxFit.contain,
                        controller: _gifController,
                        useCache: true,
                        onFetchCompleted: () {
                          _gifController.reset();
                          _gifController.forward();
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: SizedBox(
                      width: 275,
                      child: Gif(
                        autostart: Autostart.loop,
                        image: NetworkImage(
                          "${properties.vedeoAppAnimalFramesUrl}$footerGifImage",
                        ),
                        fit: BoxFit.contain,
                        controller: _gifController,
                        useCache: true,
                        onFetchCompleted: () {
                          _gifController.reset();
                          _gifController.forward();
                        },
                      ),
                    ),
                  ),
                  SizedBox(
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
                                                VideoPlayer(
                                                    videoPlayerController),
                                                ControlsOverlay(
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
                ],
              ),
            ),
            Expanded(
              flex: 17,
              child: AnimatedOpacity(
                opacity: 0.7,
                duration: const Duration(milliseconds: 365),
                child: FutureBuilder(
                    future: readJsonData(),
                    builder: (context, data) {
                      if (data.hasError) {
                        return Center(child: Text('${data.error}'));
                      } else {
                        if (data.hasData) {
                          var items = data.data as List<Vedeolist>;
                          return ListView.builder(
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemCount: items.length,
                            itemBuilder: (BuildContext context, int index) {
                              return AnimationConfiguration.staggeredGrid(
                                position: index,
                                duration: const Duration(milliseconds: 100),
                                columnCount: items.length,
                                child: ScaleAnimation(
                                  child: FadeInAnimation(
                                    child: Card(
                                      elevation: 2,
                                      clipBehavior: Clip.hardEdge,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          videoFuture.value =
                                              play(items[index].url);
                                          setState(() {});
                                          _scrollController.animateTo(
                                            _scrollController
                                                .position.minScrollExtent,
                                            curve: Curves.easeOut,
                                            duration: const Duration(
                                                milliseconds: 400),
                                          );
                                        },
                                        child: Container(
                                          height: 140,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      items[index]
                                                          .thumb
                                                          .toString()))),
                                          alignment: Alignment.center,
                                        ),
                                      ),
                                    ),
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
            ),
          ],
        ),
      ),
    );
  }
}
