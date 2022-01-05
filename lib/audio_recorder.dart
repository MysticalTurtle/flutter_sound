import "package:flutter_sound_lite/public/flutter_sound_player.dart";
import "package:flutter_sound_lite/public/flutter_sound_recorder.dart";
import 'package:permission_handler/permission_handler.dart';

final String pathToSaveFile = "ejemplo.aac";

class SoundRecorder {
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecordedInitialised = false;
  bool get isRecording => _audioRecorder!.isRecording;

  Future init() async {
    _audioRecorder = FlutterSoundRecorder();

    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Micrófono denegado");
    }

    await _audioRecorder!.openAudioSession();
    _isRecordedInitialised = true;
  }

  Future dispose() async {
    if (!_isRecordedInitialised) return;

    _audioRecorder!.closeAudioSession();
    _audioRecorder = null;
    _isRecordedInitialised = false;
  }

  Future _record() async {
    if (!_isRecordedInitialised) return;
    await _audioRecorder!.startRecorder(toFile: pathToSaveFile);
  }

  Future _stop() async {
    if (!_isRecordedInitialised) return;
    await _audioRecorder!.stopRecorder();
  
  }
  Future toggleRecording() async {
    if(_audioRecorder!.isStopped) {
      await _record();
    } else {
      await _stop();
    }
  }
}