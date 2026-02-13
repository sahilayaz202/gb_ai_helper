import 'package:flutter/material.dart';
import '../models/message.dart';
import '../services/gb_knowledge_service.dart';
import '../services/speech_service.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/mic_button.dart';
import '../config/theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final List<Message> messages = [];

  // Send message
  void send(String text) async {
    if (text.isEmpty) return;

    // Add user message
    setState(() => messages.add(Message(text: text, isUser: true)));
    scrollToBottom();

    // Get reply from offline knowledge service
    String reply = GBKnowledgeService.search(text);

    // Optional: AI response
    // reply = await AIService.ask(text);

    // Add slight delay for better UX
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() => messages.add(Message(text: reply, isUser: false)));
    scrollToBottom();

    // Speak out reply
    await SpeechService.speak(reply);
  }

  // Scroll to latest message
  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GB AI Helper"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/gb_bg.png'), // add your GB image here
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Chat area with transparent background
          Column(
            children: [
              // Messages list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: messages.length,
                  itemBuilder: (_, i) => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, anim) =>
                        ScaleTransition(scale: anim, child: child),
                    child: ChatBubble(
                      key: ValueKey(messages[i].text),
                      text: messages[i].text,
                      isUser: messages[i].isUser,
                    ),
                  ),
                ),
              ),
              // Input row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: "Ask about GB...",
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Mic button
                    MicButton(
                      onResult: (text) {
                        controller.text = text;
                        send(text);
                      },
                    ),
                    const SizedBox(width: 8),
                    // Send button
                    IconButton(
                      icon: const Icon(Icons.send),
                      color: AppTheme.primaryColor,
                      onPressed: () {
                        send(controller.text);
                        controller.clear();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
