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

  @override
  void initState() {
    super.initState();
    // Initialize offline data
    GBKnowledgeService.init();
  }

  // Send message
  void send(String text) async {
    if (text.trim().isEmpty) return;

    setState(() => messages.add(Message(text: text, isUser: true)));
    scrollToBottom();

    // Get reply from offline GBKnowledgeService
    final reply = GBKnowledgeService.search(text);

    setState(() => messages.add(Message(text: reply, isUser: false)));
    scrollToBottom();

    await SpeechService.speak(reply);
  }

  // Scroll to latest message
  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
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

          // Chat area
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: messages.length,
                  itemBuilder: (_, i) => ChatBubble(
                    key: ValueKey(messages[i].text + i.toString()),
                    text: messages[i].text,
                    isUser: messages[i].isUser,
                  ),
                ),
              ),
              // Input row
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
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
                    MicButton(
                      onResult: (text) {
                        controller.text = text;
                        send(text);
                        controller.clear();
                      },
                    ),
                    const SizedBox(width: 8),
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
