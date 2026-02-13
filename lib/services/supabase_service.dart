import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final db = Supabase.instance.client;

  static Future<List> searchFAQ(String q) async {
    return await db
        .from('gb_faq')
        .select()
        .ilike('question', '%$q%');
  }
}
