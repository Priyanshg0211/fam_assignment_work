import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/card_models.dart';

/// Service for fetching contextual cards from the API
class ApiService {
  static const String _baseUrl = 'https://polyjuice.kong.fampay.co/mock/famapp/feed/home_section/?slugs=famx-paypage';

  static Future<ApiResponse> fetchCards() async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return ApiResponse.fromJson(data[0]);
        }
        throw Exception('Empty response');
      } else {
        throw Exception('Failed to load cards: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
