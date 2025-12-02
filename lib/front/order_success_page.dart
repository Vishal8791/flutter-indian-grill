import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderSuccessPage extends StatelessWidget {
  final String orderId;
  final List<dynamic> items;
  final String paymentMethod;
  final String shippingMethod;
  final Map<String, dynamic> totals;

  const OrderSuccessPage({
    super.key,
    required this.orderId,
    required this.items,
    required this.paymentMethod,
    required this.shippingMethod,
    required this.totals,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return _buildMobileLayout(context);     // 📱 MOBILE
        } else if (constraints.maxWidth < 900) {
          return _buildTabletLayout(context);     // 📲 TABLET
        } else {
          return _buildDesktopLayout(context);    // 🖥️ DESKTOP
        }
      },
    );
  }

  // ---------------------------------------------------------------------------
  // 📱 MOBILE LAYOUT
  // ---------------------------------------------------------------------------
  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Order Success", style: TextStyle(color: Colors.black)),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _buildMainContent(context, horizontalPadding: 20),
    );
  }

  // ---------------------------------------------------------------------------
  // 📲 TABLET LAYOUT
  // ---------------------------------------------------------------------------
  Widget _buildTabletLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Order Success", style: TextStyle(color: Colors.black)),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: SizedBox(
          width: 700,
          child: _buildMainContent(context, horizontalPadding: 30),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 🖥️ DESKTOP LAYOUT
  // ---------------------------------------------------------------------------
  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: _buildMainContent(context, horizontalPadding: 40),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 🔥 SHARED MAIN CONTENT USED BY ALL LAYOUTS
  // ---------------------------------------------------------------------------
  Widget _buildMainContent(BuildContext context, {required double horizontalPadding}) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _successHeader(),
          const SizedBox(height: 35),
          _orderSummaryCard(),
          const SizedBox(height: 35),
          _continueButton(context),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SUCCESS HEADER
  // ---------------------------------------------------------------------------
  Widget _successHeader() {
    return Container(
      padding: const EdgeInsets.all(35),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(Icons.check_circle_rounded, size: 90, color: Colors.green.shade600),
          const SizedBox(height: 20),
          Text(
            "Order Received!",
            style: GoogleFonts.raleway(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xffe2001a),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Thank you for your purchase.\nYour order #$orderId is confirmed.",
            style: GoogleFonts.raleway(fontSize: 16, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            "A confirmation email has been sent.",
            style: GoogleFonts.raleway(fontSize: 14, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ORDER SUMMARY CARD
  // ---------------------------------------------------------------------------
  Widget _orderSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Ordered Items"),
          const SizedBox(height: 12),

          Column(
            children: items.map((item) => _orderItemCard(item)).toList(),
          ),

          const SizedBox(height: 30),
          _sectionTitle("Order Summary"),
          const SizedBox(height: 12),

          _totalRow("Subtotal", totals["subtotal"]),
          _totalRow("Tax", totals["tax"]),
          _totalRow("Tip", totals["tip"]),
          _totalRow("Shipping", totals["shipping"]),

          const Divider(height: 30),

          _totalRow("Total", totals["total"], bold: true, large: true),

          const SizedBox(height: 25),
          _sectionTitle("Shipping Method"),
          Text(shippingMethod, style: GoogleFonts.raleway(fontSize: 15)),
          const SizedBox(height: 25,),
          _sectionTitle("Payment Method"),
          const SizedBox(height: 8),
          Text(paymentMethod, style: GoogleFonts.raleway(fontSize: 15)),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CONTINUE BUTTON
  // ---------------------------------------------------------------------------
  Widget _continueButton(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 260,
      child: ElevatedButton(
        onPressed: () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffe2001a),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          "Continue Shopping",
          style: GoogleFonts.raleway(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // REUSABLE ELEMENTS
  // ---------------------------------------------------------------------------
  Widget _sectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.raleway(
        fontSize: 17,
        color: const Color(0xffe2001a),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _orderItemCard(dynamic item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item["name"],
              style: GoogleFonts.raleway(fontSize: 15),
            ),
          ),
          Text("x${item["qty"]}",
              style: GoogleFonts.raleway(fontSize: 14, color: Colors.grey[700])),
          const SizedBox(width: 14),
          Text(
            "\$${item["total"]}",
            style: GoogleFonts.raleway(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _totalRow(String label, dynamic value,
      {bool bold = false, bool large = false}) {
    final formatted = value == null
        ? "0.00"
        : double.tryParse(value.toString())?.toStringAsFixed(2) ??
            value.toString();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.raleway(
                fontSize: large ? 20 : 16,
                fontWeight: bold ? FontWeight.bold : FontWeight.w400,
              )),
          Text(
            "\$$formatted",
            style: GoogleFonts.raleway(
              fontSize: large ? 20 : 16,
              fontWeight: bold ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
