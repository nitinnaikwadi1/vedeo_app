import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vedeo_app/model/gif_list.dart';

class BlankScreen extends StatefulWidget {
  const BlankScreen({super.key});

  @override
  State<BlankScreen> createState() => _BlankScreenState();
}

class _BlankScreenState extends State<BlankScreen> {
  var imageData = [];

  Future<void> readJsonData() async {
    var gifJsonFromURL = await http.get(
        Uri.parse("https://nitinnaikwadi1.github.io/vedeobase/gifList.json"));
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
    print(imageData.length);
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.contain,
            image: NetworkImage(
                'https://nitinnaikwadi1.github.io/vedeobase/gif/$randomNum.gif')),
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
                _refreshHomeImage();
              },
            ),
          ),
        ),
      ),
    );
  }

  void _refreshHomeImage() {
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
