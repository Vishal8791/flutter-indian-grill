import 'dart:convert';
import 'package:http/http.dart' as http;
// Assuming the Product class is defined here

class WooCommerceService {
  final String baseUrl = 'https://www.indian-grill.com/wp-json/wc/v1/products';
  final String consumerKey = 'ck_67efc00d8d814b67877da8fffad40d61d4366602';
  final String consumerSecret = 'cs_4cd4f797f1aef69089a3ce3f008d6726e98f352b';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/wp-json/wc/v3/products?consumer_key=$consumerKey&consumer_secret=$consumerSecret'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Product> products = [];

      for (var item in data) {
        Product product = Product.fromJson(item);

        // Fetch product options from custom endpoint
        final optionResponse = await http.get(
          Uri.parse(
              '$baseUrl/wp-json/custom-api/v1/product-options/${product.id}'),
        );

        if (optionResponse.statusCode == 200) {
          final optionData = json.decode(optionResponse.body);
          product.productOptions = optionData;
        }

        products.add(product);
      }

      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Fetch custom fields for products
  Future<List<String>> fetchCustomFields() async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/wp-json/wc/v1/products/custom-fields/names?consumer_key=$consumerKey&consumer_secret=$consumerSecret'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return List<String>.from(data); // List of custom field names
    } else {
      throw Exception('Failed to load custom fields');
    }
  }
}

class Product {
  final int id;
  final String name;
  final String price;
  final String description;
  final List<Category> categories;
  final List<Attribute> attributes;
  final List<Variation> variations;
  Map<String, dynamic>?
      productOptions; // ✅ Not final so it can be set after fromJson

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.categories,
    required this.attributes,
    required this.variations,
    this.productOptions,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    var categoriesJson = json['categories'] as List?;
    var attributesJson = json['attributes'] as List?;
    var variationsJson = json['variations'] as List?;

    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      description: json['description'],
      categories: categoriesJson != null
          ? List<Category>.from(categoriesJson.map((x) => Category.fromJson(x)))
          : [],
      attributes: attributesJson != null
          ? List<Attribute>.from(
              attributesJson.map((x) => Attribute.fromJson(x)))
          : [],
      variations: variationsJson != null
          ? List<Variation>.from(
              variationsJson.map((x) => Variation.fromJson(x)))
          : [],
      productOptions: null, // Will be set later in fetchProducts
    );
  }
}

class Category {
  final int id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Attribute {
  final String name;
  final List<String> options;

  Attribute({
    required this.name,
    required this.options,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) {
    var optionsJson = json['options'] as List?;
    return Attribute(
      name: json['name'],
      options: optionsJson != null ? List<String>.from(optionsJson) : [],
    );
  }
}

class Variation {
  final int id;
  final String price;
  final String sku;
  final List<Attribute> attributes;

  Variation({
    required this.id,
    required this.price,
    required this.sku,
    required this.attributes,
  });

  factory Variation.fromJson(Map<String, dynamic> json) {
    var attributesJson = json['attributes'] as List?;
    return Variation(
      id: json['id'],
      price: json['price'],
      sku: json['sku'],
      attributes: attributesJson != null
          ? List<Attribute>.from(
              attributesJson.map((x) => Attribute.fromJson(x)))
          : [],
    );
  }
}
