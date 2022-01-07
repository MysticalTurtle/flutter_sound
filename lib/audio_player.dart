import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter_sound_lite/public/flutter_sound_player.dart';

class SoundPlayer {
  FlutterSoundPlayer? _audioPlayer;
  final audioPath = "ejemplo.aac";
  bool get isPlaying => _audioPlayer!.isPlaying;

  Future init() async {
    _audioPlayer = FlutterSoundPlayer();
    await _audioPlayer!.openAudioSession();
  }

  void dispose() {
    _audioPlayer!.closeAudioSession();
   _audioPlayer = null; 
  }

  Future play(VoidCallback whenFinished) async {
    await _audioPlayer!.startPlayer(
      fromURI: audioPath,
      whenFinished: whenFinished,
    );
  }

  Future stop() async {
    await _audioPlayer!.stopPlayer();
  }

  Future togglePlaying({required VoidCallback whenFinished}) async {
    if (_audioPlayer!.isStopped) {
      await play(whenFinished);
    } else {
      await stop();
    }
  }

}