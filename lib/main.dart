import 'package:flutter/material.dart';
import 'services/gb_knowledge_service.dart';
import 'screens/chat_screen.dart';
import 'services/speech_service.dart';
import 'config/theme.dart'; // <-- added theme import
import 'services/backend_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GBKnowledgeService.init();
  await SpeechService.init();
  runApp(const GBApp());
}

class GBApp extends StatelessWidget {
  const GBApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "GB AI Helper",             // renamed to match project
      theme: AppTheme.lightTheme,        // Gilgiti-style theme applied
      home: const ChatScreen(),           // open chat screen
    );
  }
}
