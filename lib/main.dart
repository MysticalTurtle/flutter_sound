import 'package:flutter/material.dart';
import 'audio_recorder.dart';

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

  @override
  void initState() {
    super.initState();
    recorder.init();
  }

  @override
  void dispose() {
    super.dispose();
    recorder.dispose();
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
        body: Center(child: buildStart(),),
      ),
    );
  }

  Widget buildStart() {
    final bool isRecording = recorder.isRecording;
    // final bool isRecording = false;
    final text = isRecording ? "Pausar" : "Iniciar";
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
}
