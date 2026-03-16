import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:indiangrill/services/api_config.dart';

class WooCommerceCategory {
  final String baseUrl = ApiConfig.baseUrl;
  final String consumerKey = ApiConfig.consumerKey;
  final String consumerSecret = ApiConfig.consumerSecret;
  final String categoryId = '73';

  Future<List<dynamic>> fetchSubcategories() async {
    final String url =
        "${ApiConfig.wcApiBase}/products/categories?parent=$categoryId&consumer_key=$consumerKey&consumer_secret=$consumerSecret";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Decode the JSON response
        List<dynamic> data = json.decode(response.body);
        return data; // Returns list of subcategories
      } else {
        throw Exception(
            'Failed to load subcategories with status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching subcategories: $error');
    }
  }
}
