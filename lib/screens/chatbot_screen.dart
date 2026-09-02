import 'package:flutter/material.dart';
import '../services/gemini_service.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController messageController = TextEditingController();
  final GeminiService geminiService = GeminiService();
  bool isSpeechMode = false;
  bool isListening = false;
  bool isLoading = false;

  final List<Map<String, String>> messages = [
    {
      "sender": "user",
      "message": "गेहूं की खेती कैसे करें?",
      "time": "10:31 AM",
    },
    {
      "sender": "bot",
      "message": "गेहूं की खेती के लिए ये मुख्य बातें ध्यान रखें:\n\n• अक्टूबर - नवंबर में बुआई करें\n• अच्छी किस्म का चयन करें\n• समय पर सिंचाई करें\n• यूरिया, DAP और पोटाश का संतुलित उपयोग करें\n• खरपतवार नियंत्रण करें\n• फसल कटाई अप्रैल - मई में करें",
      "time": "10:31 AM",
    },
  ];

  final List<String> defaultPrompts = [
    "फसल की बुआई कब करें?",
    "कौन सा खाद उपयोग करें?",
    "मेरे पौधे में बीमारी है",
    "आज मौसम कैसा रहेगा?",
    "गेहूं की खेती कैसे करें?",
  ];

  Future<void> sendUserMessage(String text) async {
    final query = text.trim();
    if (query.isEmpty) return;

    final now = TimeOfDay.now().format(context);

    setState(() {
      messages.add({
        "sender": "user",
        "message": query,
        "time": now,
      });
      isLoading = true;
    });

    messageController.clear();

    try {
      final reply = await geminiService.getResponse(query);
      if (mounted) {
        setState(() {
          messages.add({
            "sender": "bot",
            "message": reply,
            "time": TimeOfDay.now().format(context),
          });
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          messages.add({
            "sender": "bot",
            "message": "क्षमा करें, उत्तर प्राप्त करने में समस्या हुई। कृपया पुनः प्रयास करें।",
            "time": TimeOfDay.now().format(context),
          });
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void toggleListening() {
    setState(() {
      isListening = !isListening;
    });
    if (isListening) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && isListening) {
          setState(() {
            isListening = false;
          });
          sendUserMessage("कौन सा खाद उपयोग करें?");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF212121)),
          onPressed: () {
            if (Navigator.canPop(context)) Navigator.pop(context);
          },
        ),
        title: const Text(
          "AI Assistant",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Color(0xFF616161)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Banner Card with Cute Robot Avatar
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9).withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFC8E6C9)),
                    ),
                    child: Row(
                      children: [
                        // Robot Avatar Container
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E6F3D),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.smart_toy,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Hello Ramesh!",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF212121),
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Text("👋", style: TextStyle(fontSize: 14)),
                                ],
                              ),
                              SizedBox(height: 2),
                              Text(
                                "I am your AI Farming Assistant.\nHow can I help you today?",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF424242),
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Prompt Suggestions Section ("You can ask me:")
                  const Text(
                    "You can ask me:",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF757575),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Quick Action Chips in Hindi
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: defaultPrompts.map((prompt) {
                      return InkWell(
                        onTap: () => sendUserMessage(prompt),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            prompt,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF424242),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // Chat Bubbles Stream/List
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: messages.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = messages[index];
                      final isUser = item["sender"] == "user";

                      if (isUser) {
                        return Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: const BoxDecoration(
                              color: Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(4),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  item["message"]!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF1B5E20),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      item["time"] ?? "10:31 AM",
                                      style: const TextStyle(fontSize: 10, color: Color(0xFF81C784)),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.done_all, size: 14, color: Color(0xFF4CAF50)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F5E9),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.smart_toy,
                                  color: Color(0xFF1E6F3D),
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: const Color(0xFFE0E0E0)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.02),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item["message"]!,
                                        style: const TextStyle(
                                          fontSize: 13.5,
                                          color: Color(0xFF212121),
                                          height: 1.45,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          item["time"] ?? "10:31 AM",
                                          style: const TextStyle(fontSize: 10, color: Color(0xFF9E9E9E)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),

                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: CircularProgressIndicator(color: Color(0xFF1E6F3D)),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Bottom Voice / Input Mode Area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Mode Toggle Row (AI Chat / AI Speech)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          isSpeechMode = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: !isSpeechMode ? const Color(0xFFE8F5E9) : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: !isSpeechMode ? const Color(0xFF1E6F3D) : const Color(0xFFE0E0E0),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 16,
                              color: !isSpeechMode ? const Color(0xFF1E6F3D) : const Color(0xFF757575),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "AI Chat",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: !isSpeechMode ? FontWeight.bold : FontWeight.w500,
                                color: !isSpeechMode ? const Color(0xFF1E6F3D) : const Color(0xFF757575),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isSpeechMode = true;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSpeechMode ? const Color(0xFFE8F5E9) : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSpeechMode ? const Color(0xFF1E6F3D) : const Color(0xFFE0E0E0),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.mic_none,
                              size: 16,
                              color: isSpeechMode ? const Color(0xFF1E6F3D) : const Color(0xFF757575),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "AI Speech",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSpeechMode ? FontWeight.bold : FontWeight.w500,
                                color: isSpeechMode ? const Color(0xFF1E6F3D) : const Color(0xFF757575),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                if (!isSpeechMode)
                  // Chat Input Box Row
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                            hintText: "Ask anything about crops...",
                            hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF9E9E9E)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            filled: true,
                            fillColor: const Color(0xFFF1F3F1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onSubmitted: (text) => sendUserMessage(text),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFF1E6F3D),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.white, size: 20),
                          onPressed: () => sendUserMessage(messageController.text),
                        ),
                      ),
                    ],
                  )
                else
                  // Speech Mic Wave Section
                  Column(
                    children: [
                      // Audio Wave Graphic Visualizer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(15, (index) {
                          final heights = [10.0, 18.0, 24.0, 14.0, 32.0, 20.0, 38.0, 28.0, 16.0, 30.0, 18.0, 26.0, 12.0, 20.0, 10.0];
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            width: 3,
                            height: isListening ? (heights[index % heights.length] * 1.2) : 8.0,
                            decoration: BoxDecoration(
                              color: isListening ? const Color(0xFF1E6F3D) : const Color(0xFFC8E6C9),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 12),

                      // Large Circular Mic Button
                      GestureDetector(
                        onTap: toggleListening,
                        child: Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: isListening ? Colors.red : const Color(0xFF1E6F3D),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: (isListening ? Colors.red : const Color(0xFF1E6F3D)).withValues(alpha: 0.35),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            isListening ? Icons.stop : Icons.mic,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isListening ? "Listening... Speak now" : "Tap to Speak",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF757575),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}