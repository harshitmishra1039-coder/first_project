class ChatbotService {
  String getBotReply(String message) {
    message = message.toLowerCase();

    if (message.contains("wheat")) {
      return "For wheat, use nitrogen-rich fertilizer.";
    }

    if (message.contains("rice")) {
      return "Rice requires adequate water and fertile soil.";
    }

    if (message.contains("fertilizer")) {
      return "Use fertilizer according to soil testing.";
    }

    return "Sorry, I don't understand your question.";
  }
}