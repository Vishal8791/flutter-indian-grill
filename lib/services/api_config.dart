class ApiConfig {
  static const String baseUrl = 'https://dev.indian-grill.com';
  static const String consumerKey =
      'ck_67efc00d8d814b67877da8fffad40d61d4366602';
  static const String consumerSecret =
      'cs_4cd4f797f1aef69089a3ce3f008d6726e98f352b';

  static String get wpApiBase => '$baseUrl/wp-json';
  static String get wcApiBase => '$baseUrl/wp-json/wc/v1';
  static String get customApiBase => '$baseUrl/wp-json/custom/v1';

  // Specific endpoints
  static String get registerUser => '$customApiBase/register-user';
  static String get loginUser => '$customApiBase/login';
  static String get validateCoupon => '$customApiBase/validate-coupon';
  static String get fetchOrders => '$customApiBase/orders';
}
