import 'package:flutter/material.dart';
import 'package:flutter_audio_player_library/flutter_audio_player_library.dart';

class MyCustomAudioPlayer extends StatelessWidget {
  const MyCustomAudioPlayer({
    super.key,
    this.width,
    this.height,
    required this.musicUrls,
  });

  final double? width;
  final double? height;
  final List<String> musicUrls;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: AudioPlayerWidget(
        audioUrls: musicUrls,
      ),
    );
  }
}
