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
import 'audio_player_widget.dart'; // Importe o widget do player de áudio

class MyAudioApp extends StatelessWidget {
  final List<String> audioUrls = [
    'https://example.com/audio1.mp3',
    'https://example.com/audio2.mp3',
    'https://example.com/audio3.mp3',
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Audio Player Example')),
        body: Center(
          child: AudioPlayerWidget(audioUrls: audioUrls),
        ),
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
import 'audio_player_widget.dart'; // Importe o widget do player de áudio

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Audio Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AudioPlayerExample(),
    );
  }
}

class AudioPlayerExample extends StatelessWidget {
  final List<String> audioUrls = [
    'https://example.com/audio1.mp3',
    'https://example.com/audio2.mp3',
    'https://example.com/audio3.mp3',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Audio Player'),
      ),
      body: Center(
        child: AudioPlayerWidget(audioUrls: audioUrls),
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

## Licença

Este projeto está licenciado sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.