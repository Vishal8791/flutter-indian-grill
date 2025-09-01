import 'dart:convert';
import 'package:http/http.dart' as http;

class WooCommerceCategory {
  final String baseUrl = "https://www.indian-grill.com";
  final String consumerKey = "ck_67efc00d8d814b67877da8fffad40d61d4366602";
  final String consumerSecret = "cs_4cd4f797f1aef69089a3ce3f008d6726e98f352b";
  final String categoryId = '73';

  Future<List<dynamic>> fetchSubcategories() async {
    final String url =
        "$baseUrl/wp-json/wc/v3/products/categories?parent=$categoryId&consumer_key=$consumerKey&consumer_secret=$consumerSecret";

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
