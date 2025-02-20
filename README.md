# Flutter Audio Player Library

Biblioteca Flutter para reprodução de áudio com playlist, controles de reprodução (play/pause), seek, e navegação entre faixas (próxima e anterior). Desenvolvido para ser fácil de integrar em projetos Flutter, inclusive no FlutterFlow.

---

## Sumário

- [Recursos Principais](#recursos-principais)
- [Instalação](#instalação)
- [Uso Básico](#uso-básico)
- [Exemplo Completo](#exemplo-completo)
- [Integração com FlutterFlow](#integração-com-flutterflow)
- [Testes](#testes)
- [Contribuindo](#contribuindo)
- [Licença](#licença)

---

## Recursos Principais

1. **Reprodução de Áudio:** Utiliza o pacote [`just_audio`](https://pub.dev/packages/just_audio) para tocar arquivos MP3, entre outros formatos suportados.
2. **Playlist:** Suporta lista de músicas, avançando automaticamente para a próxima faixa.
3. **Controles de Reprodução:**
   - Play/Pause
   - Avanço e retrocesso de tempo (por exemplo, 10 segundos)
   - Próxima e anterior faixa
4. **Barra de Progresso:** Mostra a posição atual, permitindo pular para qualquer ponto.

---

## Instalação

No seu projeto Flutter, adicione a dependência no arquivo `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_audio_player_library: ^<1.0.0>
  ```

---

## Uso Básico

Para começar a usar o `AudioPlayerWidget`, basta passar uma lista de URLs de áudio para o construtor. O widget cuidará da reprodução, controles e navegação entre as faixas.

```dart
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

```

---

## Exemplo Completo

Aqui está um exemplo completo de como usar o `AudioPlayerWidget` em um aplicativo Flutter:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_audio_player_library/flutter_audio_player_library.dart'; // Importe sua biblioteca

class MyCustomAudioPlayer extends StatelessWidget {
  const MyCustomAudioPlayer({
    super.key,
    this.width,
    this.height,
    required this.musicUrls,
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
  final Widget playIcon;
  final Widget pauseIcon;
  final Widget nextIcon;
  final Widget previousIcon;
  final Widget replayIcon;
  final Widget forwardIcon;
  final Color sliderActiveColor;
  final Color sliderInactiveColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: AudioPlayerWidget(
        audioUrls: musicUrls,
        seekInterval: seekInterval ?? const Duration(seconds: 10),
        playIcon: playIconn ?? const Icon(Icons.play_arrow),
        pauseIcon: pauseIconn ?? const Icon(Icons.pause),
        nextIcon: nextIconn ?? const Icon(Icons.skip_next),
        previousIcon: previousIconn ?? const Icon(Icons.skip_previous),
        replayIcon: replayIcon ?? const Icon(Icons.replay_10),
        forwardIcon: forwardIcon ??  const Icon(Icons.forward_10),
        sliderActiveColor: sliderActiveColor ??  Colors.blue,
        sliderInactiveColor: sliderInactiveColor ??  = Colors.grey,
      ),
    );
  }
}
```

---


## Integração com FlutterFlow

Para integrar o `AudioPlayerWidget` no FlutterFlow, siga os passos abaixo:

1. **Adicione o código do player ao seu projeto:** Copie o código do `AudioPlayerWidget` para o diretório `lib` do seu projeto FlutterFlow.
2. **Crie um componente personalizado:** No FlutterFlow, crie um componente personalizado e adicione o `AudioPlayerWidget` como um widget customizado.
3. **Passe as URLs de áudio:** Configure as URLs de áudio dinamicamente usando variáveis ou dados do backend.

Exemplo de configuração no FlutterFlow:

- **Componente Personalizado:** `AudioPlayerWidget`
- **Propriedades:** 
  - `audioUrls`: Lista de URLs de áudio (pode ser passada como uma variável ou lista fixa).

---

## Testes

Para garantir que o `AudioPlayerWidget` funcione corretamente, você pode escrever testes unitários e de widget. Aqui está um exemplo básico de teste de widget:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'audio_player_widget.dart';

void main() {
  testWidgets('AudioPlayerWidget test', (WidgetTester tester) async {
    final audioUrls = [
      'https://example.com/audio1.mp3',
      'https://example.com/audio2.mp3',
    ];

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: AudioPlayerWidget(audioUrls: audioUrls),
      ),
    ));

    expect(find.byType(AudioPlayerWidget), findsOneWidget);
  });
}
```

---

## Contribuindo

Contribuições são bem-vindas! Se você deseja contribuir para este projeto, siga os passos abaixo:

1. Faça um fork do repositório.
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`).
3. Commit suas mudanças (`git commit -m 'Adicionando nova feature'`).
4. Push para a branch (`git push origin feature/nova-feature`).
5. Abra um Pull Request.

---

## Créditos

Principal autor: Ildo Petri Junior

Se você tiver algum feedback ou sugestão, fico a sua disposição para você me contatar diretamente.
Agradeço ao time da Agência BOZ por todo o suporte durante o desenvolvimento desta biblioteca.

---

## Licença

Este projeto está licenciado sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.