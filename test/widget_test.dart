import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gb_ai_helper/screens/chat_screen.dart';
import 'package:gb_ai_helper/services/gb_knowledge_service.dart';
import 'package:gb_ai_helper/services/speech_service.dart';

// Mock GBKnowledgeService
class MockGBKnowledgeService extends GBKnowledgeService {
  static String search(String query) {
    return "Mock reply for '$query'";
  }

  static Future<void> init() async {}
}

// Mock SpeechService
class MockSpeechService extends SpeechService {
  static Future<void> init() async {}
  static Future<void> speak(String text) async {}
}

void main() {
  setUpAll(() async {
    // Use mocks instead of real services
    await MockGBKnowledgeService.init();
    await MockSpeechService.init();
  });

  testWidgets('ChatScreen renders and sends message', (WidgetTester tester) async {
    // Wrap your screen with MaterialApp
    await tester.pumpWidget(
      const MaterialApp(
        home: ChatScreen(),
      ),
    );

    // Wait for the first frame
    await tester.pumpAndSettle();

    // Verify AppBar title exists
    expect(find.text('GB AI Helper'), findsOneWidget);

    // Verify TextField exists
    expect(find.byType(TextField), findsOneWidget);

    // Verify Send button exists
    expect(find.byIcon(Icons.send), findsOneWidget);

    // Enter a message in TextField
    await tester.enterText(find.byType(TextField), 'Hello GB');
    await tester.tap(find.byIcon(Icons.send));

    // Wait for animations and rebuild
    await tester.pumpAndSettle();

    // Verify user message is added
    expect(find.text('Hello GB'), findsOneWidget);

    // Verify bot reply is added
    expect(find.text("Mock reply for 'Hello GB'"), findsOneWidget);
  });
}
