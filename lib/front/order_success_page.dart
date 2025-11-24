import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderSuccessPage extends StatelessWidget {
  final String orderId;
  final List<dynamic> items;
  final String paymentMethod;
  final Map<String, dynamic> totals;

  const OrderSuccessPage({
    super.key,
    required this.orderId,
    required this.items,
    required this.paymentMethod,
    required this.totals,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              /// SUCCESS ICON + HEADER
              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Icon(Icons.check_circle_rounded,
                        size: 100, color: Colors.green.shade600),
                    const SizedBox(height: 20),

                    Text(
                      "Order Received!",
                      style: GoogleFonts.raleway(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xffe2001a),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      "Thank you for your purchase.\nYour order #$orderId is confirmed.",
                      style: GoogleFonts.raleway(
                        fontSize: 17,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "A confirmation email has been sent.",
                      style: GoogleFonts.raleway(
                        fontSize: 15,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              /// ORDER SUMMARY CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle("Ordered Items"),

                    const SizedBox(height: 15),

                    Column(
                      children: items.map((item) => _orderItemCard(item)).toList(),
                    ),

                    const SizedBox(height: 30),

                    _sectionTitle("Order Summary"),

                    const SizedBox(height: 15),
                    _totalRow("Subtotal", totals["subtotal"]),
                    _totalRow("Tax", totals["tax"]),
                    _totalRow("Tip", totals["tip"]),
                    _totalRow("Shipping", totals["shipping"]),
                    const Divider(height: 30),
                    _totalRow("Total", totals["total"], bold: true, large: true),

                    const SizedBox(height: 30),

                    _sectionTitle("Payment Method"),
                    const SizedBox(height: 8),

                    Text(
                      paymentMethod,
                      style: GoogleFonts.raleway(fontSize: 16),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              /// BUTTON
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffe2001a),
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    "Continue Shopping",
                    style: GoogleFonts.raleway(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// SECTION TITLE -------------------------------------------------------------------
  Widget _sectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.raleway(
        fontSize: 18,
        color: const Color(0xffe2001a),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// ITEM CARD -----------------------------------------------------------------------
  Widget _orderItemCard(dynamic item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item["name"],
              style: GoogleFonts.raleway(fontSize: 16),
            ),
          ),
          Text(
            "x${item["qty"]}",
            style: GoogleFonts.raleway(fontSize: 14, color: Colors.grey[700]),
          ),
          const SizedBox(width: 16),
          Text(
            "\$${item["total"]}",
            style: GoogleFonts.raleway(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// TOTAL ROW -----------------------------------------------------------------------
  Widget _totalRow(String label, dynamic value,
      {bool bold = false, bool large = false}) {
    final formatted = value == null
        ? "0.00"
        : double.tryParse(value.toString())?.toStringAsFixed(2) ??
            value.toString();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.raleway(
                fontSize: large ? 20 : 16,
                fontWeight: bold ? FontWeight.bold : FontWeight.w400,
              )),
          Text("\$$formatted",
              style: GoogleFonts.raleway(
                fontSize: large ? 20 : 16,
                fontWeight: bold ? FontWeight.bold : FontWeight.w500,
              )),
        ],
      ),
    );
  }
}
