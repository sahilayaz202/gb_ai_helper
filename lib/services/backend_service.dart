import 'package:supabase_flutter/supabase_flutter.dart';

class BackendService {
  static final db = Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> getKnowledge() async {
    final res = await db.from('gb_knowledge').select();
    return List<Map<String, dynamic>>.from(res);
  }

  static Future<void> submitReport(
      String title, String description, String location) async {
    await db.from('gb_reports').insert({
      'title': title,
      'description': description,
      'location': location,
    });
  }
}
