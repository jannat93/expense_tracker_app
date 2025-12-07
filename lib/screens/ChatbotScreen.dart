import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';


const Color _darkBg = Color(0xFF141414);
const Color _cardBg = Color(0xFF1E1E1E);
const Color _primaryColor = Color(0xFFBB86FC);
const Color _whiteText = Colors.white;
const Color _darkText = Color(0xFF141414);


const String _apiKey = "AIzaSyCtG3G8mn6dK_jO0IZYkGJLzFjiCTnWBEA";


class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage(this.text, this.isUser);
}

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  late final ChatSession _chatSession;

  @override
  void initState() {
    super.initState();
    _initializeGeminiChat();
  }


  void _initializeGeminiChat() {
    final model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: _apiKey,

      // ✔ Correct system instruction
      systemInstruction: Content.text(
          "You are a professional Budget Advisor. Your goal is to give simple, budget-friendly alternatives for expensive items. Be clear and helpful."
      ),
    );

    const welcomeMessage =
        "Hello! I'm your Budget Advisor. Tell me any expensive item you're considering, and I’ll suggest a cheaper alternative!";

    _chatSession = model.startChat(
      history: [
        Content.text(welcomeMessage),
      ],
    );

    _messages.add(ChatMessage(welcomeMessage, false));
  }


  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(ChatMessage(text, true));
      _isLoading = true;
    });

    _controller.clear();

    try {
      final response = await _chatSession.sendMessage(Content.text(text));

      final reply = response.text ?? "Sorry, I couldn’t think of an alternative.";

      setState(() {
        _messages.add(ChatMessage(reply, false));
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage("Error: $e", false));
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _darkBg,
      appBar: AppBar(
        backgroundColor: _cardBg,
        title: const Text("Budget Chatbot", style: TextStyle(color: _whiteText)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _whiteText),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (_, index) {
                final message = _messages[_messages.length - index - 1];
                return _buildMessage(message.text, message.isUser);
              },
            ),
          ),
          if (_isLoading) _buildLoadingIndicator(),
          const Divider(height: 1, color: _cardBg),
          Container(
            decoration: const BoxDecoration(color: _cardBg),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }


  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 12),
          CircularProgressIndicator(color: _primaryColor, strokeWidth: 2),
          SizedBox(width: 8),
          Text("Advisor thinking...", style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  // Chat bubbles (NO IMAGE)
  Widget _buildMessage(String text, bool isUser) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment:
        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser
                    ? _primaryColor.withOpacity(0.8)
                    : _cardBg.withOpacity(0.9),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(15),
                  topRight: const Radius.circular(15),
                  bottomLeft: isUser
                      ? const Radius.circular(15)
                      : const Radius.circular(0),
                  bottomRight: isUser
                      ? const Radius.circular(0)
                      : const Radius.circular(15),
                ),
                border: isUser
                    ? null
                    : Border.all(color: _primaryColor.withOpacity(0.3)),
              ),
              child: SelectableText(
                text,
                style: TextStyle(
                  color: isUser ? _darkText : _whiteText,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildTextComposer() {
    return IconTheme(
      data: const IconThemeData(color: _primaryColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _controller,
                onSubmitted: (_) => _sendMessage(),
                enabled: !_isLoading,
                style: const TextStyle(color: _whiteText),
                decoration: InputDecoration.collapsed(
                  hintText: _isLoading
                      ? "Waiting for response..."
                      : "Ask for a budget alternative...",
                  hintStyle: const TextStyle(color: Colors.white54),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _isLoading ? null : _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
