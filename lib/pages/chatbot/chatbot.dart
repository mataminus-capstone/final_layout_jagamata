import 'package:flutter/material.dart';
import 'package:jagamata/services/api_service.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final TextEditingController messageController = TextEditingController();
  List<Map<String, String>> messages = [
    {'sender': 'bot', 'text': 'Hayy apakah ada yang bisa saya bantu?'}
  ];
  bool isLoading = false;

  void sendMessage() async {
    String userMessage = messageController.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      messages.add({'sender': 'user', 'text': userMessage});
      messageController.clear();
      isLoading = true;
    });

    final result = await ApiService.sendChatMessage(userMessage);

    setState(() {
      isLoading = false;
      if (result['success']) {
        messages.add({
          'sender': 'bot',
          'text': result['response'] ?? 'Maaf, saya tidak bisa merespons saat ini.',
        });
      } else {
        messages.add({
          'sender': 'bot',
          'text': result['response'] ?? 'Maaf, saya tidak bisa merespons saat ini.',
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFF4A77A1),
                    child: Icon(Icons.smart_toy, color: Colors.white),
                  ),
                  const SizedBox(width: 15),
                  const Text(
                    "ChatBot AI",
                    style: TextStyle(
                      color: Color(0xFF4A77A1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.more_vert, color: Color(0xFF4A77A1)),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.blue[50]),
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isBot = msg['sender'] == 'bot';

                return Row(
                  mainAxisAlignment:
                      isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: 20,
                        left: isBot ? 10 : 0,
                        right: isBot ? 0 : 10,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      constraints: const BoxConstraints(maxWidth: 280),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: isBot ? Colors.blue[200] : const Color(0xFF4A77A1),
                      ),
                      child: Text(
                        msg['text'] ?? '',
                        softWrap: true,
                        style: TextStyle(
                          color: isBot ? Colors.black87 : Colors.white,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: messageController,
                enabled: !isLoading,
                decoration: InputDecoration(
                  hintText: "Ketik pesan...",
                  suffixIcon: GestureDetector(
                    onTap: isLoading ? null : sendMessage,
                    child: Icon(
                      Icons.send_sharp,
                      color: isLoading ? Colors.grey : Colors.blue,
                    ),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onSubmitted: (_) => isLoading ? null : sendMessage(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}
