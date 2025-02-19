import 'package:flutter/material.dart';
import 'package:flutter_audio_player_library/flutter_audio_player_library.dart';

class MyCustomAudioPlayer extends StatelessWidget {
  const MyCustomAudioPlayer({super.key, required this.musicUrls});

  final List<String> musicUrls;

  @override
  Widget build(BuildContext context) {
    return AudioPlayerWidget(audioUrls: musicUrls);
  }
}

void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      body: Center(
        child: MyCustomAudioPlayer(
          musicUrls: [
            'https://example.com/audio1.mp3',
            'https://example.com/audio2.mp3',
          ],
        ),
      ),
    ),
  ));
}
