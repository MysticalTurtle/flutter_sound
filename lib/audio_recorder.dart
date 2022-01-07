import 'dart:io';
import 'dart:typed_data';

import "package:flutter_sound_lite/public/flutter_sound_player.dart";
import "package:flutter_sound_lite/public/flutter_sound_recorder.dart";
import 'package:permission_handler/permission_handler.dart';

final String pathToSaveFile = "ejemplo.aac";

class SoundRecorder {
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecordedInitialised = false;
  bool get isRecording => _audioRecorder!.isRecording;
  String _fileName = 'Recording_';
  String _fileExtension = '.aac';
  String _directoryPath = '/storage/emulated/0/SoundRecorder';

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
    await _audioRecorder!.startRecorder(toFile: _directoryPath + _fileName + _fileExtension);
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

  // void _createFile() async {
  //   var _completeFileName = await generateFileName();
  //   File(_directoryPath + '/' + _completeFileName)
  //       .create(recursive: true)
  //       .then((File file) async {
  //     //write to file
  //     Uint8List bytes = await file.readAsBytes();
  //     file.writeAsBytes(bytes);
  //     print(file.path);
  //   });
  // }

  void _createDirectory() async {
    bool isDirectoryCreated = await Directory(_directoryPath).exists();
    if (!isDirectoryCreated) {
      Directory(_directoryPath).create()
          // The created directory is returned as a Future.
          .then((Directory directory) {
        print(directory.path);
      });
    }
  }

  void _writeFileToStorage() async {
    _createDirectory();
    // _createFile();
}

}