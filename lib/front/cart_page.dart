import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:indiangrill/main.dart';
import 'package:indiangrill/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _tipController = TextEditingController();
 double _tipAmount = 0.0;

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
    final double grandTotal = subTotal + cart.tipAmount; // ✅ uses provider tip

    final double tax = 0.78; // Example for subtitle
    if (_tipController.text.isEmpty && cart.tipAmount > 0) {
  _tipController.text = cart.tipAmount.toStringAsFixed(2);
}

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table headings
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: Text(
                    "ITEMS",
                    style: GoogleFonts.raleway(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Center(
                  child: Text(
                    "PRODUCT",
                    style: GoogleFonts.raleway(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Center(
                  child: Text(
                    "QUANTITY",
                    style: GoogleFonts.raleway(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...cartItems.asMap().entries.map((entry) {
            int idx = entry.key;
            var item = entry.value;
            return Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade100),
                borderRadius: BorderRadius.circular(3),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child:Center(
                    child: Text(
                      (idx + 1).toString().padLeft(2, '0'),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.raleway(
                          fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child:Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(item.title,
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w700, fontSize: 15)),
                        const SizedBox(height: 1),
                        if (item.selectedoptions != null &&
                            item.selectedoptions.isNotEmpty)
                          ...item.selectedoptions.map((opt) {
                            if (opt.isNotEmpty) {
                              final value = opt.values.first;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Text("Choice of: $value",
                                    style: GoogleFonts.raleway(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87)),
                              );
                            } else {
                              return const SizedBox();
                            }
                          }),

                          if (item.specialInstruction != null &&
                              item.specialInstruction!.trim().isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                "Special Notes: ${item.specialInstruction}",
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
                  ),
                  Expanded(
                    flex: 4,
                    child:Center(
                      child:FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline,
                              size: 18, color: Color(0xffE2001A)),
                          onPressed: () => _handleDecrease(context, item.id),
                        ),
                        Text('${item.quantity}',
                            style: GoogleFonts.raleway(
                                fontSize: 15, fontWeight: FontWeight.w600)),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline,
                              size: 18, color: Color(0xffE2001A)),
                          onPressed: () => cart.increaseQuantity(item.id),
                        ),
                      ],
                    ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 12),
          // CONTINUE ORDERING BUTTON
          _RedOutlineButton(
            label: "CONTINUE ORDERING",
            width: MediaQuery.of(context).size.width * 0.6,
            onPressed: () => GoRouter.of(context).pushNamed('order-online'),
          ),
          const SizedBox(height: 12),
          // ADD COUPON BUTTON WITH FIELD
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
          child:Row(
            children: [
              Expanded(
                child: TextField(
                  style: GoogleFonts.raleway(
                      fontSize: 14, color: const Color(0xffE2001A)),
                  decoration: InputDecoration(
                    hintText: "ADD COUPON",
                    hintStyle: GoogleFonts.raleway(
                        fontSize: 14, color: const Color(0xffE2001A)),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    border: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 224, 224, 224), width: 1),
                      borderRadius: BorderRadius.zero,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 201, 201, 201), width: 1),
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 13)),
                    backgroundColor:
                        WidgetStateProperty.all<Color>(Colors.white),
                    foregroundColor:
                        WidgetStateProperty.all<Color>(const Color(0xffE2001A)),
                    side: WidgetStateProperty.all(const BorderSide(
                      color: Color.fromARGB(255, 201, 201, 201),
                    )),
                    elevation: WidgetStateProperty.all(0),
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero)),
                  ),
                  onPressed: () {},
                  child: const Icon(Icons.add, color: Color(0xffE2001A)),
                ),
              ),
            ],
          ),
          ),
          const SizedBox(height: 12),
          // UPDATE ORDER BUTTON
          _RedOutlineButton(
            label: "UPDATE ORDER",
            width: MediaQuery.of(context).size.width * 0.45,
            onPressed: () {}, // Add logic if needed
          ),
          const SizedBox(height: 18),
          // WANT TO ADD A TIP
          Text("Want to add a Tip",
              style: GoogleFonts.raleway(
                  color: const Color(0xffE2001A),
                  fontWeight: FontWeight.w700,
                  fontSize: 14)),
          SizedBox(height: 10,),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
          child:Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _tipController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  style: GoogleFonts.raleway(fontSize: 13, color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "0",
                    hintStyle:
                        GoogleFonts.raleway(fontSize: 13, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 1),
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 8),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                 onPressed: () {
                    final enteredTip = double.tryParse(_tipController.text.trim()) ?? 0.0;
                    cart.setTip(enteredTip); // ✅ updates provider
                    FocusScope.of(context).unfocus(); // optional - closes keyboard
                  },

                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(Colors.white),
                    foregroundColor:
                        WidgetStateProperty.all<Color>(const Color(0xffE2001A)),
                    side: WidgetStateProperty.all(const BorderSide(
                      color: Color(0xffE2001A),
                    )),
                    padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 15)),
                    elevation: WidgetStateProperty.all(0),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    ),
                  ),
                  child: Text("Add",
                      style: GoogleFonts.raleway(
                          fontSize: 14, fontWeight: FontWeight.w500)),
                ),
                
              ),
              if (cart.tipAmount > 0) ...[
  const SizedBox(width: 8),
  SizedBox(
    height: 48,
    child: ElevatedButton(
      onPressed: () {
        cart.setTip(0.0); // ✅ clear tip in provider
        _tipController.clear();
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
        foregroundColor: WidgetStateProperty.all<Color>(Colors.grey.shade700),
        side: WidgetStateProperty.all(const BorderSide(color: Colors.grey)),
        elevation: WidgetStateProperty.all(0),
        padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 15)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      ),
      child: Text("Remove",
          style: GoogleFonts.raleway(
              fontSize: 14, fontWeight: FontWeight.w500)),
    ),
  ),
],

            ],
          ),
          ),
          const SizedBox(height: 16),
          // Subtotal/details rows
          _AmountDetailsRow(label: "Sub Total", value: subTotal, bold: false),
          _AmountDetailsRow(
              label: "Pick Up From Store", value: 0.0, bold: false),
          const SizedBox(height: 5),
          if (cart.tipAmount > 0)
  _AmountDetailsRow(
    label: "Tip",
    value: cart.tipAmount,
    bold: false,
  ),
  const SizedBox(height: 5,),
          _AmountDetailsRow(
              label: "Grand Total",
              value: grandTotal,
              bold: true,
              subtitle: "(includes \$${tax.toStringAsFixed(2)} Tax)"),
          const SizedBox(height: 18),
          // Checkout Button
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: ElevatedButton(
              onPressed: () => GoRouter.of(context).pushNamed('checkout'),
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(const Color(0xffE2001A)),
                foregroundColor: WidgetStateProperty.all(Colors.white),
                shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 16)),
                textStyle: WidgetStateProperty.all(GoogleFonts.raleway(
                    fontSize: 15, fontWeight: FontWeight.w600)),
              ),
              child: const Text("CHECKOUT"),
            ),
          ),
        ],
      ),
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
        }).toList(),
        SizedBox(height: spacing),
        Row(
          children: [
            ElevatedButton(
              onPressed: () => GoRouter.of(context).pushNamed('order-online'),
              child: Text("Continue Shopping",
                  style: GoogleFonts.raleway(fontSize: fontSize)),
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
                        print("Apply Coupon button clicked");
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
      builder: (ctx) => AlertDialog(
        title: const Text("Remove Item?"),
        content: const Text("Do you want to remove this item from cart?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              cart.removeItem(productId);
              Navigator.of(ctx).pop();
            },
            child: const Text("Remove", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  } else {
    cart.decreaseQuantity(productId);
  }
}

class _RedOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double? width; // 👈 Optional width parameter

  const _RedOutlineButton({
    required this.label,
    required this.onPressed,
    this.width, // 👈 Allow width to be nullable
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
  width: width ?? double.infinity,
  height: 46,
  child: OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      side: const BorderSide(
        color: Color(0xffE2001A),
        width: 1.0, // 👈 Equal border thickness on all sides
      ),
      foregroundColor: const Color(0xffE2001A),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // 👈 Sharp corners (no uneven curves)
      ),
      textStyle: GoogleFonts.raleway(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      alignment: Alignment.center,
    ),
    child: Text(
      label,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: GoogleFonts.raleway(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: const Color(0xffE2001A),
      ),
    ),
  ),
);
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
                color: bold ? Colors.grey : const Color.fromARGB(255, 187, 187, 187),
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
                  color: bold ? Colors.grey : Colors.grey,
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
