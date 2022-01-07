import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sonido/audio_player.dart';
import 'audio_recorder.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

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
  final String token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMjZiMThmMDg2Y2I5MzRlNTI5MWIxZmMwN2IzNGRhYzQ5YzQxZWM0OGExZDk5Y2UzMmVlNjk0MWE2NTJlYWY5OTJjNDY5OGYxMDViYWQxZDIiLCJpYXQiOjE2NDE1OTAwNzIuODE0NjE4LCJuYmYiOjE2NDE1OTAwNzIuODE0NjIxLCJleHAiOjE2NzMxMjYwNzIuODEyNjYxLCJzdWIiOiIyOSIsInNjb3BlcyI6W119.LM0Fgw-034w1UfjXi0KWBIvsJUD4og8tOcBAgNQI6nC3uyldp3fPp18dUS0HL8WKrIqctOe9CaxJYLsOAJhLGXe9j3UUirel3Yvuar05SDcan8CmzLrtttWHvgsirpMN_YSHGcL7Chmx9um6A75jqixTGhj89NDTs-AfKL3xiXAMW1EG3QHPgtqiD-EezjFgayaMgsl9J8eJV5sPaTSoNU3rHovXFX_eT68gMLlE8s88Bd-5LPAUgpBSZ8JZzaVh3ObmyviFIeSbAl24NMYF4BgN2tb2csWnm8r1_2P9PLsSOT-Yt-X-5BRyfUdNmtUmo_qdPUrCf7wvoDZf5KjatisnP2fzAA0oGJOiMJPJgJDFZ8yjLyJjsWYYhTEJ8yB3K1QHo6anZ_X2B14wJ1feJERxpOEf0KYtDSGGzbMXCPfUOK97s9saRlKoeh6qtIUouTCrxSx-fOmDFE7F3JnQZ5OFOHvcsP2Sa7y-Xx906YzBXZFgiT5vx4YUuOqC4ZQjfruTpV9JLhfr-ydAUivy89r7hN4VwimLFfidV0CsL0BGEkdtRSv1Xge7xtrvSOd5SrnTa59ua1XQWc6POK70Xm3rdWRY3p6GZn3IaDkEr-qTx3JdLugpanGe3cpg-N3gvjkg-_NI5rm-XznT_03B9R_jIduqEsu5hEk7KN8EKIw";
  bool _isLoading = false;
  setLoading(bool state) => setState(() => _isLoading = state);

  Future<dynamic> cambiarSonido(sonido) async {
    var postUri = Uri.parse(
        "http://picktock.alwaysdata.net/picktock-backend/public/api/auth/sonido/65");
    var request = http.MultipartRequest("POST", postUri);
    request.headers.addAll(
        {"Authorization": "Bearer $token", "Accept": "application/json"});
    http.MultipartFile multipartFile = await http.MultipartFile.fromPath('pic_sonido', sonido);
    request.files.add(multipartFile);
    var response = await request.send();
    final respStr = await response.stream.bytesToString();
    Map valor = jsonDecode(respStr);

    if (response.statusCode == 201) {
      print("Éxito");
    } else if (response.statusCode == 422) {
      setState(() {
        print("Errorrr");
      });
    } else if (response.statusCode == 401) {
      print("No autorizado");
    } else {
      print("Error no identificado");
    }
  }

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
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              recorButton(),
              playButton(),
              
              ElevatedButton(
                onPressed: () async {
                  // devolverá true si el formulario es válido, o falso si
                  // el formulario no es válido.
                  setLoading(true);
                  Directory directorio = await getApplicationDocumentsDirectory();
                  print(directorio);
                  await cambiarSonido("inserte sonido");
                  setLoading(false);
                
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBarCustomerPick.showSnackBarFail(
                  //       context: context, message: "Error en el registro"),);
                },
                child: const Icon(Icons.save),
              ),
              if (_isLoading)
                const CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }

  void _guardar() {}

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
    final icon = isPlaying ? Icons.stop : Icons.play_arrow;
    final text = isPlaying ? "Detener" : "Reproducir";
    return ElevatedButton.icon(
        onPressed: () async {
          await player.togglePlaying(whenFinished: () => setState(() {}));
          setState(() {});
        },
        icon: Icon(icon),
        label: Text(text));
  }
}
