import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:indiangrill/front/footer.dart';
import 'package:indiangrill/front/header.dart';
import 'package:indiangrill/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class MainLayout extends StatefulWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  bool _isCartOpen = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartItems = cart.items.values.toList();

    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const Header(),
                  widget.child,
                  const Footer(),
                ],
              ),
            ),

            // Cart Icon only on mobile
            // Outer cart icon
            if (isMobile && !_isCartOpen)
              Positioned(
                right: 0,
                top: MediaQuery.of(context).size.height * 0.5,
                child: GestureDetector(
                  onTap: () => _openCartModal(context),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE2001A),
                          shape: BoxShape.rectangle,
                        ),
                        child: const Icon(Icons.shopping_cart,
                            color: Colors.white, size: 26),
                      ),
                      Positioned(
                        left: -4,
                        top: -4,
                        child: Consumer<Cart>(
                          builder: (context, cart, child) {
                            return Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${cart.itemCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _openCartModal(BuildContext context) {
    setState(() => _isCartOpen = true); // hide outer cart icon

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Cart",
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.centerRight,
          child: Material(
            color: Colors.transparent,
            child: Consumer<Cart>(
              builder: (context, cart, child) {
                final cartItems = cart.items.values.toList();
                final double subTotal = cartItems
                    .map((item) => item.price * item.quantity)
                    .fold(0.0, (prev, el) => prev + el);

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Cart icon attached to modal
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE2001A),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6),
                            bottomLeft: Radius.circular(6),
                          ),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Icon(Icons.shopping_cart,
                                color: Colors.white, size: 26),
                            Positioned(
                              left: -4,
                              top: -4,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${cart.itemCount}', // always reactive
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Modal body
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.5,
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Container(
                            color: Colors.black87,
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Text(
                                  "${cart.itemCount} product${cart.itemCount > 1 ? 's' : ''} in the cart.",
                                  style: GoogleFonts.raleway(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.close,
                                      color: Colors.white),
                                  onPressed: () => Navigator.pop(context),
                                )
                              ],
                            ),
                          ),

                          // Cart body
                          Expanded(
                            child: cartItems.isEmpty
                                ? Center(
                                    child: Text(
                                      "Your cart is empty!",
                                      style: GoogleFonts.raleway(
                                        fontSize: 16,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: cartItems.length,
                                    itemBuilder: (context, index) {
                                      final item = cartItems[index];
                                      return Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                color: Colors.black12),
                                          ),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        item.title,
                                                        style:
                                                            GoogleFonts.raleway(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            "\$${item.price.toStringAsFixed(2)}",
                                                            style: GoogleFonts
                                                                .raleway(
                                                              fontSize: 13,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 2),
                                                          Text(
                                                            "Qty: ${item.quantity}",
                                                            style: GoogleFonts
                                                                .raleway(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .black54,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 4),
                                                  ...item.selectedoptions
                                                      .map((opt) {
                                                    if (opt.isNotEmpty) {
                                                      final key =
                                                          opt.keys.first;
                                                      final value =
                                                          opt.values.first;
                                                      return Text(
                                                        "$key: $value",
                                                        style:
                                                            GoogleFonts.raleway(
                                                          fontSize: 12,
                                                          color: Colors.black54,
                                                        ),
                                                      );
                                                    } else {
                                                      return const SizedBox();
                                                    }
                                                  }),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.close,
                                                  color: Colors.red, size: 18),
                                              onPressed: () {
                                                cart.removeItem(item.id);
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                          ),

                          // Footer
                          if (cart.itemCount > 0)
                            Container(
                              color: const Color(0xffE2001A),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "SUBTOTAL:",
                                        style: GoogleFonts.raleway(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "\$${subTotal.toStringAsFixed(2)}",
                                            style: GoogleFonts.raleway(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Text(
                                            "(INCL. TAX)",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            GoRouter.of(context)
                                                .pushNamed('cart');
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.zero,
                                            ),
                                          ),
                                          child: const Text("CART"),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            GoRouter.of(context)
                                                .pushNamed('checkout');
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.zero,
                                            ),
                                          ),
                                          child: const Text("CHECKOUT"),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: anim1,
          curve: Curves.easeInOut,
        ));
        return SlideTransition(position: offsetAnimation, child: child);
      },
    ).then((_) {
      setState(() => _isCartOpen = false);
    });
  }
}
