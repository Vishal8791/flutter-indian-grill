// lib/screens/checkout_page.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:indiangrill/front/header_back_button.dart';
import 'package:indiangrill/services/woocommerce_service.dart';
import 'package:provider/provider.dart';
import 'package:indiangrill/providers/cart_provider.dart'; // adjust path if needed

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  // Billing Controllers
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController address1 = TextEditingController();
  final TextEditingController address2 = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController stateCtrl = TextEditingController();
  final TextEditingController postcode = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();

  // Order note
  final TextEditingController orderNote = TextEditingController();
  String? selectedPaymentMethod;
  String? selectedShippingMethodId;
  String? selectedShippingTitle;
  String? selectedShippingCost;

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose controllers
    firstName.dispose();
    lastName.dispose();
    address1.dispose();
    address2.dispose();
    city.dispose();
    stateCtrl.dispose();
    postcode.dispose();
    phone.dispose();
    email.dispose();
    orderNote.dispose();
    super.dispose();
  }

  // Future<void> createOrder(BuildContext context) async {
  //   final cart = Provider.of<Cart>(context, listen: false);

  //   if (cart.items.isEmpty) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(const SnackBar(content: Text("Your cart is empty.")));
  //     return;
  //   }

  //   // Basic validation (ensure required fields are present)
  //   if (firstName.text.trim().isEmpty ||
  //       lastName.text.trim().isEmpty ||
  //       address1.text.trim().isEmpty ||
  //       city.text.trim().isEmpty ||
  //       postcode.text.trim().isEmpty ||
  //       email.text.trim().isEmpty ||
  //       phone.text.trim().isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //           content: Text("Please fill all required billing fields.")),
  //     );
  //     return;
  //   }

  //   if (selectedPaymentMethod == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Please select a payment method.")),
  //     );
  //     return;
  //   }
  //   setState(() => _isLoading = true);

  //   final url = Uri.parse(
  //       'https://dev.indian-grill.com/wp-json/custom/v1/create-order');

  //   // Prepare items for API — assumes each cart item has `id`, `quantity`
  //   List<Map<String, dynamic>> items = cart.items.values.map((item) {
  //     return {
  //       "product_id": item.id,
  //       "qty": item.quantity,
  //     };
  //   }).toList();

  //   final billing = {
  //     "first_name": firstName.text.trim(),
  //     "last_name": lastName.text.trim(),
  //     "address_1": address1.text.trim(),
  //     "address_2": address2.text.trim(),
  //     "city": city.text.trim(),
  //     "state": stateCtrl.text.trim(),
  //     "postcode": postcode.text.trim(),
  //     "country": "US", // change if needed or make dynamic
  //     "email": email.text.trim(),
  //     "phone": phone.text.trim(),
  //   };

  //   final shipping = {
  //     "first_name": firstName.text.trim(),
  //     "last_name": lastName.text.trim(),
  //     "address_1": address1.text.trim(),
  //     "address_2": address2.text.trim(),
  //     "city": city.text.trim(),
  //     "state": stateCtrl.text.trim(),
  //     "postcode": postcode.text.trim(),
  //     "country": "US",
  //   };

  //   final body = {
  //     "user_id":
  //         0, // 0 for guest checkout — change if you pass logged-in user id
  //     "items": items,
  //     "billing": billing,
  //     "shipping": shipping,
  //     "note": orderNote.text.trim(),
  //     "payment_method": selectedPaymentMethod,
  //   };

  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Accept": "application/json",
  //       },
  //       body: jsonEncode(body),
  //     );

  //     debugPrint('Order API status: ${response.statusCode}');
  //     debugPrint('Order API body: ${response.body}');

  //     if (response.statusCode == 200) {
  //       final jsonRes = jsonDecode(response.body);
  //       final orderId = jsonRes['order_id'] ?? jsonRes['data']?['order_id'];

  //       final orderedItems = cart.items.values.map((item) {
  //       return {
  //         "name": item.name,
  //         "qty": item.quantity,
  //         "total": item.total.toStringAsFixed(2),
  //       };
  //     }).toList();

  //     final totals = {
  //       "subtotal": cart.subtotal.toStringAsFixed(2),
  //       "tax": cart.tax.toStringAsFixed(2),
  //       "shipping": cart.shipping.toStringAsFixed(2),
  //       "total": cart.total.toStringAsFixed(2),
  //     };

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Order Created Successfully! ID: $orderId")),
  //       );

  //       // Clear cart — make sure your Cart provider exposes clearCart()
  //       // If your provider uses a different method (e.g., clear()), change this line.
  //       try {
  //         cart.clear();
  //       } catch (e) {
  //         // If clearCart() doesn't exist, try clear()
  //         try {
  //           cart.clear();
  //         } catch (e2) {
  //           debugPrint('Could not clear cart: $e / $e2');
  //         }
  //       }

  //       // Optionally navigate to order confirmation page
  //       // Navigator.of(context).pushNamed('/order-confirmation', arguments: orderId);
  //     } else {
  //       String message = 'Order failed';
  //       try {
  //         final jsonRes = jsonDecode(response.body);
  //         if (jsonRes is Map && jsonRes['message'] != null) {
  //           message = jsonRes['message'];
  //         } else {
  //           message = response.body;
  //         }
  //       } catch (_) {
  //         message = response.body;
  //       }

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Order Failed: $message")),
  //       );
  //     }
  //   } catch (e) {
  //       debugPrint('Order error: $e');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("An error occurred: $e")),
  //       );
  //   } finally {
  //     if (mounted) setState(() => _isLoading = false);
  //   }

  // }

  Future<void> createOrder(BuildContext context) async {
    final cart = Provider.of<Cart>(context, listen: false);

    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Your cart is empty.")),
      );
      return;
    }

    // Basic validation (ensure required fields are present)
    if (firstName.text.trim().isEmpty ||
        lastName.text.trim().isEmpty ||
        address1.text.trim().isEmpty ||
        city.text.trim().isEmpty ||
        postcode.text.trim().isEmpty ||
        email.text.trim().isEmpty ||
        phone.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please fill all required billing fields.")),
      );
      return;
    }

     if (selectedShippingMethodId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a shipping method.")),
      );
      return;
    }

    if (selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a payment method.")),
      );
      return;
    }

    setState(() => _isLoading = true);

    final url = Uri.parse(
        'https://dev.indian-grill.com/wp-json/custom/v1/create-order');

    // Ordered items for API
    List<Map<String, dynamic>> items = cart.items.values.map((item) {
      return {
        "product_id": item.id,
        "qty": item.quantity,
      };
    }).toList();

    // Ordered items for success page
    final orderedItemsForSuccess = cart.items.values.map((item) {
      return {
        "name": item.title,
        "qty": item.quantity,
        "price": item.price.toStringAsFixed(2),
        "total": (item.price * item.quantity).toStringAsFixed(2),
        "selectedOptions": item.selectedoptions,
        "instruction": item.specialInstruction ?? "",
      };
    }).toList();

    // Billing
    final billing = {
      "first_name": firstName.text.trim(),
      "last_name": lastName.text.trim(),
      "address_1": address1.text.trim(),
      "address_2": address2.text.trim(),
      "city": city.text.trim(),
      "state": stateCtrl.text.trim(),
      "postcode": postcode.text.trim(),
      "country": "US",
      "email": email.text.trim(),
      "phone": phone.text.trim(),
    };

    // Shipping
    final shipping = {
      "first_name": firstName.text.trim(),
      "last_name": lastName.text.trim(),
      "address_1": address1.text.trim(),
      "address_2": address2.text.trim(),
      "city": city.text.trim(),
      "state": stateCtrl.text.trim(),
      "postcode": postcode.text.trim(),
      "country": "US",
    };

    // Totals for success page
    final totals = {
      "subtotal": cart.subtotal.toStringAsFixed(2),
      "tax": cart.tax.toStringAsFixed(2),
      "shipping": cart.shipping.toStringAsFixed(2),
      "tip": cart.tipAmount.toStringAsFixed(2),
      "total": cart.total.toStringAsFixed(2),
    };

    // API request body
    final body = {
      "user_id": 0,
      "items": items,
      "billing": billing,
      "shipping": shipping,
      "note": orderNote.text.trim(),
      "payment_method": selectedPaymentMethod,
      "shipping_method_id": selectedShippingMethodId,
      "shipping_method_title": selectedShippingTitle,
      "shipping_cost": selectedShippingCost,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(body),
      );

      debugPrint('Order API status: ${response.statusCode}');
      debugPrint('Order API body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonRes = jsonDecode(response.body);
        final orderId = jsonRes['order_id'] ?? jsonRes['data']?['order_id'];

        // Navigate to order success page
        GoRouter.of(context).pushNamed(
          "order-success",
          extra: {
            "orderId": orderId.toString(),
            "items": orderedItemsForSuccess,
            "paymentMethod": selectedPaymentMethod!,
            "shippingMethod":selectedShippingTitle,
            "totals": totals,
          },
        );

        // Now clear the cart AFTER navigation
        Future.delayed(const Duration(milliseconds: 300), () {
          cart.clear();
        });
      } else {
        String message = 'Order failed';
        try {
          final jsonRes = jsonDecode(response.body);
          if (jsonRes is Map && jsonRes['message'] != null) {
            message = jsonRes['message'];
          } else {
            message = response.body;
          }
        } catch (_) {
          message = response.body;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Order Failed: $message")),
        );
      }
    } catch (e) {
      debugPrint('Order error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Helper builder for text fields
  Widget _buildTextField(
    String label, {
    double fontSize = 14,
    required TextEditingController controller,
    TextInputType? keyboardType,
    bool requiredField = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.raleway(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),

        // TEXTFIELD DESIGN
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 14,
            ),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            hintText: "Enter $label",
            hintStyle: GoogleFonts.raleway(
              fontSize: fontSize,
              color: Colors.grey.shade500,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xffe2001a), width: 1.4),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            errorStyle: const TextStyle(
              color: Colors.red,
              fontSize: 12,
              height: 1.2,
            ),
          ),
          style: GoogleFonts.raleway(fontSize: fontSize),
          validator: (value) {
            if (requiredField && (value == null || value.trim().isEmpty)) {
              return "$label is required";
            }
            return null;
          },
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  // --- Layout builders ---
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;

        if (kIsWeb) {
          if (screenWidth > 1024) {
            return buildDesktopLayout(context);
          } else if (screenWidth > 600) {
            return buildTabletLayout(context);
          } else {
            return buildMobileLayout(context);
          }
        } else {
          if (screenWidth > 1024) {
            return buildDesktopLayout(context);
          } else if (screenWidth > 600) {
            return buildTabletLayout(context);
          } else {
            return buildMobileLayout(context);
          }
        }
      },
    );
  }

  Widget buildDesktopLayout(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 40),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: cart.items.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Form(
                              key: _formKey,
                              child: _billingAndShippingSection(),
                            ),
                          ),
                          const SizedBox(width: 50),
                          Expanded(flex: 1, child: _additionalInfoSection()),
                        ],
                      ),
                      const SizedBox(height: 36),
                      CartSummarySection(),
                      const SizedBox(height: 20),
                      PaymentGatewaysWidget(
                        onSelected: (gatewayId) {
                          print("Selected Payment Method: $gatewayId");
                          selectedPaymentMethod = gatewayId;
                        },
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    createOrder(context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("Please correct the errors"),
                                      ),
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffe2001a),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 16),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Place Order",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                        ),
                      ),
                      const SizedBox(height: 36),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sorry, it seems that there are no available payment methods for your state. Please contact us if you require assistance or wish to make alternate arrangements.',
                            style: GoogleFonts.raleway(
                              fontSize: 14,
                              color: const Color(0xff666666),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'The Store is Closed. Purchases are allowed from 11:00 AM to 22:00 PM. We deliver through DoorDash, Uber Eats and Grubhub.',
                            style: GoogleFonts.raleway(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xffE2001A),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : _emptyCartMessage(),
          ),
        ),
      ),
    );
  }

  Widget _emptyCartMessage() {
    return Center(
      child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              Text(
                "Your cart is empty.",
                style: GoogleFonts.raleway(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: Color(0xffe2001a),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                child: ElevatedButton(
                  onPressed: () =>
                      GoRouter.of(context).pushNamed('order-online'),
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.resolveWith<Color>((states) {
                      if (states.contains(WidgetState.hovered)) {
                        return const Color(0xffe2001a); // Hover background
                      }
                      return Colors.white; // Normal background
                    }),
                    foregroundColor:
                        WidgetStateProperty.resolveWith<Color>((states) {
                      if (states.contains(WidgetState.hovered)) {
                        return Colors.white; // Hover text
                      }
                      return const Color(0xffe2001a); // Normal text
                    }),
                    side: WidgetStateProperty.all(
                      const BorderSide(color: Color(0xffe2001a), width: 1),
                    ),
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    elevation: WidgetStateProperty.all(0),
                  ),
                  child: Text(
                    "CONTINUE ORDERING",
                    style: GoogleFonts.raleway(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }

  Widget buildTabletLayout(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);

    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: cart.items.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Form(
                              key: _formKey,
                              child: _billingAndShippingSection())),
                      const SizedBox(width: 20),
                      Expanded(child: _additionalInfoSection()),
                    ],
                  ),
                  const SizedBox(height: 36),
                  CartSummarySection(),
                  const SizedBox(height: 20),
                  PaymentGatewaysWidget(
                    onSelected: (gatewayId) {
                      print("Selected Payment Method: $gatewayId");
                      selectedPaymentMethod = gatewayId;
                    },
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                // All fields valid → continue
                                createOrder(context);
                              } else {
                                // Validation failed → show inline errors
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Please correct the errors")),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : const Text("Place Order",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sorry, it seems that there are no available payment methods for your state. Please contact us if you require assistance or wish to make alternate arrangements.',
                        style: GoogleFonts.raleway(
                            fontSize: 14, color: const Color(0xff666666)),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'The Store is Closed. Purchases are allowed from 11:00 AM to 22:00 PM. We deliver through DoorDash, Uber Eats and Grubhub.',
                        style: GoogleFonts.raleway(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xffE2001A),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : _emptyCartMessage(),
      ),
    );
  }

 Widget buildMobileLayout(BuildContext context) {
  final cart = Provider.of<Cart>(context, listen: false);

  return Column(
    children: [
      // ---------------- Back Button Header ----------------
      const HeaderBackButton(title: 'Checkout'),
      // ---------------- Scrollable Checkout Content ----------------
      Expanded(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: cart.items.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Form(key: _formKey, child: _billingAndShippingSection()),
                      const SizedBox(height: 20),
                      _additionalInfoSection(),
                      const SizedBox(height: 36),
                      CartSummarySection(),
                      const SizedBox(height: 20),
                      ShippingMethodsWidget(
                        onSelected: (methodId, title, cost) {
                          selectedShippingMethodId = methodId;
                          selectedShippingTitle = title;
                          selectedShippingCost = cost;
                        },
                      ),
                      const SizedBox(height: 20),
                      PaymentGatewaysWidget(
                        onSelected: (gatewayId) {
                          selectedPaymentMethod = gatewayId;
                        },
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    createOrder(context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Please correct the errors"),
                                      ),
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 16),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Place Order",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sorry, it seems that there are no available payment methods for your state. Please contact us if you require assistance or wish to make alternate arrangements.',
                            style: GoogleFonts.raleway(
                                fontSize: 14, color: const Color(0xff666666)),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'The Store is Closed. Purchases are allowed from 11:00 AM to 22:00 PM. We deliver through DoorDash, Uber Eats and Grubhub.',
                            style: GoogleFonts.raleway(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xffE2001A),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : _emptyCartMessage(),
          ),
        ),
      ),
    ],
  );
}
 // --- Billing & Shipping Section widget (uses controllers) ---
  Widget _billingAndShippingSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 4),
          child: Text(
            'BILLING & SHIPPING',
            style: GoogleFonts.raleway(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xff666666),
            ),
            textAlign: TextAlign.start,
          ),
        ),
        const Divider(color: Color(0xfff1f1f1), thickness: 0.5),
        isMobile
            ? Column(
                children: [
                  _buildTextField("First Name", controller: firstName),
                  const SizedBox(height: 10),
                  _buildTextField("Last Name", controller: lastName),
                ],
              )
            : Row(
                children: [
                  Expanded(
                      child:
                          _buildTextField("First Name", controller: firstName)),
                  const SizedBox(width: 20),
                  Expanded(
                      child:
                          _buildTextField("Last Name", controller: lastName)),
                ],
              ),
        const SizedBox(height: 10),
        isMobile
            ? Column(
                children: [
                  _buildTextField("House number and street name",
                      controller: address1),
                  const SizedBox(height: 10),
                  _buildTextField("Apartment, suite, unit etc. (optional)",
                      controller: address2, fontSize: 12),
                ],
              )
            : Row(
                children: [
                  Expanded(
                      child: _buildTextField("House number and street name",
                          controller: address1)),
                  const SizedBox(width: 20),
                  Expanded(
                      child: _buildTextField(
                          "Apartment, suite, unit etc. (optional)",
                          controller: address2,
                          fontSize: 12)),
                ],
              ),
        const SizedBox(height: 10),
        isMobile
            ? Column(
                children: [
                  _buildTextField("Town / City", controller: city),
                  const SizedBox(height: 10),
                  _buildTextField("State", controller: stateCtrl, fontSize: 12),
                ],
              )
            : Row(
                children: [
                  Expanded(
                      child: _buildTextField("Town / City", controller: city)),
                  const SizedBox(width: 20),
                  Expanded(
                      child: _buildTextField("State",
                          controller: stateCtrl, fontSize: 12)),
                ],
              ),
        const SizedBox(height: 10),
        isMobile
            ? Column(
                children: [
                  _buildTextField("ZIP", controller: postcode),
                  const SizedBox(height: 10),
                  _buildTextField("Phone",
                      controller: phone,
                      fontSize: 12,
                      keyboardType: TextInputType.phone),
                ],
              )
            : Row(
                children: [
                  Expanded(child: _buildTextField("ZIP", controller: postcode)),
                  const SizedBox(width: 20),
                  Expanded(
                      child: _buildTextField("Phone",
                          controller: phone,
                          fontSize: 12,
                          keyboardType: TextInputType.phone)),
                ],
              ),
        const SizedBox(height: 10),
        _buildTextField("Email address",
            controller: email, keyboardType: TextInputType.emailAddress),
      ],
    );
  }

  // --- Additional Info ---
  Widget _additionalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SECTION TITLE
        Text(
          'Additional Information',
          style: GoogleFonts.raleway(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 14),

        // SPECIAL INSTRUCTIONS TEXTAREA
        Text(
          "Special Instructions",
          style: GoogleFonts.raleway(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),

        TextField(
          controller: orderNote,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "E.g., No onions, extra spicy, ring the doorbell…",
            hintStyle: GoogleFonts.raleway(color: Colors.grey.shade500),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            contentPadding: const EdgeInsets.all(14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xffe2001a), width: 1.4),
            ),
          ),
          style: GoogleFonts.raleway(),
        ),

        const SizedBox(height: 18),

        // CUTLERY OPTION
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Transform.scale(
                scale: 1.2,
                child: Checkbox(
                  value: false,
                  onChanged: (val) {},
                  activeColor: const Color(0xffe2001a),
                  side: BorderSide(color: Colors.grey.shade400),
                ),
              ),
              Expanded(
                child: Text(
                  "Add disposable cutleries (optional)",
                  style: GoogleFonts.raleway(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}

// --- CartSummarySection widget (keeps your original logic) ---
class CartSummarySection extends StatelessWidget {
  final double fontSize;

  const CartSummarySection({this.fontSize = 16, super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartItems = cart.items.values.toList();

    if (cartItems.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            'Your Cart is empty!',
            style: GoogleFonts.raleway(
              fontSize: fontSize + 2,
              color: Color(0xffE2001A),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    final double subTotal = cartItems.fold(
      0.0,
      (sum, item) => sum + item.price * item.quantity,
    );

    final double tip = cart.tipAmount;
    final double couponDiscount = cart.couponDiscount;
    final double tax = 0.0;
    final double shipping = 0.0;
    final double total = subTotal + tax + shipping + tip - couponDiscount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        Text(
          "Your Order",
          style: GoogleFonts.raleway(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 12),

        // ------------------ PRODUCT LIST ------------------
        ...cartItems.map((item) => _buildProductTile(item)),

        const SizedBox(height: 20),

        // ------------------ SUMMARY CARD ------------------
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            children: [
              _summaryRow("Subtotal", subTotal),
              _summaryRow("Shipping", shipping),
              if (tip > 0) _summaryRow("Tip", tip, color: Colors.green),
              _summaryRow("Tax", tax),
              if (couponDiscount > 0)
                _summaryRow(
                  "Coupon (${cart.appliedCouponCode})",
                  -couponDiscount, // negative to show discount
                  color: Colors.green,
                ),
              const Divider(height: 22),
              _summaryRow("Total Payable", total,
                  isTotal: true, color: Color(0xffE2001A)),
            ],
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  // ======================= PRODUCT TILE =========================

  Widget _buildProductTile(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/uploads/dummy_image.jpg',
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          // TEXT DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.raleway(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (item.selectedoptions.isNotEmpty)
                  ...item.selectedoptions.map(
                    (opt) => Text(
                      "${opt.keys.first}: ${opt.values.first}",
                      style: GoogleFonts.raleway(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  "\$${(item.price * item.quantity).toStringAsFixed(2)}",
                  style: GoogleFonts.raleway(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xffE2001A),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // QUANTITY
          Text(
            "x${item.quantity}",
            style: GoogleFonts.raleway(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ======================= SUMMARY ROW =========================

  Widget _summaryRow(String label, double value,
      {Color color = const Color(0xff222222), bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.raleway(
                fontSize: isTotal ? 16 : 14,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
                color: color,
              ),
            ),
          ),
          Text(
            "\$${value.toStringAsFixed(2)}",
            style: GoogleFonts.raleway(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentGatewaysWidget extends StatefulWidget {
  final Function(String) onSelected; // return selected gateway ID

  const PaymentGatewaysWidget({super.key, required this.onSelected});

  @override
  State<PaymentGatewaysWidget> createState() => _PaymentGatewaysWidgetState();
}

class _PaymentGatewaysWidgetState extends State<PaymentGatewaysWidget> {
  late Future<List<dynamic>> _gatewaysFuture;
  String? selectedGateway;

  @override
  void initState() {
    super.initState();
    _gatewaysFuture = fetchCustomGateways();
  }

  Future<List<dynamic>> fetchCustomGateways() async {
    final url =
        "https://dev.indian-grill.com/wp-json/custom-api/v1/payment-gateways";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch payment gateways");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _gatewaysFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text(
            "Error: ${snapshot.error}",
            style: GoogleFonts.raleway(color: Colors.red),
          );
        }

        final gateways =
            snapshot.data!.where((g) => g["enabled"] == "yes").toList();

        if (gateways.isEmpty) {
          return Text(
            "No available payment methods.",
            style: GoogleFonts.raleway(fontSize: 15),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Payment Method",
              style: GoogleFonts.raleway(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Choose how you want to pay",
              style: GoogleFonts.raleway(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 14),
            ...gateways.map((gw) {
              final id = gw["id"];
              final title = gw["title"];
              final description = gw["description"];

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    setState(() {
                      selectedGateway = id;
                    });
                    widget.onSelected(selectedGateway!);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: selectedGateway == id
                            ? const Color(0xffE2001A)
                            : Colors.grey.shade300,
                        width: selectedGateway == id ? 1.6 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selectedGateway == id
                                  ? const Color(0xffE2001A)
                                  : Colors.grey,
                              width: 2,
                            ),
                          ),
                          child: selectedGateway == id
                              ? Center(
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: const BoxDecoration(
                                      color: Color(0xffE2001A),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 14),

                        /// TEXT
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: GoogleFonts.raleway(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if ((description ?? "").isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    description,
                                    style: GoogleFonts.raleway(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

class ShippingMethodsWidget extends StatefulWidget {
  final Function(String methodId, String title, String cost) onSelected;

  const ShippingMethodsWidget({super.key, required this.onSelected});

  @override
  State<ShippingMethodsWidget> createState() => _ShippingMethodsWidgetState();
}

class _ShippingMethodsWidgetState extends State<ShippingMethodsWidget> {
  late Future<List<dynamic>> _shippingFuture;
  String? selectedShipping;

  @override
  void initState() {
    super.initState();
    _shippingFuture = fetchCustomShipping();
  }

  Future<List<dynamic>> fetchCustomShipping() async {
    final url =
        "https://dev.indian-grill.com/wp-json/flutter-api/shipping-methods";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is Map && data["methods"] is List) {
        return data["methods"];
      } else {
        throw Exception("Invalid API format: 'methods' not found");
      }
    } else {
      throw Exception("Failed to fetch shipping methods");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _shippingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text(
            "Error: ${snapshot.error}",
            style: GoogleFonts.raleway(color: Colors.red),
          );
        }

        final methods =
            snapshot.data!.where((m) => m["enabled"] == "yes").toList();

        if (methods.isEmpty) {
          return Text(
            "No available shipping methods.",
            style: GoogleFonts.raleway(fontSize: 15),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Shipping Method",
              style: GoogleFonts.raleway(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Choose how your order will be delivered",
              style: GoogleFonts.raleway(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 14),

            ...methods.map((method) {
              final id = method["instance_id"].toString();
              final title = method["title"] ?? "Shipping";
              final cost = method["cost"] ?? "0";

              final costLabel =
                  cost == "0" ? "Free" : "\$${double.parse(cost).toStringAsFixed(2)}";

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    setState(() {
                      selectedShipping = id;
                    });
                    widget.onSelected(id, title, cost);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: selectedShipping == id
                            ? const Color(0xffE2001A)
                            : Colors.grey.shade300,
                        width: selectedShipping == id ? 1.6 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        // Selection Circle
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selectedShipping == id
                                  ? const Color(0xffE2001A)
                                  : Colors.grey,
                              width: 2,
                            ),
                          ),
                          child: selectedShipping == id
                              ? Center(
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: const BoxDecoration(
                                      color: Color(0xffE2001A),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 14),

                        // Title & Cost
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: GoogleFonts.raleway(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Cost: $costLabel",
                                style: GoogleFonts.raleway(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
