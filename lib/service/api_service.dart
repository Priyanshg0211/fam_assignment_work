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
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return ApiResponse.fromJson(data[0]);
        }
        throw Exception('Empty response from server');
      } else if (response.statusCode == 404) {
        throw Exception('API endpoint not found');
      } else if (response.statusCode >= 500) {
        throw Exception('Server error: ${response.statusCode}');
      } else {
        throw Exception('Failed to load cards: ${response.statusCode}');
      }
    } on FormatException {
      throw Exception('Invalid response format from server');
    } catch (e) {
      if (e.toString().contains('timeout')) {
        throw Exception('Request timeout - please check your connection');
      }
      throw Exception('Network error: $e');
    }
  }
}
