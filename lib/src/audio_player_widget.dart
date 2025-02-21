import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
  PositionData(this.position, this.bufferedPosition, this.duration);
}

class AudioPlayerWidget extends StatefulWidget {
  final List<String> audioUrls;
  final AudioPlayer? audioPlayer;
  final Function(String)? onCurrentSongChanged;
  final Function(bool)? onPlayingStateChanged;
  final bool isReduced;
  final Duration seekInterval;
  final Widget playIcon;
  final Widget pauseIcon;
  final Widget previousIcon;
  final Widget nextIcon;
  final Widget replayIcon;
  final Widget forwardIcon;
  final Color sliderActiveColor;
  final Color sliderInactiveColor;

  const AudioPlayerWidget({
    super.key,
    required this.audioUrls,
    this.audioPlayer,
    this.onCurrentSongChanged,
    this.onPlayingStateChanged,
    this.isReduced = false,
    this.seekInterval = const Duration(seconds: 10),
    this.playIcon = const Icon(Icons.play_arrow),
    this.pauseIcon = const Icon(Icons.pause),
    this.nextIcon = const Icon(Icons.skip_next),
    this.previousIcon = const Icon(Icons.skip_previous),
    this.replayIcon = const Icon(Icons.replay_10),
    this.forwardIcon = const Icon(Icons.forward_10),
    this.sliderActiveColor = Colors.blue,
    this.sliderInactiveColor = Colors.grey,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  late ConcatenatingAudioSource _playlist;
  int _currentSongIndex = 0;

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
      _notifyCurrentSong();
      _notifyPlayingState();
    } catch (e) {
      print("Erro ao carregar a fonte de áudio: $e");
    }
  }

  void _notifyCurrentSong() {
    if (widget.onCurrentSongChanged != null) {
      widget.onCurrentSongChanged!(widget.audioUrls[_currentSongIndex]);
    }
  }

  void _notifyPlayingState() {
    if (widget.onPlayingStateChanged != null) {
      widget.onPlayingStateChanged!(_audioPlayer.playing);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

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

  Future<void> _playPause() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
    _notifyPlayingState(); // Notificar o estado de reprodução após alternar
  }

  Future<void> _skipToNext() async {
    try {
      await _audioPlayer.seekToNext();
      setState(() {
        _currentSongIndex = (_currentSongIndex + 1) % widget.audioUrls.length;
      });
      _notifyCurrentSong();
      _notifyPlayingState();
    } catch (e) {
      print("Não há próxima faixa disponível");
    }
  }

  Future<void> _skipToPrevious() async {
    try {
      await _audioPlayer.seekToPrevious();
      setState(() {
        _currentSongIndex = (_currentSongIndex - 1) % widget.audioUrls.length;
      });
      _notifyCurrentSong();
      _notifyPlayingState();
    } catch (e) {
      print("Não há faixa anterior disponível");
    }
  }

  void _seekForward() {
    final newPosition = _audioPlayer.position + widget.seekInterval;
    _audioPlayer.seek(newPosition);
  }

  void _seekBackward() {
    final newPosition = _audioPlayer.position - widget.seekInterval;
    _audioPlayer
        .seek(newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  @override
  Widget build(BuildContext context) {
    return widget.isReduced
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: StreamBuilder<PositionData>(
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
                        _audioPlayer
                            .seek(Duration(milliseconds: value.toInt()));
                      },
                      activeColor: widget.sliderActiveColor,
                      inactiveColor: widget.sliderInactiveColor,
                    );
                  },
                ),
              ),
              StreamBuilder<bool>(
                stream: _audioPlayer.playingStream,
                builder: (context, snapshot) {
                  final isPlaying = snapshot.data ?? false;
                  return IconButton(
                    icon: isPlaying ? widget.pauseIcon : widget.playIcon,
                    onPressed: _playPause,
                  );
                },
              ),
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                    activeColor: widget.sliderActiveColor,
                    inactiveColor: widget.sliderInactiveColor,
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: widget.previousIcon,
                    onPressed: _skipToPrevious,
                  ),
                  IconButton(
                    icon: widget.replayIcon,
                    onPressed: _seekBackward,
                  ),
                  StreamBuilder<bool>(
                    stream: _audioPlayer.playingStream,
                    builder: (context, snapshot) {
                      final isPlaying = snapshot.data ?? false;
                      return IconButton(
                        icon: isPlaying ? widget.pauseIcon : widget.playIcon,
                        onPressed: _playPause,
                      );
                    },
                  ),
                  IconButton(
                    icon: widget.forwardIcon,
                    onPressed: _seekForward,
                  ),
                  IconButton(
                    icon: widget.nextIcon,
                    onPressed: _skipToNext,
                  ),
                ],
              ),
            ],
          );
  }
}
