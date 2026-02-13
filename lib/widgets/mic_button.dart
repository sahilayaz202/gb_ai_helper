import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../services/speech_service.dart';

class MicButton extends StatelessWidget {
  final Function(String) onResult;

  const MicButton({super.key, required this.onResult});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppTheme.secondaryColor,
      child: const Icon(Icons.mic),
      onPressed: () async {
        await SpeechService.listen((text) {
          onResult(text);
        });
      },
    );
  }
}
