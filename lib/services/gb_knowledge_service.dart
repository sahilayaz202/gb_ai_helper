import 'dart:convert';
import 'package:flutter/services.dart';

class GBKnowledgeService {
  static List data = [];

  static Future init() async {
    final raw = await rootBundle.loadString('lib/data/gb_offline.json');
    data = jsonDecode(raw);
  }

  static String search(String q) {
    q = q.toLowerCase();

    for (var item in data) {
      for (var k in item["keywords"]) {
        if (q.contains(k)) {
          return item["answer"];
        }
      }
    }

    return "Only GB related info available offline.";
  }
}
