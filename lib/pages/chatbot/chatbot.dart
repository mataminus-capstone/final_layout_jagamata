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

  void sendMessage() async {
    String userMessage = messageController.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      messages.add({'sender': 'user', 'text': userMessage});
      messageController.clear();
    });

    final result = await ApiService.sendChatMessage(userMessage);

    setState(() {
      if (result['success']) {
        messages.add({
          'sender': 'bot',
          'text': result['response'],
        });
      } else {
        messages.add({
          'sender': 'bot',
          'text': 'Maaf, saya tidak bisa merespons saat ini.',
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('aset/image.jpg'),
                  ),
                  SizedBox(width: 15),
                  Text("ChatBot AI"),
                ],
              ),
              Icon(Icons.more_vert),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: 502,
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
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      constraints: BoxConstraints(maxWidth: 250),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue[200],
                      ),
                      child: Text(
                        msg['text'] ?? '',
                        softWrap: true,
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
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: TextField(
                controller: messageController,
                decoration: InputDecoration(
                  hintText: "Ketik pesan...",
                  suffixIcon: GestureDetector(
                    onTap: sendMessage,
                    child: Icon(Icons.send_sharp),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onSubmitted: (_) => sendMessage(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
