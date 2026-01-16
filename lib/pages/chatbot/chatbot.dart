import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jagamata/services/api_service.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Brand Colors
  final Color kDarkBlue = const Color(0xFF11417f);
  final Color kLightBlue = const Color(0xFF14b4ef);
  final Color kTosca = const Color(0xFFa2c38e);

  List<Map<String, dynamic>> messages = [
    {'sender': 'bot', 'text': 'Hi, apakah ada yang bisa saya bantu?', 'isTyping': false}
  ];
  bool isLoading = false;
  
  // Typing animation state
  String _currentTypingText = '';
  Timer? _typingTimer;

  @override
  void dispose() {
    messageController.dispose();
    _scrollController.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      // Small delay to allow list view to update frame before scrolling
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void sendMessage() async {
    String userMessage = messageController.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      messages.add({'sender': 'user', 'text': userMessage, 'isTyping': false});
      messageController.clear();
      isLoading = true;
    });
    
    _scrollToBottom();

    try {
      final result = await ApiService.sendChatMessage(userMessage);

      // Add a placeholder message for typing/thinking if needed,
      // but since we want to animate the text "typing" style, we'll handle it nicely.
      // Wait for response first essentially makes it "Thinking..." state
      
      setState(() {
        isLoading = false;
        String responseText = result['success'] 
             ? (result['response'] ?? 'Maaf, saya tidak bisa merespons saat ini.')
             : (result['response'] ?? 'Maaf, terjadi kesalahan.');

        // Add empty bot message first to animate into
        messages.add({'sender': 'bot', 'text': '', 'isTyping': true});
        _animateText(responseText, messages.length - 1);
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        messages.add({'sender': 'bot', 'text': 'Error: $e', 'isTyping': false});
      });
    }
  }

  void _animateText(String fullText, int messageIndex) {
    _currentTypingText = '';
    int characterIndex = 0;
    
    _typingTimer?.cancel();
    _typingTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (characterIndex < fullText.length) {
        setState(() {
          _currentTypingText += fullText[characterIndex];
          messages[messageIndex]['text'] = _currentTypingText;
          messages[messageIndex]['isTyping'] = true; // Still typing
        });
        characterIndex++;
        _scrollToBottom(); // Keep scrolling to bottom as text grows
      } else {
        setState(() {
          messages[messageIndex]['isTyping'] = false; // Done
        });
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: kDarkBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: kLightBlue.withOpacity(0.1),
              child: Icon(Icons.smart_toy_rounded, color: kLightBlue),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tanya Chatbot",
                  style: TextStyle(
                    color: kDarkBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "JagaMata Chatbot Siap Membantu",
                  style: TextStyle(
                    color: kTosca,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: kDarkBlue),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: messages.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == messages.length && isLoading) {
                  // Thinking indicator
                  return _buildThinkingIndicator();
                }

                final msg = messages[index];
                final isBot = msg['sender'] == 'bot';
                
                return _buildMessageBubble(
                  text: msg['text'],
                  isBot: isBot,
                );
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildThinkingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(0),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 16, 
                  height: 16, 
                  child: CircularProgressIndicator(strokeWidth: 2, color: kLightBlue)
                ),
                const SizedBox(width: 10),
                Text(
                  "Thinking...",
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontStyle: FontStyle.italic,
                    fontSize: 12
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble({required String text, required bool isBot}) {
    // If bot has empty text but isTyping is false/true, we might show nothing or just bubble.
    // But our logic ensures text grows. 
    // If text is empty and not typing, skip? No, initial welcome message has text.
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isBot) ...[
                CircleAvatar(
                  radius: 14,
                  backgroundColor: kLightBlue.withOpacity(0.1),
                  child: Icon(Icons.smart_toy_rounded, size: 16, color: kLightBlue),
                ),
                const SizedBox(width: 8),
              ],
              
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isBot ? Colors.grey[100] : kLightBlue,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: isBot ? const Radius.circular(0) : const Radius.circular(20),
                      bottomRight: isBot ? const Radius.circular(20) : const Radius.circular(0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isBot ? kDarkBlue : Colors.white,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Time or status could go here
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
             Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50], // Very light grey input bg
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: TextField(
                  controller: messageController,
                  enabled: !isLoading,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => isLoading ? null : sendMessage(),
                  decoration: InputDecoration(
                    hintText: "Ketik pesan...",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: isLoading ? null : sendMessage,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isLoading ? Colors.grey[300] : kDarkBlue,
                  shape: BoxShape.circle,
                  boxShadow: [
                     BoxShadow(
                      color: (isLoading ? Colors.grey : kDarkBlue).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.send_rounded, 
                  color: Colors.white, 
                  size: 20
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
