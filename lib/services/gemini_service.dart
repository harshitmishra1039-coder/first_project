import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  // Safe environment lookup or fallback
  static const String _envKey = String.fromEnvironment('GEMINI_API_KEY');
  static const String _fallbackKey = "PASTE_YOUR_NEW_API_KEY_HERE";

  String get effectiveApiKey {
    if (_envKey.isNotEmpty) return _envKey;
    return _fallbackKey;
  }

  bool get isKeyConfigured {
    final key = effectiveApiKey;
    return key.isNotEmpty && key != "PASTE_YOUR_NEW_API_KEY_HERE" && key != "...";
  }

  // ==========================
  // TEXT CHAT RESPONSE
  // ==========================
  Future<String> getResponse(String prompt) async {
    final String query = prompt.toLowerCase();

    // Context system prompt to prepend
    final String systemPrompt = 
        "You are CropConnect AI, an expert agricultural advisor. Answer the following question focusing on farming, crops, fertilizers, irrigation, and weather:\n\n";

    if (!isKeyConfigured) {
      return _getMockChatResponse(query);
    }

    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: effectiveApiKey,
      );

      final response = await model.generateContent([
        Content.text(systemPrompt + prompt),
      ]);

      return response.text ?? "No response from Gemini.";
    } catch (e) {
      print("Gemini API Error: $e. Falling back to mock response.");
      return "${_getMockChatResponse(query)}\n\n(Note: Fallback response used due to API error: $e)";
    }
  }

  // ==========================
  // IMAGE LEAF ANALYSIS
  // ==========================
  Future<String> analyzeLeafImage(Uint8List imageBytes) async {
    if (!isKeyConfigured) {
      return _getMockVisionResponse();
    }

    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: effectiveApiKey,
      );

      final response = await model.generateContent([
        Content.multi([
          DataPart('image/jpeg', imageBytes),
          TextPart(
            "Analyze this crop leaf image. Identify any potential disease, "
            "recommend actions or treatments, and describe prevention steps. "
            "Format the output clearly as an agricultural diagnosis report."
          ),
        ]),
      ]);

      return response.text ?? "No response from Gemini Vision.";
    } catch (e) {
      print("Gemini Vision API Error: $e. Falling back to mock response.");
      return "${_getMockVisionResponse()}\n\n(Note: Fallback response used due to API error: $e)";
    }
  }

  // ==========================
  // MOCK CHAT REPLIES
  // ==========================
  String _getMockChatResponse(String query) {
    if (query.contains("wheat") || query.contains("गेहूं")) {
      return "Based on CropConnect AI analysis: Wheat thrives in well-drained loamy soils. For optimal yield, apply Nitrogen, Phosphorus, and Potassium (NPK) in a 4:2:1 ratio. Maintain soil moisture during the crown root initiation (CRI) stage (approx. 20-25 days after sowing).";
    }
    if (query.contains("rice") || query.contains("धान") || query.contains("चावल")) {
      return "Based on CropConnect AI analysis: Rice requires standing water in early growth. Ensure clayey/loamy soil which retains water well. Apply Zinc Sulphate (25 kg/ha) to prevent Khaira disease. Keep weeding regularly.";
    }
    if (query.contains("fertilizer") || query.contains("खाद")) {
      return "Based on CropConnect AI analysis: Always conduct a soil test before applying fertilizers. Urea provides Nitrogen, DAP provides Phosphorus/Nitrogen, and MOP provides Potassium. For organic farming, utilize vermicompost or neem cakes to improve soil texture.";
    }
    if (query.contains("disease") || query.contains("बीमारी") || query.contains("कीड़ा")) {
      return "Based on CropConnect AI analysis: Identify symptoms first. Spots or white powder usually mean fungal infection (apply copper oxychloride). Yellowing of leaves typically indicates nitrogen deficiency or mosaic virus. Send a photo in the 'Disease' tab for scanning.";
    }
    return "Based on CropConnect AI analysis: To grow healthy crops, ensure soil pH is between 6.0 and 7.5. Apply organic manure mixed with suitable NPK fertilizers. Water the fields based on crop type and weather forecasts. Ask me about a specific crop like Wheat, Rice, or Tomato!";
  }

  // ==========================
  // MOCK VISION REPLY
  // ==========================
  String _getMockVisionResponse() {
    return "🌿 Crop Disease Diagnostic Report:\n\n"
        "* **Identified Disease**: Leaf Spot / Rust\n"
        "* **Severity**: Moderate (approx. 25% leaf area affected)\n"
        "* **Cause**: Fungal pathogen (Puccinia/Cercospora) favored by high humidity and excess leaf moisture.\n"
        "* **Treatment Recommendation**:\n"
        "  1. Prune and destroy affected leaves to prevent spread.\n"
        "  2. Apply a copper-based fungicide or Neem oil solution.\n"
        "  3. Adjust watering to avoid wetting foliage directly.\n"
        "  4. Ensure spacing between crops to allow air circulation.\n\n"
        "*Disclaimer: This is a simulated analysis. For production crops, verify using a local agriculture extension agent.*";
  }
}