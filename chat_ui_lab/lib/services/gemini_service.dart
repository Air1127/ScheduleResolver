import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';
class GeminiService {
  static const String apiKey = 'AIzaSyCbFqSo3JPKpc_K53XdkiKOlliHUdCOWfM';  // ← Replace with your actual API key!
  static const String apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';
// ￿ CONVERT MESSAGES TO GEMINI FORMAT
  static List<Map<String, dynamic>> _formatMessages(
      List<ChatMessage> messages,
      ) {
    return messages.map((msg) {
      return {
        'role': msg.role, // "user" or "model"
        'parts': [{'text': msg.text}],
      };
    }).toList();
  }
// ￿ MULTI-TURN API CALL (WITH HISTORY)
  static Future<String> sendMultiTurnMessage(
      List<ChatMessage> conversationHistory,
      String newUserMessage,
      ) async {
    try {
      final formattedMessages = _formatMessages(conversationHistory);
      final response = await http.post(
        Uri.parse('$apiUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': formattedMessages, // ￿ Entire history!
          'generationConfig': {
            'temperature': 0.7,
            'topK': 1,
            'topP': 1,
            'maxOutputTokens': 2048,
          }
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        return 'Error: ${response.statusCode}';
      }
    } catch (e) {
      return 'Network Error: $e';
    }
  }
}