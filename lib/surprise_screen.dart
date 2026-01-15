import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:vedeo_app/properties/app_constants.dart' as properties;
import 'package:just_audio/just_audio.dart';

class SurpriseScreen extends StatefulWidget {
  const SurpriseScreen({super.key});

  @override
  State<SurpriseScreen> createState() => _SurpriseScreenState();
}

class _SurpriseScreenState extends State<SurpriseScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  String appBackgImage = '';
  late AudioPlayer surpriseMusicPlayer;

  Future<void> setAppBackThemeImg() async {
    setState(() {
      appBackgImage = properties.isMorning
          ? properties.surpriseDayMedia
          : properties.surpriseNightMedia;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setAppBackThemeImg();
    surpriseMusicPlayer = AudioPlayer();
    surpriseMusicPlayer.setUrl(
      properties.surpriseTuneAudio,
    );
    surpriseMusicPlayer.play();
  }

  @override
  void dispose() {
    surpriseMusicPlayer.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.paused) {
      surpriseMusicPlayer.stop();
    }

    if (state == AppLifecycleState.resumed) {
      surpriseMusicPlayer.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        backgroundColor: Colors.red,
        surfaceTintColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        title: Align(
          alignment: Alignment.topCenter,
          child: GestureDetector(
            child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Image.asset(
                  properties.surpriseCloseButton,
                  height: 36,
                )),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(appBackgImage),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
