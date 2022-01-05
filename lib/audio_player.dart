import 'package:flutter_sound_lite/public/flutter_sound_player.dart';

class SoundPlayer {
  FlutterSoundPlayer? _audioPlayer;
  final audioPath = "ejemplo.aac";

  Future play() async {
    await _audioPlayer!.startPlayer(
      fromURI: audioPath,  
    );
  }

}