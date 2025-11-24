// lib/screens/checkout_page.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
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

  if (selectedPaymentMethod == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please select a payment method.")),
    );
    return;
  }

  setState(() => _isLoading = true);

  final url =
      Uri.parse('https://dev.indian-grill.com/wp-json/custom/v1/create-order');

  // Ordered items for API
  List<Map<String, dynamic>> items = cart.items.values.map((item) {
    return {
      "product_id": item.id,
      "qty": item.quantity,
    };
  }).toList();

  // Ordered items for success page
  final orderedItemsForSuccess =
      cart.items.values.map((item) {
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
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.raleway(color: Colors.grey, fontSize: fontSize),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 12,
        ),
      ),
      style: GoogleFonts.raleway(fontSize: fontSize),

      /// VALIDATOR handles required field errors
      validator: (value) {
        if (requiredField && (value == null || value.trim().isEmpty)) {
          return "$label is required";
        }
        return null;
      },
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
                            content: Text("Please correct the errors"),
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffe2001a),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
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
                      style: TextStyle(fontSize: 18, color: Colors.white),
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
    onPressed: () => GoRouter.of(context).pushNamed('order-online'),
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.hovered)) {
          return const Color(0xffe2001a); // Hover background
        }
        return Colors.white; // Normal background
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
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
)

    ),
  );
}

  Widget buildTabletLayout(BuildContext context) {
     final cart = Provider.of<Cart>(context, listen: false);

    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child:cart.items.isNotEmpty
    ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Form(
                        key: _formKey, child: _billingAndShippingSection())),
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
                                content: Text("Please correct the errors")),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text("Place Order",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
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
        )  : _emptyCartMessage(),
      ),
    );
  }

  Widget buildMobileLayout(BuildContext context) {
     final cart = Provider.of<Cart>(context, listen: false);

    return SingleChildScrollView(
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
            const SizedBox(height: 20,),
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
                                content: Text("Please correct the errors")),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text("Place Order",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
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
        Text(
          'Additional Information',
          style: GoogleFonts.raleway(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xff666666),
          ),
          textAlign: TextAlign.start,
        ),
        TextField(
          controller: orderNote,
          decoration: InputDecoration(
            labelText: "Special Instructions",
            labelStyle: GoogleFonts.raleway(color: Colors.grey),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
          style: GoogleFonts.raleway(),
          maxLines: 3,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            // You might want to convert this to stateful checkbox later
            Checkbox(value: false, onChanged: (val) {}),
            Text("Disposable Cutleries (optional)",
                style: GoogleFonts.raleway()),
          ],
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
        child: Text(
          'Your Cart is empty!',
          style: GoogleFonts.raleway(
            fontSize: fontSize + 2,
            color: const Color(0xffE2001A),
          ),
        ),
      );
    }

    final double subTotal = cartItems
        .map((item) => item.price * item.quantity)
        .fold(0.0, (prev, e) => prev + e);

    final double tax = 0.0;
    final double shipping = 0.0;
    final double tip = cart.tipAmount;
    final double total = subTotal + tax + shipping + tip;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          'YOUR ORDER',
          style: GoogleFonts.raleway(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xff666666),
          ),
        ),
        const SizedBox(height: 16),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1.4),
            3: FlexColumnWidth(1.5),
          },
          border: const TableBorder(
            horizontalInside: BorderSide(color: Color(0xfff1f1f1), width: 0.5),
          ),
          children: [
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Product',
                      style: GoogleFonts.raleway(fontWeight: FontWeight.bold)),
                ),
                Center(
                    child: Text('Unit',
                        style:
                            GoogleFonts.raleway(fontWeight: FontWeight.bold))),
                Center(
                    child: Text('Price',
                        style:
                            GoogleFonts.raleway(fontWeight: FontWeight.bold))),
                Align(
                    alignment: Alignment.centerRight,
                    child: Text('Total',
                        style:
                            GoogleFonts.raleway(fontWeight: FontWeight.bold))),
              ],
            ),
            for (var item in cartItems)
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.title,
                            style: GoogleFonts.raleway(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w600,
                            )),
                        const SizedBox(height: 4),
                        ...item.selectedoptions.map((opt) {
                          if (opt.isNotEmpty) {
                            final key = opt.keys.first;
                            final value = opt.values.first;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 1.5),
                              child: Text(
                                "$key: $value",
                                style: GoogleFonts.raleway(
                                    fontSize: fontSize - 2,
                                    color: Colors.black54),
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        }),
                      ],
                    ),
                  ),
                  Center(
                      child: Text('${item.quantity}',
                          style: GoogleFonts.raleway())),
                  Center(
                      child: Text('\$${item.price.toStringAsFixed(2)}',
                          style: GoogleFonts.raleway())),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                        '\$${(item.price * item.quantity).toStringAsFixed(2)} (incl. tax)',
                        style: GoogleFonts.raleway()),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: 10),
        _buildSummaryRow('Subtotal', subTotal),
        _buildSummaryRow('Shipping', shipping),
        if (tip > 0) _buildSummaryRow('Tip', tip, color: Colors.green),
        _buildSummaryRow('Tax', tax),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text('Total (payable)',
                      style: GoogleFonts.raleway(
                          color: const Color(0xffE2001A),
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ),
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text('\$${total.toStringAsFixed(2)}',
                      style: GoogleFonts.raleway(
                          color: const Color(0xffE2001A),
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, double value,
      {Color color = const Color(0xff888888)}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(label, style: GoogleFonts.raleway(color: color)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text('\$${value.toStringAsFixed(2)}',
                  style: GoogleFonts.raleway(color: color)),
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
              "Select Payment Method",
              style: GoogleFonts.raleway(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...gateways.map((gw) {
              final id = gw["id"];
              final title = gw["title"];
              final description = gw["description"];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                elevation: 0,
                child: RadioListTile(
                  value: id,
                  groupValue: selectedGateway,
                  onChanged: (value) {
                    setState(() {
                      selectedGateway = value.toString();
                    });

                    widget.onSelected(selectedGateway!); // return selected ID
                  },
                  title: Text(
                    title,
                    style: GoogleFonts.raleway(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    description,
                    style: GoogleFonts.raleway(
                      fontSize: 13,
                      color: Colors.grey[700],
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
