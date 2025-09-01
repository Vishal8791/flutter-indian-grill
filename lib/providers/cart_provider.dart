import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartItem {
  final String id; // productId
  final String title;
  final int quantity;
  final double price;
  final String option;
  final List<Map<String, String>> selectedoptions;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
    required this.option,
    required this.selectedoptions,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'quantity': quantity,
      'price': price,
      'option': option,
      'selectedoptions': selectedoptions,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      title: map['title'],
      quantity: map['quantity'],
      price: map['price'],
      option: map['option'],
      selectedoptions: List<Map<String, String>>.from(
        (map['selectedoptions'] ?? [])
            .map((item) => Map<String, String>.from(item)),
      ),
    );
  }
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(
    String productId,
    String title,
    double price,
    int quantity,
    String option,
    List<Map<String, String>> selectedoptions,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity + quantity,
          price: existingCartItem.price,
          option: existingCartItem.option,
          selectedoptions: existingCartItem.selectedoptions,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: productId,
          title: title,
          quantity: quantity,
          price: price,
          option: option,
          selectedoptions: selectedoptions,
        ),
      );
    }
    _saveCartToPreferences();
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    _saveCartToPreferences();
    notifyListeners();
  }

  void clear() {
    _items = {};
    _saveCartToPreferences();
    notifyListeners();
  }

  void increaseQuantity(String productId) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingItem) => CartItem(
          id: existingItem.id,
          title: existingItem.title,
          quantity: existingItem.quantity + 1,
          price: existingItem.price,
          option: existingItem.option,
          selectedoptions: existingItem.selectedoptions,
        ),
      );
      _saveCartToPreferences();
      notifyListeners();
    }
  }

  void decreaseQuantity(String productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId]!.quantity > 1) {
        _items.update(
          productId,
          (existingItem) => CartItem(
            id: existingItem.id,
            title: existingItem.title,
            quantity: existingItem.quantity - 1,
            price: existingItem.price,
            option: existingItem.option,
            selectedoptions: existingItem.selectedoptions,
          ),
        );
      } else {
        _items.remove(productId);
      }
      _saveCartToPreferences();
      notifyListeners();
    }
  }

  // Save the cart to SharedPreferences
  Future<void> _saveCartToPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> cartList =
        _items.values.map((e) => e.toMap()).toList();
    String cartJson = json.encode(cartList);
    await prefs.setString('cart', cartJson);
  }

  // Load the cart from SharedPreferences
  Future<void> _loadCartFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartJson = prefs.getString('cart');
    if (cartJson != null) {
      List<dynamic> decodedList = json.decode(cartJson);
      _items = {
        for (var item in decodedList)
          item['id']: CartItem.fromMap(item as Map<String, dynamic>)
      };
    }
  }

  // Load the cart when the app starts
  Future<void> loadCart() async {
    await _loadCartFromPreferences();
    notifyListeners();
  }
}
