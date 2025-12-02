import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartItem {
  final String id; // productId
  final String title;
  final int quantity;
  final double price;
  final int tip;
  final String option;
  final List<Map<String, String>> selectedoptions;
  final String? specialInstruction; 

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
    required this.tip,
    required this.option,
    required this.selectedoptions,
    this.specialInstruction,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'quantity': quantity,
      'price': price,
      'tip': tip,
      'option': option,
      'selectedoptions': selectedoptions,
      'specialInstruction': specialInstruction,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      title: map['title'],
      quantity: map['quantity'],
      price: map['price'].toDouble(),
      tip: map['tip'] ?? 0,
      option: map['option'],
      selectedoptions: List<Map<String, String>>.from(
        (map['selectedoptions'] ?? [])
            .map((item) => Map<String, String>.from(item)),
      ),
      specialInstruction: map['specialInstruction'],
    );
  }
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  double _tipAmount = 0.0; // ✅ Separate tip field for the cart total

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total + _tipAmount; // ✅ include tip
  }

  double get tipAmount => _tipAmount;

  // ✅ Add or update tip
  void setTip(double tip) {
    _tipAmount = tip;
    _saveCartToPreferences();
    notifyListeners();
  }

  // ✅ Coupon variables
  String? appliedCouponCode;
  double couponDiscount = 0.0;

  // Apply coupon
  void applyCoupon(String code, double discount) {
    appliedCouponCode = code;
    couponDiscount = discount;
    notifyListeners();
  }

  // Remove coupon
  void removeCoupon() {
    appliedCouponCode = null;
    couponDiscount = 0.0;
    notifyListeners();
  }

  // Total after discount
  double get totalAfterDiscount {
    return total - couponDiscount;
  }


  void addItem(
    String productId,
    String title,
    double price,
    int quantity,
    String option,
    List<Map<String, String>> selectedoptions,
    String? specialInstruction,
   
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity + quantity,
          price: existingCartItem.price,
          tip: existingCartItem.tip,
          option: existingCartItem.option,
          selectedoptions: existingCartItem.selectedoptions,
          specialInstruction: specialInstruction ?? existingCartItem.specialInstruction,
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
          tip: 0, // ✅ individual tip (if ever needed)
          option: option,
          selectedoptions: selectedoptions,
          specialInstruction: specialInstruction,
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
    _tipAmount = 0.0; // ✅ reset tip when clearing
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
          tip: existingItem.tip,
          option: existingItem.option,
          selectedoptions: existingItem.selectedoptions,
          specialInstruction: existingItem.specialInstruction,
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
            tip: existingItem.tip,
            option: existingItem.option,
            selectedoptions: existingItem.selectedoptions,
            specialInstruction: existingItem.specialInstruction,
          ),
        );
      } else {
        _items.remove(productId);
      }
      _saveCartToPreferences();
      notifyListeners();
    }
  }

  // ✅ Save cart + tip to SharedPreferences
  Future<void> _saveCartToPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> cartList =
        _items.values.map((e) => e.toMap()).toList();
    String cartJson = json.encode(cartList);
    await prefs.setString('cart', cartJson);
    await prefs.setDouble('tipAmount', _tipAmount); // ✅ save tip separately
     if (appliedCouponCode != null) {
    await prefs.setString('appliedCouponCode', appliedCouponCode!);
    await prefs.setDouble('couponDiscount', couponDiscount);
  } else {
    await prefs.remove('appliedCouponCode');
    await prefs.remove('couponDiscount');
  }
  }

  // ✅ Load cart + tip from SharedPreferences
  Future<void> _loadCartFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartJson = prefs.getString('cart');
    _tipAmount = prefs.getDouble('tipAmount') ?? 0.0; // ✅ load tip

    if (cartJson != null) {
      List<dynamic> decodedList = json.decode(cartJson);
      _items = {
        for (var item in decodedList)
          item['id']: CartItem.fromMap(item as Map<String, dynamic>)
      };
    }
    appliedCouponCode = prefs.getString('appliedCouponCode');
  couponDiscount = prefs.getDouble('couponDiscount') ?? 0.0;
  }

  // Load the cart when the app starts
  Future<void> loadCart() async {
    await _loadCartFromPreferences();
    notifyListeners();
  }
  // Subtotal (without tip)
double get subtotal {
  double sum = 0.0;
  _items.forEach((key, cartItem) {
    sum += cartItem.price * cartItem.quantity;
  });
  return sum;
}

// You can change tax logic if needed
double get tax {
  return subtotal * 0.00; // No tax? Change here
}

// Shipping (optional)
double get shipping {
  return 0.0; // Add delivery charges if required
}

// Total (subtotal + tip)
double get total {
  return subtotal + _tipAmount;
}

}

