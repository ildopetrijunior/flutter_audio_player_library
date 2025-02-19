import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_audio_player_library/flutter_audio_player_library.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';

/// Fake que simula o AudioPlayer do just_audio.
class FakeAudioPlayer extends Fake implements AudioPlayer {
  @override
  Duration position = Duration.zero;
  @override
  int currentIndex = 0;
  bool _playing = false;

  // Controllers para simular as streams.
  final _positionController = StreamController<Duration>.broadcast();
  final _playingController = StreamController<bool>.broadcast();

  @override
  Stream<Duration> get positionStream => _positionController.stream;

  @override
  Stream<Duration> get bufferedPositionStream => Stream.value(Duration.zero);

  @override
  Stream<Duration?> get durationStream => Stream.value(Duration(minutes: 3));

  @override
  Stream<bool> get playingStream => _playingController.stream;

  // Getter para evitar noSuchMethod.
  @override
  bool get playing => _playing;

  @override
  Future<void> seek(Duration? newPosition, {int? index}) async {
    position = newPosition ?? Duration.zero;
    _positionController.add(position);
  }

  @override
  Future<void> seekToNext() async {
    currentIndex++;
  }

  @override
  Future<void> seekToPrevious() async {
    if (currentIndex > 0) {
      currentIndex--;
    }
  }

  @override
  Future<void> play() async {
    _playing = true;
    _playingController.add(true);
  }

  @override
  Future<void> pause() async {
    _playing = false;
    _playingController.add(false);
  }

  @override
  Future<Duration?> setAudioSource(
    AudioSource source, {
    int? initialIndex,
    Duration? initialPosition,
    bool preload = false,
  }) async {
    // Para os testes, retornamos uma duração fixa.
    return Duration(minutes: 3);
  }

  @override
  Future<void> dispose() async {
    await _positionController.close();
    await _playingController.close();
  }

  /// Método extra para simular o término de uma faixa.
  void simulateTrackCompletion() {
    // Simula que a faixa terminou: reseta a posição e passa para a próxima.
    position = Duration.zero;
    _positionController.add(position);
    currentIndex++;
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late FakeAudioPlayer fakeAudioPlayer;
  late Widget testWidget;

  setUp(() {
    fakeAudioPlayer = FakeAudioPlayer();
    testWidget = MaterialApp(
      home: Scaffold(
        body: AudioPlayerWidget(
          audioUrls: [
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
          ],
          seekInterval: const Duration(seconds: 10),
          audioPlayer: fakeAudioPlayer, // Injeção do fake para os testes
        ),
      ),
    );
  });

  testWidgets('Tocar botão de play/pause alterna o ícone',
      (WidgetTester tester) async {
    await tester.pumpWidget(testWidget);

    // Inicialmente, o ícone de play deve estar presente.
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);

    // Simula o toque no botão de play.
    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Após tocar, o ícone deve mudar para pause.
    expect(find.byIcon(Icons.pause), findsOneWidget);

    // Toca novamente para pausar.
    await tester.tap(find.byIcon(Icons.pause));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Deve voltar a mostrar o ícone de play.
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
  });

  testWidgets('Botões de avançar e retroceder tempo atualizam a posição',
      (WidgetTester tester) async {
    await tester.pumpWidget(testWidget);

    // Posição inicial deve ser 0.
    expect(fakeAudioPlayer.position, Duration.zero);

    // Botão de avançar 10 segundos.
    final forwardButton = find.byIcon(Icons.forward_10);
    expect(forwardButton, findsOneWidget);
    await tester.tap(forwardButton);
    await tester.pumpAndSettle();
    expect(fakeAudioPlayer.position, Duration(seconds: 10));

    // Botão de retroceder 10 segundos.
    // Primeiro, avance a 20 segundos para ter margem.
    fakeAudioPlayer.position = Duration(seconds: 20);
    await fakeAudioPlayer.seek(Duration(seconds: 20));
    final backwardButton = find.byIcon(Icons.replay_10);
    expect(backwardButton, findsOneWidget);
    await tester.tap(backwardButton);
    await tester.pumpAndSettle();
    expect(fakeAudioPlayer.position, Duration(seconds: 10));
  });

  testWidgets('Botão de próxima música atualiza o índice',
      (WidgetTester tester) async {
    // Inicialmente, currentIndex deve ser 0.
    fakeAudioPlayer.currentIndex = 0;
    await tester.pumpWidget(testWidget);

    final nextButton = find.byIcon(Icons.skip_next);
    expect(nextButton, findsOneWidget);

    await tester.tap(nextButton);
    await tester.pumpAndSettle();

    expect(fakeAudioPlayer.currentIndex, 1);
  });

  testWidgets('Botão de música anterior atualiza o índice',
      (WidgetTester tester) async {
    // Configure índice inicial em 1 para permitir retroceder.
    fakeAudioPlayer.currentIndex = 1;
    await tester.pumpWidget(testWidget);

    final previousButton = find.byIcon(Icons.skip_previous);
    expect(previousButton, findsOneWidget);

    await tester.tap(previousButton);
    await tester.pumpAndSettle();

    expect(fakeAudioPlayer.currentIndex, 0);
  });

  testWidgets(
      'Ao término da faixa, passa para a próxima música automaticamente',
      (WidgetTester tester) async {
    // Configura currentIndex inicial.
    fakeAudioPlayer.currentIndex = 0;
    await tester.pumpWidget(testWidget);

    // Simula a reprodução iniciada.
    await fakeAudioPlayer.play();
    await tester.pumpAndSettle();

    // Simula o término da faixa.
    fakeAudioPlayer.simulateTrackCompletion();
    await tester.pumpAndSettle();

    // Verifica se a próxima faixa foi selecionada.
    expect(fakeAudioPlayer.currentIndex, 1);
  });
}
