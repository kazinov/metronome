import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: MetronomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class RoundButton extends StatelessWidget {
  RoundButton({this.icon, this.onPressed});

  final IconData icon;
  final void Function() onPressed;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: const ShapeDecoration(
        color: Colors.amber,
        shape: CircleBorder(),
      ),
      child: IconButton(
        icon: Icon(icon),
        color: Colors.black,
        onPressed: () {
          if (onPressed != null) {
            onPressed();
          }
        },
      ),
    );
  }
}

class MetronomePage extends StatefulWidget {
  MetronomePage({Key key, this.title}) : super(key: key) {
    print('MyHomePage');
  }

  final String title;

  @override
  _MetronomePageState createState() => _MetronomePageState();
}

//final AudioCache player = AudioCache();
//player.load('audio/click-1.mp3');

const oneSec = const Duration(seconds: 1);

class _MetronomePageState extends State<MetronomePage> {
  final AudioCache audioCache = AudioCache();
  AudioPlayer audioPlayer;
  Timer timer;

  @override
  void initState() {
    super.initState();
    audioCache.load('audio/click-1.mp3');
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    timer = null;
  }

  void onStop() {
    if (timer != null) {
      timer.cancel();
      timer = null;
    }
    print('on stop clicked');
  }

  void onPlay() {
    if (timer == null) {
      timer = new Timer.periodic(oneSec, (Timer t) {
        audioCache.play('audio/click-1.mp3');
      });
    }
    print('on play clicked');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RoundButton(
                icon: Icons.stop,
                onPressed: onStop,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: RoundButton(
                    icon: Icons.play_arrow,
                    onPressed: onPlay,
                  ))
            ],
          ),
        ));
  }
}
