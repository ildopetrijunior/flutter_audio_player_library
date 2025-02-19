import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart'; // Para combinar streams

/// Dados combinados para atualizar a barra de progresso
class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

/// Widget avançado de áudio com playlist, controles de navegação e seek.
class AudioPlayerWidget extends StatefulWidget {
  final List<String> audioUrls;
  final Duration seekInterval;
  final AudioPlayer? audioPlayer; // Injeção opcional

  const AudioPlayerWidget({
    super.key,
    required this.audioUrls,
    this.seekInterval = const Duration(seconds: 10),
    this.audioPlayer,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  late ConcatenatingAudioSource _playlist;

  @override
  void initState() {
    super.initState();
    _audioPlayer = widget.audioPlayer ?? AudioPlayer();
    _initPlaylist();
  }

  Future<void> _initPlaylist() async {
    _playlist = ConcatenatingAudioSource(
      children: widget.audioUrls
          .map((url) => AudioSource.uri(Uri.parse(url)))
          .toList(),
    );

    try {
      await _audioPlayer.setAudioSource(_playlist);
      // Inicia a reprodução automaticamente se houver mais de uma música
      // if (widget.audioUrls.isNotEmpty) {
      //   _audioPlayer.play();
      // }
    } catch (e) {
      print("Erro ao carregar a fonte de áudio: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // Combina streams de posição, posição bufferizada e duração
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  // Alterna reprodução/pausa
  Future<void> _playPause() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  // Avança para a próxima faixa
  Future<void> _skipToNext() async {
    try {
      await _audioPlayer.seekToNext();
    } catch (e) {
      print("Não há próxima faixa disponível");
    }
  }

  // Retrocede para a faixa anterior
  Future<void> _skipToPrevious() async {
    try {
      await _audioPlayer.seekToPrevious();
    } catch (e) {
      print("Não há faixa anterior disponível");
    }
  }

  // Avança o tempo da faixa
  void _seekForward() {
    final newPosition = _audioPlayer.position + widget.seekInterval;
    _audioPlayer.seek(newPosition);
  }

  // Retrocede o tempo da faixa
  void _seekBackward() {
    final newPosition = _audioPlayer.position - widget.seekInterval;
    _audioPlayer
        .seek(newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Barra de progresso com slider
        StreamBuilder<PositionData>(
          stream: _positionDataStream,
          builder: (context, snapshot) {
            final positionData = snapshot.data;
            final duration = positionData?.duration ?? Duration.zero;
            final position = positionData?.position ?? Duration.zero;

            return Slider(
              min: 0.0,
              max: duration.inMilliseconds.toDouble(),
              value: position.inMilliseconds
                  .clamp(0, duration.inMilliseconds)
                  .toDouble(),
              onChanged: (value) {
                _audioPlayer.seek(Duration(milliseconds: value.toInt()));
              },
            );
          },
        ),
        // Linha de botões de controle
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.skip_previous),
              onPressed: _skipToPrevious,
            ),
            IconButton(
              icon: const Icon(Icons.replay_10),
              onPressed: _seekBackward,
            ),
            StreamBuilder<bool>(
              stream: _audioPlayer.playingStream,
              builder: (context, snapshot) {
                final isPlaying = snapshot.data ?? false;
                return IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: _playPause,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.forward_10),
              onPressed: _seekForward,
            ),
            IconButton(
              icon: const Icon(Icons.skip_next),
              onPressed: _skipToNext,
            ),
          ],
        ),
      ],
    );
  }
}
