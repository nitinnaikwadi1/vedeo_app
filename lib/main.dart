import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
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
  ScrollController _scrollController = ScrollController();

  Future<List<Vedeolist>> readJsonData() async {
    var vedeoJsonFromURL = await http.get(
        Uri.parse("https://nitinnaikwadi1.github.io/vedeobase/videoList.json"));
    final list = json.decode(vedeoJsonFromURL.body) as List<dynamic>;
    list.shuffle();
    return list.map((e) => Vedeolist.fromJson(e)).toList();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
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
                          controller: _scrollController,
                          shrinkWrap: true,
                          itemCount: items.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 2,
                              clipBehavior: Clip.hardEdge,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: InkWell(
                                onTap: () {
                                  videoFuture.value = play(items[index].url);
                                  setState(() {});
                                  _scrollController.animateTo(
                                    _scrollController.position.minScrollExtent,
                                    curve: Curves.easeOut,
                                    duration: const Duration(milliseconds: 400),
                                  );
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
