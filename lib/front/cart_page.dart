import 'dart:convert';

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

  void _applyTip() {
    setState(() {
      _tipAmount = double.tryParse(_tipController.text.trim()) ?? 0.0;
    });
  }

  void _removeTip() {
    setState(() {
      _tipAmount = 0.0;
      _tipController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartItems = cart.items.values.toList();
    final double subTotal = cart.items.values
        .map((item) => item.price * item.quantity)
        .fold(0.0, (prev, element) => prev + element);
    final double grandTotal = subTotal + _tipAmount;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(190, 20, 190, 20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: Color(0xffe5e5e5), thickness: 1),
          const Row(
            children: [
              Expanded(child: Text("ITEMS", textAlign: TextAlign.center)),
              Expanded(child: Text("PRODUCTS", textAlign: TextAlign.center)),
              Expanded(child: Text("QUANTITY", textAlign: TextAlign.center)),
              Expanded(child: Text("PRICE", textAlign: TextAlign.center)),
              Expanded(child: Text("TOTAL", textAlign: TextAlign.center)),
              Expanded(child: Text("ACTION", textAlign: TextAlign.center)),
            ],
          ),
          const Divider(color: Color(0xffe5e5e5), thickness: 1),
          cart.itemCount > 0
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: cartItems.asMap().entries.map((entry) {
                    int index = entry.key;
                    var item = entry.value;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${index + 1}',
                              textAlign: TextAlign.center,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                ...item.selectedoptions.map((opt) {
                                  if (opt.isNotEmpty) {
                                    final key = opt.keys.first;
                                    final value = opt.values.first;
                                    return Text(
                                      "$key : $value",
                                      style: const TextStyle(
                                          fontSize: 13, color: Colors.black54),
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                }),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline,
                                      size: 20),
                                  onPressed: () {
                                    _handleDecrease(context, item.id);
                                  },
                                ),
                                Text('${item.quantity}'),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline,
                                      size: 20),
                                  onPressed: () {
                                    cart.increaseQuantity(item.id);
                                  },
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '\$${item.price.toStringAsFixed(2)}',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '\$${(item.price * item.quantity).toStringAsFixed(2)} (incl. tax)',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                cart.removeItem(item.id);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                )
              : Container(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Your Cart is empty!',
                        style: GoogleFonts.raleway(
                            fontSize: 16, color: const Color(0xffE2001A)),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                          onPressed: () {
                            GoRouter.of(context).pushNamed('order-online');
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.hovered)) {
                                  return const Color(0xffE2001A);
                                }
                                return Colors.transparent;
                              },
                            ),
                            foregroundColor:
                                WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.hovered)) {
                                  return Colors.white;
                                }
                                return const Color(0xffE2001A);
                              },
                            ),
                            elevation: WidgetStateProperty.all<double>(0),
                            side: WidgetStateProperty.all<BorderSide>(
                              const BorderSide(
                                  color: Color(0xffE2001A), width: 0.5),
                            ),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                          ),
                          child: Text(
                            'Return to Shop',
                            style: GoogleFonts.raleway(
                              fontSize: 14,
                            ),
                          ))
                    ],
                  )),
          cart.itemCount > 0
              ? Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            GoRouter.of(context).pushNamed('order-online');
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.hovered)) {
                                  return const Color(0xffE2001A);
                                }
                                return Colors.transparent;
                              },
                            ),
                            foregroundColor:
                                WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.hovered)) {
                                  return Colors.white;
                                }
                                return const Color(0xffE2001A);
                              },
                            ),
                            elevation: WidgetStateProperty.all<double>(0),
                            side: WidgetStateProperty.all<BorderSide>(
                              const BorderSide(
                                  color: Color(0xffE2001A), width: 0.5),
                            ),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 6),
                            child: Text(
                              "Continue Shopping",
                              style: GoogleFonts.raleway(fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 42,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  style: GoogleFonts.raleway(
                                    // <-- Text style applied here
                                    fontSize: 14,
                                    color: const Color(0xffE2001A),
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "ADD COUPON",
                                    hintStyle: GoogleFonts.raleway(
                                        fontSize: 14,
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
                                icon: const Icon(Icons.add,
                                    color: Color(0xffE2001A)),
                                onPressed: () {
                                  print("Apply Coupon button clicked");
                                },
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 150),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Want to add a Tip',
                              style: GoogleFonts.raleway(
                                fontSize: 14,
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
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    style: GoogleFonts.raleway(
                                      // <-- Text style applied here
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "0",
                                      hintStyle: GoogleFonts.raleway(
                                          fontSize: 12, color: Colors.black),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 0),
                                      enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.zero,
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 196, 196, 196),
                                            width: 0.4),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.zero,
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 196, 196, 196),
                                            width: 0.4),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                SizedBox(
                                  width: 75,
                                  child: ElevatedButton(
                                    onPressed: _applyTip,
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty
                                          .resolveWith<Color>(
                                        (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.hovered)) {
                                            return const Color(0xffE2001A);
                                          }
                                          return Colors.transparent;
                                        },
                                      ),
                                      foregroundColor: WidgetStateProperty
                                          .resolveWith<Color>(
                                        (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.hovered)) {
                                            return Colors.white;
                                          }
                                          return const Color(0xffE2001A);
                                        },
                                      ),
                                      elevation:
                                          WidgetStateProperty.all<double>(0),
                                      side: WidgetStateProperty.all<BorderSide>(
                                        const BorderSide(
                                            color: Color(0xffE2001A),
                                            width: 0.5),
                                      ),
                                      shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                        const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero,
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 0),
                                      child: Text(
                                        "Add",
                                        style:
                                            GoogleFonts.raleway(fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ),
                                if (_tipAmount > 0) ...[
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  SizedBox(
                                    width: 120,
                                    child: ElevatedButton(
                                      onPressed: _removeTip,
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStateProperty
                                            .resolveWith<Color>(
                                          (Set<WidgetState> states) {
                                            if (states.contains(
                                                WidgetState.hovered)) {
                                              return const Color(0xffE2001A);
                                            }
                                            return Colors.transparent;
                                          },
                                        ),
                                        foregroundColor: WidgetStateProperty
                                            .resolveWith<Color>(
                                          (Set<WidgetState> states) {
                                            if (states.contains(
                                                WidgetState.hovered)) {
                                              return Colors.white;
                                            }
                                            return const Color(0xffE2001A);
                                          },
                                        ),
                                        elevation:
                                            WidgetStateProperty.all<double>(0),
                                        side:
                                            WidgetStateProperty.all<BorderSide>(
                                          const BorderSide(
                                              color: Color(0xffE2001A),
                                              width: 0.5),
                                        ),
                                        shape: WidgetStateProperty.all<
                                            RoundedRectangleBorder>(
                                          const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.zero,
                                          ),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 0),
                                        child: Text(
                                          "Remove",
                                          style:
                                              GoogleFonts.raleway(fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildAmountRow("Sub Total:", subTotal),
                            _buildAmountRow("Tip:", _tipAmount),
                            const Divider(),
                            _buildAmountRow("Grand Total:", grandTotal,
                                isTotal: true),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: 120,
                              child: ElevatedButton(
                                onPressed: () {
                                  GoRouter.of(context).pushNamed('checkout');
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                      if (states
                                          .contains(WidgetState.hovered)) {
                                        return const Color.fromARGB(
                                            255, 138, 0, 16);
                                      }
                                      return const Color(0xffe2001a);
                                    },
                                  ),
                                  foregroundColor:
                                      WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                      return Colors.white;
                                    },
                                  ),
                                  elevation: WidgetStateProperty.all<double>(0),
                                  side: WidgetStateProperty.all<BorderSide>(
                                    const BorderSide(
                                        color: Color(0xffE2001A), width: 0.5),
                                  ),
                                  shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                    const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 0),
                                  child: Text(
                                    "Checkout",
                                    style: GoogleFonts.raleway(fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : const Text(''),
        ],
      ),
    );
  }

  Widget _buildAmountRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.raleway(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
            color: isTotal ? Colors.black : Colors.black87,
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: GoogleFonts.raleway(
            fontSize: isTotal ? 16 : 14,
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
