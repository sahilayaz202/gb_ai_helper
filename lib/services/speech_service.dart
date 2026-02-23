import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SpeechService {
  static final stt = SpeechToText();
  static final tts = FlutterTts();

  static Future init() async {
    await stt.initialize();
  }

  static Future<void> listen(Function(String) onText) async {
    await stt.listen(onResult: (r) {
      onText(r.recognizedWords);
    });
  }

  static Future<void> speak(String text) async {
    await tts.speak(text);
  }
}
