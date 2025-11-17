import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage>
    with SingleTickerProviderStateMixin {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  late AnimationController _animationController;

  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: 0.8,
      upperBound: 1.2,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        }
      });
  }

  // --- THIS FUNCTION IS NOW MODIFIED ---
  void _toggleRecording() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          _isListening = true;
        });
        _animationController.forward();

        // 1. Add an empty message bubble for the user
        _addMessage("", true); 

        _speech.listen(onResult: (result) {
          
          // 2. Update the most recent message (at index 0) with interim text
          setState(() {
            _messages[0] = ChatMessage(text: result.recognizedWords, isUser: true);
          });

          // 3. When speech is final, get AI response and stop
          if (result.finalResult) {
            String userText = result.recognizedWords;

            // Placeholder AI response (you can replace with Hugging Face API)
            String aiResponse = "You said: \"$userText\"";
            _addMessage(aiResponse, false);

            setState(() {
              _isListening = false;
            });
            _animationController.stop();
            _speech.stop();
          }
        });
      } else {
        _addMessage("Speech recognition not available!", false);
      }
    } else {
      // This is the "stop" button logic if user taps again
      setState(() {
        _isListening = false;
      });
      _animationController.stop();
      _speech.stop();
    }
  }

  void _addMessage(String text, bool isUser) {
    setState(() {
      _messages.insert(0, ChatMessage(text: text, isUser: isUser));
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Talk'),
        backgroundColor: const Color(0xFF2C5364),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ListView.builder(
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      ChatMessage message = _messages[index];
                      return Align(
                        alignment: message.isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: message.isUser
                                ? Colors.blueAccent
                                : Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft:
                                  Radius.circular(message.isUser ? 16 : 0),
                              bottomRight:
                                  Radius.circular(message.isUser ? 0 : 16),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                          // This part is important for the real-time update
                          child: Text(
                            // Show "Listening..." if the text is still empty
                            message.text.isEmpty && message.isUser
                                ? "Listening..."
                                : message.text,
                            style: TextStyle(
                              color:
                                  message.isUser ? Colors.white : Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ScaleTransition(
                scale: _animationController,
                child: GestureDetector(
                  onTap: _toggleRecording,
                  child: Container(
                    width: 90,
                    height: 90,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isListening ? Colors.redAccent : Colors.blueAccent,
                      boxShadow: [
                        if (_isListening)
                          BoxShadow(
                            color: Colors.redAccent.withOpacity(0.6),
                            blurRadius: 20,
                            spreadRadius: 10,
                          ),
                      ],
                    ),
                    child: const Icon(
                      Icons.mic,
                      color: Colors.white,
                      size: 45,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}