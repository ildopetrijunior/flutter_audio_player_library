import 'package:flutter/material.dart';
import 'package:flutter_audio_player_library/flutter_audio_player_library.dart';

class MyCustomAudioPlayer extends StatelessWidget {
  const MyCustomAudioPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exemplo de Audio Player')),
      body: Center(
        child: AudioPlayerWidget(audioUrls: [
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
        ]),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: MyCustomAudioPlayer()));
}
