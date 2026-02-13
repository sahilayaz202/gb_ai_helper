import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const url = "https://<your-supabase-project>.functions.supabase.co/ai-proxy";

  static Future<String> ask(String q) async {
    try {
      final res = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"q": q}),
      );

      final data = jsonDecode(res.body);
      return data["answer"];
    } catch (e) {
      return "Sorry, I couldn't fetch the answer. Try again later.";
    }
  }
}
