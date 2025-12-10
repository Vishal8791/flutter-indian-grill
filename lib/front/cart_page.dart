// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:indiangrill/providers/cart_provider.dart';
import 'package:indiangrill/services/woocommerce_service.dart';
import 'package:indiangrill/style/style.dart' show AppColors;
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indiangrill/front/header_back_button.dart';
class CartScreen extends StatefulWidget {
  static const routeName = '/cart';
  
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _tipController = TextEditingController();
  double _tipAmount = 0.0;
  String? appliedCouponCode;
  double couponDiscount = 0.0;
  bool isApplyingCoupon = false;
  String? _couponError;


  @override
  void initState() {
    super.initState();
    final cart = Provider.of<Cart>(context, listen: false);
    _tipAmount = cart.tipAmount; // ✅ load existing tip from provider
    _tipController.text =
        _tipAmount > 0 ? _tipAmount.toStringAsFixed(2) : ''; // show it in UI
  }

  void _applyTip() {
    final cart = Provider.of<Cart>(context, listen: false);
    setState(() {
      _tipAmount = double.tryParse(_tipController.text.trim()) ?? 0.0;
    });
    cart.setTip(_tipAmount); // ✅ Save to SharedPreferences
  }
  void removeCoupon() {
  final code = Provider.of<Cart>(context, listen: false).appliedCouponCode;
  Provider.of<Cart>(context, listen: false).removeCoupon();
  setState(() {
    _couponError = null;
  });
   showCouponDialog(
    context: context,
    title: "Coupon Removed",
    message: "Coupon '${code ?? ''}' has been removed.",
    success: false,
  );
}

 Future<void> applyCoupon(String code) async {
  if (code.isEmpty) return;

  setState(() {
  
    _couponError = null;
  });

  try {
    final response = await WooCommerceService().validateCoupon(code);

    if (response["valid"] == true) {
      final discount = double.tryParse("${response['amount']}") ?? 0.0;

      Provider.of<Cart>(context, listen: false).applyCoupon(code, discount);

      setState(() {
        _couponError = null;
       
      });
      showCouponDialog(
        context: context,
        title: "Coupon Applied!",
        message: "Coupon '$code' applied successfully!\nDiscount: \$${discount.toStringAsFixed(2)}",
        success: true,
      );
    } else {
      setState(() {
        _couponError = response["message"] ?? "Invalid coupon";
        
      });
      showCouponDialog(
        context: context,
        title: "Invalid Coupon",
        message: _couponError!,
        success: false,
      );
    }
  } catch (e) {
    setState(() {
      _couponError = "Something went wrong";
     
    });
     showCouponDialog(
      context: context,
      title: "Error",
      message: _couponError!,
      success: false,
    );
  }
}


  void _removeTip() {
    final cart = Provider.of<Cart>(context, listen: false);
    setState(() {
      _tipAmount = 0.0;
      _tipController.clear();
    });
    cart.setTip(0.0); // ✅ Clear persisted tip too
  }

  
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(190, 20, 190, 20),
      color: Colors.white,
      child: _buildCartContent(context,
          fontSize: 14, spacing: 20, isMobile: false),
    );
  }

  Widget buildTabletLayout(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(80, 20, 80, 20),
      color: Colors.white,
      child: _buildCartContent(context,
          fontSize: 13, spacing: 15, isMobile: false),
    );
  }

 Widget buildMobileLayout(BuildContext context) {
  final cart = Provider.of<Cart>(context);
  final cartItems = cart.items.values.toList();
  final double subTotal = cart.items.values
      .map((item) => item.price * item.quantity)
      .fold(0.0, (prev, element) => prev + element);
  // final double grandTotal = subTotal + cart.tipAmount;
  final double grandTotal = cart.totalAfterDiscount; 

 // final double tax = 0.0;

  if (_tipController.text.isEmpty && cart.tipAmount > 0) {
    _tipController.text = cart.tipAmount.toStringAsFixed(2);
  }

 if (cartItems.isEmpty) {
  return Column(
    children: [
      // ---------------- Header ----------------
     const HeaderBackButton(title: 'Cart'),
      // ---------------- Empty Cart Content ----------------
      Expanded(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: 70,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 20),
              Text(
                "Your cart is empty",
                style: GoogleFonts.raleway(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Add delicious items to continue",
                style: GoogleFonts.raleway(
                  fontSize: 14,
                  color: Colors.black45,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => GoRouter.of(context).pushNamed('order-online'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffE2001A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "START ORDERING",
                  style: GoogleFonts.raleway(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}


  // --------------- MAIN LAYOUT ----------------
  return Column(
    children: [
      // 1️⃣ Product List — Scrollable
      Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    child: Row(
      children: [
        // ----------------- Back Button -----------------
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(8), // inner padding
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12), // rounded background
            ),
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              size: 20,
              color: Colors.black87,
            ),
          ),
        ),

        // ----------------- Spacer to push title center -----------------
        const Spacer(),

        // ----------------- Title -----------------
        Text(
          'Cart',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),

        const Spacer(), // so the text stays centered

        // Optional: right icon placeholder to balance row
        const SizedBox(width: 40), // same width as back button
      ],
    ),
  ),
        
      
      Expanded(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          children: cartItems.map((item) => buildCartItemCard(item)).toList(),
        ),
      ),

      // 2️⃣ Bottom Container — Fixed
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Color(0xffEEEEEE),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Voucher Input
         VoucherInputField(
  appliedCode: Provider.of<Cart>(context).appliedCouponCode,
  onApply: applyCoupon,
  onRemove: removeCoupon,
),


          if (_couponError != null)
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 4),
              child: Text(
                _couponError!,
                style: const TextStyle(fontSize: 11, color: Colors.red),
              ),
            ),
        


            const SizedBox(height: 10),

            // Tip Input
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xffF7F7F9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.attach_money,
                        size: 12, color: Colors.black87),
                  ),
                  const SizedBox(width: 10),
                 Expanded(
  child: TextField(
    controller: _tipController,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    decoration: InputDecoration(
      border: InputBorder.none,
      hintText: "Enter Tip Amount",
      hintStyle: GoogleFonts.raleway(
        fontSize: 14,
        color: Colors.grey.shade500,
      ),
    ),
  ),
),

// ---------------- IF NO TIP → SHOW ADD BUTTON ----------------
if (cart.tipAmount == 0) 
  GestureDetector(
    onTap: () {
      final tip = double.tryParse(_tipController.text.trim()) ?? 0.0;
      if (tip > 0) {
        cart.setTip(tip);
        FocusScope.of(context).unfocus();
      }
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xffE2001A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        "Add",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    ),
  ),

// ---------------- IF TIP ADDED → SHOW REMOVE BUTTON ----------------
if (cart.tipAmount > 0)
  GestureDetector(
    onTap: () {
      cart.setTip(0.0);
      _tipController.clear();
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade500,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        "Remove",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    ),
  ),
  ],
              ),
            ),

            const SizedBox(height: 16),

            _AmountDetailsRow(
                label: "Sub Total", value: subTotal, bold: false),
            _AmountDetailsRow(
                label: "Pick Up From Store", value: 0.0, bold: false),
            if (cart.tipAmount > 0)
              _AmountDetailsRow(label: "Tip", value: cart.tipAmount, bold: false),
            if (cart.couponDiscount > 0)
                _AmountDetailsRow(
                  label: "Coupon (${cart.appliedCouponCode})",
                  value: -cart.couponDiscount, // negative to show discount
                  bold: false, // optional: show in green
                ),
            const Divider(color: Colors.grey),

            _AmountDetailsRow(
                label: "Grand Total",
                value: grandTotal,
                bold: true,
                subtitle: null),

            const SizedBox(height: 12),

            // Checkout Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${grandTotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: ElevatedButton(
                      onPressed: () =>
                          GoRouter.of(context).pushNamed('checkout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.fromLTRB(0, 4, 4, 4),
                      ),
                      child: Text(
                        "CHECKOUT",
                        style: GoogleFonts.raleway(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

 Widget buildCartItemCard(CartItem item) {
  final cart = Provider.of<Cart>(context);
  // final double subTotal = cart.items.values
  //     .map((item) => item.price * item.quantity)
  //     .fold(0.0, (prev, element) => prev + element);
  print(item.selectedoptions);
  if (_tipController.text.isEmpty && cart.tipAmount > 0) {
    _tipController.text = cart.tipAmount.toStringAsFixed(2);
  }

  return Container(
    margin: const EdgeInsets.only(bottom: 14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha((0.04 * 255).round()),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // IMAGE
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
          child: Image.asset(
            'assets/images/uploads/dummy_image.webp',
            width: 90,
            height: 90,
            fit: BoxFit.cover,
          ),
        ),

        const SizedBox(width: 12),

        // TITLE + SUBTITLE + PRICE + QUANTITY
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              Text(
                item.title,
                style: GoogleFonts.raleway(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              
      if (item.selectedoptions.isNotEmpty) ...[
  const SizedBox(height: 4),
  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: item.selectedoptions.map((opt) {
      // Extract key and value from the map
      String label = opt.keys.first.toString();
      String value = opt.values.first?.toString() ?? "";

      print("Label: $label   Value: $value");

      return Text(
        "$label $value",
        style: GoogleFonts.raleway(
          fontSize: 13,
          color: Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
      );
    }).toList(),
  ),
],



// --- Show Special Instruction (if exists) ---
if (item.specialInstruction != null && item.specialInstruction!.isNotEmpty) ...[
  const SizedBox(height: 6),
  Text(
    "Note: ${item.specialInstruction!}",
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    style: GoogleFonts.raleway(
      fontSize: 13,
      color: Colors.black54,
      fontStyle: FontStyle.italic,
    ),
  ),
],
              // const SizedBox(height: 2),
              // // Subtitle
              // Text(
              //   "By Indian Grill",
              //   style: GoogleFonts.raleway(
              //     fontSize: 12,
              //     color: Colors.grey,
              //   ),
              // ),
              const SizedBox(height: 8),
              // PRICE + QUANTITY STEP IN SAME ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Price
                  Text(
                    "\$${item.price.toStringAsFixed(2)}",
                    style: GoogleFonts.raleway(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  
                  // Quantity Stepper
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 236, 236, 236),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => _handleDecrease(context, item.id),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(
                              Icons.remove,
                              size: 10,
                              color: Color(0xffFF6A00),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${item.quantity}',
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => cart.increaseQuantity(item.id),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xffe2001a),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),
      ],
    ),
  );
}

  Widget _buildCartContent(BuildContext context,
      {required double fontSize, double spacing = 20, bool isMobile = false}) {
    final cart = Provider.of<Cart>(context);
    final cartItems = cart.items.values.toList();
    final double subTotal = cart.items.values
        .map((item) => item.price * item.quantity)
        .fold(0.0, (prev, element) => prev + element);
    final double grandTotal = subTotal + _tipAmount;

    if (cart.itemCount == 0) {
      return Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Cart is empty!',
              style: GoogleFonts.raleway(
                fontSize: fontSize + 2,
                color: const Color(0xffE2001A),
              ),
            ),
            SizedBox(height: spacing),
            ElevatedButton(
              onPressed: () {
                GoRouter.of(context).pushNamed('order-online');
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.hovered)) {
                      return const Color(0xffE2001A);
                    }
                    return Colors.transparent;
                  },
                ),
                foregroundColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.hovered)) {
                      return Colors.white;
                    }
                    return const Color(0xffE2001A);
                  },
                ),
                elevation: WidgetStateProperty.all<double>(0),
                side: WidgetStateProperty.all<BorderSide>(
                  const BorderSide(color: Color(0xffE2001A), width: 0.5),
                ),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                ),
              ),
              child: Text(
                'Return to Shop',
                style: GoogleFonts.raleway(fontSize: fontSize),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: const Color(0xffe5e5e5), thickness: 1),
        if (!isMobile) ...[
          Row(
            children: [
              Expanded(
                  child: Text("ITEMS",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.raleway(fontSize: fontSize))),
              Expanded(
                  child: Text("PRODUCTS",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.raleway(fontSize: fontSize))),
              Expanded(
                  child: Text("QUANTITY",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.raleway(fontSize: fontSize))),
              Expanded(
                  child: Text("PRICE",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.raleway(fontSize: fontSize))),
              Expanded(
                  child: Text("TOTAL",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.raleway(fontSize: fontSize))),
              Expanded(
                  child: Text("ACTION",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.raleway(fontSize: fontSize))),
            ],
          ),
          Divider(color: const Color(0xffe5e5e5), thickness: 1),
        ],
        ...cartItems.asMap().entries.map((entry) {
          int index = entry.key;
          var item = entry.value;

          if (isMobile) {
            // Mobile view: stacked item cards
            return Card(
              margin: EdgeInsets.symmetric(vertical: spacing / 2),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${index + 1}. ${item.title}',
                        style: GoogleFonts.raleway(
                            fontWeight: FontWeight.w800, fontSize: fontSize)),
                    const SizedBox(height: 6),
                    ...item.selectedoptions.map((opt) {
                      if (opt.isNotEmpty) {
                        final key = opt.keys.first;
                        final value = opt.values.first;
                        return Text("$key : $value",
                            style: TextStyle(
                                fontSize: fontSize - 1, color: Colors.black54));
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline,
                                  size: 20),
                              onPressed: () =>
                                  _handleDecrease(context, item.id),
                            ),
                            Text('${item.quantity}',
                                style: TextStyle(fontSize: fontSize)),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline,
                                  size: 20),
                              onPressed: () => cart.increaseQuantity(item.id),
                            ),
                          ],
                        ),
                        Text('\$${item.price.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: fontSize)),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              '\$${(item.price * item.quantity).toStringAsFixed(2)} (incl. tax)',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSize)),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => cart.removeItem(item.id),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            // Desktop/tablet: row view
            return Padding(
              padding: EdgeInsets.symmetric(vertical: spacing / 2),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${index + 1}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          item.title,
                          style: GoogleFonts.raleway(
                            fontWeight: FontWeight.w800,
                            fontSize: fontSize,
                          ),
                        ),
                        const SizedBox(height: 4),
                        ...item.selectedoptions.map((opt) {
                          if (opt.isNotEmpty) {
                            final key = opt.keys.first;
                            final value = opt.values.first;
                            return Text(
                              "$key : $value",
                              style: TextStyle(
                                  fontSize: fontSize - 1,
                                  color: Colors.black54),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        }),
                        if (item.specialInstruction != null &&
                            item.specialInstruction!.trim().isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              "Special Instructions: ${item.specialInstruction}",
                              style: GoogleFonts.raleway(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.remove_circle_outline, size: 20),
                          onPressed: () => _handleDecrease(context, item.id),
                        ),
                        Text('${item.quantity}',
                            style: TextStyle(fontSize: fontSize)),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, size: 20),
                          onPressed: () => cart.increaseQuantity(item.id),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Text('\$${item.price.toStringAsFixed(2)}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: fontSize)),
                  ),
                  Expanded(
                    child: Text(
                        '\$${(item.price * item.quantity).toStringAsFixed(2)} (incl. tax)',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: fontSize)),
                  ),
                  Expanded(
                    child: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => cart.removeItem(item.id),
                    ),
                  ),
                ],
              ),
            );
          }
        }),
        SizedBox(height: spacing),
        Row(
          children: [
            ElevatedButton(
              onPressed: () => GoRouter.of(context).pushNamed('order-online'),
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.hovered)) {
                    return const Color(0xffE2001A);
                  }
                  return Colors.transparent;
                }),
                foregroundColor:
                    WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.hovered)) {
                    return Colors.white;
                  }
                  return const Color(0xffE2001A);
                }),
                elevation: WidgetStateProperty.all(0),
                side: WidgetStateProperty.all(
                    const BorderSide(color: Color(0xffE2001A), width: 0.5)),
                shape: WidgetStateProperty.all(const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero)),
              ),
              child: Text("Continue Shopping",
                  style: GoogleFonts.raleway(fontSize: fontSize)),
            ),
            SizedBox(width: spacing),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 32,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: GoogleFonts.raleway(
                          fontSize: fontSize,
                          color: const Color(0xffE2001A),
                        ),
                        decoration: InputDecoration(
                          hintText: "ADD COUPON",
                          hintStyle: GoogleFonts.raleway(
                              fontSize: fontSize,
                              color: const Color(0xffE2001A)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 0),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(
                                color: Color(0xffE2001A), width: 0.4),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(
                                color: Color(0xffE2001A), width: 0.4),
                          ),
                        ),
                      ),
                    ),
                    const VerticalDivider(
                      color: Colors.grey,
                      width: 1,
                      thickness: 0.5,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Color(0xffE2001A)),
                      onPressed: () {
                       
                      },
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
            if (!isMobile) SizedBox(width: 150),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Want to add a Tip',
                    style: GoogleFonts.raleway(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xffE2001A),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 32,
                        width: 150,
                        child: TextField(
                          controller: _tipController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          style: GoogleFonts.raleway(
                            fontSize: fontSize - 2,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: "0",
                            hintStyle: GoogleFonts.raleway(
                                fontSize: fontSize - 2, color: Colors.black),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 0),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 196, 196, 196),
                                  width: 0.4),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 196, 196, 196),
                                  width: 0.4),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: spacing / 2),
                      SizedBox(
                        width: 75,
                        child: ElevatedButton(
                          onPressed: _applyTip,
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.resolveWith<Color>(
                                    (states) {
                              if (states.contains(WidgetState.hovered)) {
                                return const Color(0xffE2001A);
                              }
                              return Colors.transparent;
                            }),
                            foregroundColor:
                                WidgetStateProperty.resolveWith<Color>(
                                    (states) {
                              if (states.contains(WidgetState.hovered)) {
                                return Colors.white;
                              }
                              return const Color(0xffE2001A);
                            }),
                            elevation: WidgetStateProperty.all<double>(0),
                            side: WidgetStateProperty.all<BorderSide>(
                                const BorderSide(
                                    color: Color(0xffE2001A), width: 0.5)),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                                    const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 0),
                            child: Text("Add",
                                style: GoogleFonts.raleway(fontSize: fontSize)),
                          ),
                        ),
                      ),
                      if (_tipAmount > 0) ...[
                        SizedBox(width: spacing / 2),
                        SizedBox(
                          width: 120,
                          child: ElevatedButton(
                            onPressed: _removeTip,
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.resolveWith<Color>(
                                      (states) {
                                if (states.contains(WidgetState.hovered)) {
                                  return const Color(0xffE2001A);
                                }
                                return Colors.transparent;
                              }),
                              foregroundColor:
                                  WidgetStateProperty.resolveWith<Color>(
                                      (states) {
                                if (states.contains(WidgetState.hovered)) {
                                  return Colors.white;
                                }
                                return const Color(0xffE2001A);
                              }),
                              elevation: WidgetStateProperty.all<double>(0),
                              side: WidgetStateProperty.all<BorderSide>(
                                  const BorderSide(
                                      color: Color(0xffE2001A), width: 0.5)),
                              shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 0),
                              child: Text("Remove",
                                  style:
                                      GoogleFonts.raleway(fontSize: fontSize)),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: spacing),
                  _buildAmountRow("Sub Total:", subTotal, fontSize: fontSize),
                  _buildAmountRow("Tip:", _tipAmount, fontSize: fontSize),
                  const Divider(),
                  _buildAmountRow("Grand Total:", grandTotal,
                      isTotal: true, fontSize: fontSize),
                  SizedBox(height: spacing),
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () =>
                          GoRouter.of(context).pushNamed('checkout'),
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.resolveWith<Color>((states) {
                          if (states.contains(WidgetState.hovered)) {
                            return const Color.fromARGB(255, 138, 0, 16);
                          }
                          return const Color(0xffe2001a);
                        }),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                        elevation: WidgetStateProperty.all(0),
                        side: WidgetStateProperty.all(const BorderSide(
                            color: Color(0xffE2001A), width: 0.5)),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text("Checkout",
                            style: GoogleFonts.raleway(fontSize: fontSize)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAmountRow(String label, double amount,
      {bool isTotal = false, required double fontSize}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.raleway(
            fontSize: isTotal ? fontSize + 2 : fontSize,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
            color: isTotal ? Colors.black : Colors.black87,
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: GoogleFonts.raleway(
            fontSize: isTotal ? fontSize + 2 : fontSize,
            fontWeight: FontWeight.bold,
            color: isTotal ? const Color(0xffE2001A) : Colors.black,
          ),
        ),
      ],
    );
  }
}

void _handleDecrease(BuildContext context, String productId) {
  final cart = Provider.of<Cart>(context, listen: false);
  final currentQuantity = cart.items[productId]?.quantity ?? 0;

  if (currentQuantity <= 1) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.delete_outline,
                size: 40,
                color: Colors.red.shade400,
              ),
              const SizedBox(height: 12),
              Text(
                "Remove Item?",
                style: GoogleFonts.raleway(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Do you want to remove this item from your cart?",
                style: GoogleFonts.raleway(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.grey.shade400),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.raleway(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        cart.removeItem(productId);
                        Navigator.of(ctx).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        "Remove",
                        style: GoogleFonts.raleway(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  } else {
    cart.decreaseQuantity(productId);
  }
}

// Key-Value row for order details
class _AmountDetailsRow extends StatelessWidget {
  final String label;
  final double value;
  final bool bold;
  final String? subtitle;
  const _AmountDetailsRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.subtitle,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.raleway(
                fontSize: bold ? 16 : 14,
                fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${value.toStringAsFixed(2)}',
                style: GoogleFonts.raleway(
                  fontSize: bold ? 16 : 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              if (bold && subtitle != null)
                Text(
                  subtitle!,
                  style:
                      GoogleFonts.raleway(fontSize: 11, color: Colors.black54),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class VoucherInputField extends StatefulWidget {
  final Future<void> Function(String code) onApply; // <-- make it async-friendly
  final VoidCallback? onRemove;
  final String? appliedCode;

  const VoucherInputField({
    super.key,
    required this.onApply,
    this.onRemove,
    this.appliedCode,
  });

  @override
  State<VoucherInputField> createState() => _VoucherInputFieldState();
}

class _VoucherInputFieldState extends State<VoucherInputField> {
  late TextEditingController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.appliedCode ?? '');
  }

  @override
  void didUpdateWidget(covariant VoucherInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.appliedCode != widget.appliedCode) {
      _controller.text = widget.appliedCode ?? '';
    }
  }

  Future<void> _applyCoupon() async {
    final code = _controller.text.trim();
    if (code.isEmpty || _isLoading) return;

    setState(() => _isLoading = true);

    await widget.onApply(code);

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCouponApplied =
        widget.appliedCode != null && widget.appliedCode!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xffF7F7F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.confirmation_number, size: 12),
          ),
          const SizedBox(width: 10),

          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration( hintText: "Enter your voucher code", hintStyle: GoogleFonts.raleway( fontSize: 14, color: Colors.grey.shade500, ), border: InputBorder.none, ), style: GoogleFonts.raleway( fontSize: 12, color: Colors.black87, ),
            ),
          ),

          // ------- BUTTON -------
          isCouponApplied
              ? GestureDetector(
                  onTap: widget.onRemove,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xffE2001A),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      "Remove",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: _applyCoupon,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xffE2001A),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Apply",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
        ],
      ),
    );
  }
}



void showCouponDialog({
  required BuildContext context,
  required String title,
  required String message,
  required bool success, // true for applied, false for error/removed
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: success ? Colors.green.shade50 : Colors.red.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: success ? Colors.green : Colors.red, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              success ? Icons.check_circle_outline : Icons.error_outline,
              color: success ? Colors.green : Colors.red,
              size: 50,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.raleway(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: success ? Colors.green.shade800 : Colors.red.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: success ? Colors.green : Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text(
                "OK",
                style: GoogleFonts.raleway(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
