import 'package:flutter/material.dart';
import 'package:sonido/audio_player.dart';
import 'audio_recorder.dart';

// from : https://www.youtube.com/watch?v=64xJO0urK9E
// from : https://www.youtube.com/watch?v=-Q5c-E63kfI&t=134s

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final recorder = SoundRecorder();
  final player = SoundPlayer();

  @override
  void initState() {
    super.initState();
    recorder.init();
    player.init();
  }

  @override
  void dispose() {
    super.dispose();
    recorder.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Center(
              child: recorButton(),
            ),
            Center(
              child: playButton(),
            )
          ],
        ),
      ),
    );
  }

  Widget recorButton() {
    final bool isRecording = recorder.isRecording;
    // final bool isRecording = false;
    final text = isRecording ? "Detener" : "Grabar";
    final icon = isRecording ? Icons.stop : Icons.mic;
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(text),
      onPressed: () async {
        final isRecording = await recorder.toggleRecording();
        setState(() {});
      },
    );
  }

  Widget playButton() {
    final isPlaying = player.isPlaying;
    final icon = isPlaying? Icons.stop : Icons.play_arrow;
    final text = isPlaying? "Detener" : "Reproducir";
    return ElevatedButton.icon(
        onPressed: () async {
          await player.togglePlaying(whenFinished: () => setState(() {}));
          setState(() {});
        },
        icon: Icon(icon),
        label: Text(text));
  }
}
