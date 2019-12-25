import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:rxdart/rxdart.dart';

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
  final dispose$ = PublishSubject();
  final restart$ = PublishSubject();

  AudioPlayer audioPlayer;
  Timer timer;
  int _currentBpm = 90;

  @override
  void initState() {
    super.initState();
    _loadClick();
    _setupRestart();
  }

  _setupRestart() {
    restart$
        .takeUntil(dispose$)
        .debounceTime(Duration(milliseconds: 200))
        .listen((event) {
      print('restart');
      onPlay();
    });
  }

  _loadClick() {
    audioCache.load('audio/click-1.mp3');
    print('loaded');
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    timer = null;
    dispose$.add(null);
    dispose$.close();
  }

  void onStop() {
    if (timer != null) {
      timer.cancel();
      timer = null;
    }
    print('on stop clicked');
  }

  void onPlay() {
    if (timer != null) {
      timer.cancel();
    }
    if (audioPlayer != null) {
      audioPlayer.stop();
    }

    final duration = Duration(milliseconds: (60000 / _currentBpm).round());
    timer = new Timer.periodic(duration, (Timer t) async {
      if (audioPlayer != null) {
        audioPlayer.stop();
      }
      print('play');
      audioPlayer = await audioCache.play('audio/click-1.mp3');
    });
    print('on play clicked');
  }

  void onBpmChanged(num value) {
    setState(() {
      _currentBpm = value;
    });

    restart$.add(null);
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
              new NumberPicker.integer(
                  initialValue: _currentBpm,
                  minValue: 40,
                  maxValue: 200,
                  onChanged: onBpmChanged),
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
