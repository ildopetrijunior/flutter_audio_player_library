import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerWidget({
    super.key,
    required this.audioUrl,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAudio();
  }

  Future<void> _initAudio() async {
    await _audioPlayer.setUrl(widget.audioUrl);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _toggleAudio() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _audioPlayer.playingStream,
      builder: (context, snapshot) {
        final isPlaying = snapshot.data ?? false;
        return ElevatedButton(
          onPressed: _toggleAudio,
          child: Text(isPlaying ? 'Pausar Áudio' : 'Tocar Áudio'),
        );
      },
    );
  }
}
