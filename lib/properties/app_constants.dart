import 'package:flutter/material.dart';

const String allDataBaseUrl = "https://nitinnaikwadi1.github.io/vedeobase/";

//test other deployment options
//const String allDataBaseUrl = "https://vedeobase.vercel.app/";
//const String allDataBaseUrl = "https://venerable-genie-708e01.netlify.app/";


const String dayVideosDataUrl = "${allDataBaseUrl}data/vedeo_app/vedeo_app_day_videos_list.json";

const String nightVideosDataUrl = "${allDataBaseUrl}data/vedeo_app/vedeo_app_night_videos_list.json";

const String vedeoAppRandomAnimalsDataUrl = "${allDataBaseUrl}data/app_random_animals_frames_gif_list.json";

const String vedeoAppAnimalFramesUrl = "${allDataBaseUrl}images/random_animals_frames/";

const String dayLandingFramesDataUrl = "${allDataBaseUrl}data/vedeo_app/vedeo_app_landing_day_gif_list.json";

const String nightLandingFramesDataUrl = "${allDataBaseUrl}data/vedeo_app/vedeo_app_landing_night_gif_list.json";

const String vedeoAppAssetBase = "assets/images/";

const String dayDashboardBackgcUrl = "${vedeoAppAssetBase}day_backg/";

const String nightDashboardBackgcUrl = "${vedeoAppAssetBase}night_backg/";

const String dayLandingFrameUrl = "${allDataBaseUrl}images/vedeo_app/landing_day/";

const String nightLandingFrameUrl = "${allDataBaseUrl}images/vedeo_app/landing_night/";


const List<Color> kDefaultRainbowColors = [
  Colors.yellow,
  Colors.white,
  Colors.lightBlueAccent,
  Colors.green,
  Colors.amber,
  Colors.lightGreenAccent,
  Colors.purple,
];

// not declared const - list is being shuffleled on reload 
 List<String> dayBackgList = ['day_backg_1.png', 'day_backg_2.png', 'day_backg_3.png', 'day_backg_4.png', 'day_backg_5.png', 
    'day_backg_6.png', 'day_backg_7.png', 'day_backg_8.png', 'day_backg_9.png', 'day_backg_10.png', 'day_backg_11.png', 
    'day_backg_12.png', 'day_backg_13.png'];
 List<String> nightBackgList = ['night_backg_1.png', 'night_backg_2.png', 'night_backg_3.png', 'night_backg_4.png', 'night_backg_5.png'
    , 'night_backg_6.png', 'night_backg_7.png', 'night_backg_8.png', 'night_backg_9.png', 'night_backg_10.png'
    , 'night_backg_11.png', 'night_backg_12.png', 'night_backg_13.png', 'night_backg_14.png', 'night_backg_15.png'];