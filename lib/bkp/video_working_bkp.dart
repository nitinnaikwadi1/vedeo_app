import 'package:flutter/material.dart';
import 'package:vedeo_app/globals.dart';
import 'package:vedeo_app/widgets.dart';
import 'package:vedeo_app/functions.dart';
import 'package:video_player/video_player.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: Column(
        children: [
          ValueListenableBuilder(
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
                            return VideoPlayer(videoPlayerController);
                          } else {
                            return const LoadingWidget();
                          }
                        },
                      ),
              );
            },
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: 0,
              itemBuilder: (context, index) => ListTile(
                title: Text('Video ${index + 1}'),
                subtitle: Text(""),
                onTap: () => videoFuture.value = play(""),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
