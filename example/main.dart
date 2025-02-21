import 'package:flutter/material.dart';
import 'package:flutter_audio_player_library/flutter_audio_player_library.dart'; // Importe sua biblioteca

class MyCustomAudioPlayer extends StatelessWidget {
  const MyCustomAudioPlayer({
    super.key,
    this.width,
    this.height,
    required this.musicUrls,
    this.onCurrentSongChanged,
    this.onPlayingStateChanged,
    this.isReduced,
    this.seekInterval,
    this.playIcon,
    this.pauseIcon,
    this.nextIcon,
    this.previousIcon,
    this.replayIcon,
    this.forwardIcon,
    this.sliderActiveColor,
    this.sliderInactiveColor,
  });

  final double? width;
  final double? height;
  final List<String> musicUrls;
  final Function(String)? onCurrentSongChanged;
  final Function(bool)? onPlayingStateChanged;
  final bool? isReduced;
  final Duration? seekInterval;
  final Widget? playIcon;
  final Widget? pauseIcon;
  final Widget? nextIcon;
  final Widget? previousIcon;
  final Widget? replayIcon;
  final Widget? forwardIcon;
  final Color? sliderActiveColor;
  final Color? sliderInactiveColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: AudioPlayerWidget(
        audioUrls: musicUrls,
        onCurrentSongChanged: onCurrentSongChanged,
        onPlayingStateChanged: onPlayingStateChanged,
        isReduced: isReduced ?? false,
        seekInterval: seekInterval ?? const Duration(seconds: 10),
        playIcon: playIcon ?? const Icon(Icons.play_arrow),
        pauseIcon: pauseIcon ?? const Icon(Icons.pause),
        nextIcon: nextIcon ?? const Icon(Icons.skip_next),
        previousIcon: previousIcon ?? const Icon(Icons.skip_previous),
        replayIcon: replayIcon ?? const Icon(Icons.replay_10),
        forwardIcon: forwardIcon ?? const Icon(Icons.forward_10),
        sliderActiveColor: sliderActiveColor ?? Colors.blue,
        sliderInactiveColor: sliderInactiveColor ?? Colors.grey,
      ),
    );
  }
}
