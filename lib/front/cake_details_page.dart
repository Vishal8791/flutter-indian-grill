import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:indiangrill/providers/cart_provider.dart';
import 'package:provider/provider.dart' show Provider;

class CakeDetailsPage extends StatefulWidget {
  final Map product;

  const CakeDetailsPage({super.key, required this.product});

  @override
  State<CakeDetailsPage> createState() => _CakeDetailsPageState();
}

class _CakeDetailsPageState extends State<CakeDetailsPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 1100) {
      // ✅ Desktop layout
      return CakeDetailsDesktopLayout(
        product: widget.product,
        quantity: quantity,
        onQuantityChange: _updateQuantity,
      );
    } else if (width >= 700) {
      // ✅ Tablet layout
      return CakeDetailsTabletLayout(
        product: widget.product,
        quantity: quantity,
        onQuantityChange: _updateQuantity,
      );
    } else {
      // ✅ Mobile layout
      return CakeDetailsMobileLayout(
        product: widget.product,
        quantity: quantity,
        onQuantityChange: _updateQuantity,
      );
    }
  }

  void _updateQuantity(int newQty) {
    setState(() => quantity = newQty);
  }
}

class CakeDetailsDesktopLayout extends StatelessWidget {
  final Map product;
  final int quantity;
  final ValueChanged<int> onQuantityChange;

  const CakeDetailsDesktopLayout({
    super.key,
    required this.product,
    required this.quantity,
    required this.onQuantityChange,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = product['image'] ?? 'https://via.placeholder.com/300';
    final safeImageUrl =
        'https://images.weserv.nl/?url=${Uri.encodeComponent(imageUrl)}';
    final name = product['name'] ?? 'Unnamed Cake';
    final price = product['price'] ?? '\$0.00';
    final category = product['category'] ?? 'Birthday Cakes';
    final inStock = product['inStock'] ?? true;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 190),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: Image Section
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Image.network(safeImageUrl, fit: BoxFit.contain, height: 300),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back_ios_new, color: Color(0xffE2001A)),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward_ios, color: Color(0xffE2001A)),
                  ],
                ),
                const SizedBox(height: 20),
                _socialIcons(),
              ],
            ),
          ),
          const SizedBox(width: 50),
          // Right: Details
          Expanded(
            flex: 2,
            child: _CakeDetailsContent(
              name: name,
              price: price,
              category: category,
              inStock: inStock,
              quantity: quantity,
              onQuantityChange: onQuantityChange,
              sku: product['sku'] ?? '0000',
              product: product, // ✅ Added
            ),
          ),
        ],
      ),
    );
  }
}

class CakeDetailsMobileLayout extends StatelessWidget {
  final Map product;
  final int quantity;
  final ValueChanged<int> onQuantityChange;

  const CakeDetailsMobileLayout({
    super.key,
    required this.product,
    required this.quantity,
    required this.onQuantityChange,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = product['image'] ?? 'https://via.placeholder.com/300';
    final safeImageUrl =
        'https://images.weserv.nl/?url=${Uri.encodeComponent(imageUrl)}';
    final name = product['name'] ?? 'Unnamed Cake';
    final price = product['price'] ?? '\$0.00';
    final category = product['category'] ?? 'Birthday Cakes';
    final inStock = product['inStock'] ?? true;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(safeImageUrl, fit: BoxFit.contain, height: 250),
          const SizedBox(height: 20),
          _CakeDetailsContent(
            name: name,
            price: price,
            category: category,
            inStock: inStock,
            quantity: quantity,
            onQuantityChange: onQuantityChange,
            sku: product['sku'] ?? '0000',
            product: product, // ✅ Added
          ),
          const SizedBox(height: 20),
          _socialIcons(),
        ],
      ),
    );
  }
}

class CakeDetailsTabletLayout extends StatelessWidget {
  final Map product;
  final int quantity;
  final ValueChanged<int> onQuantityChange;

  const CakeDetailsTabletLayout({
    super.key,
    required this.product,
    required this.quantity,
    required this.onQuantityChange,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = product['image'] ?? 'https://via.placeholder.com/300';
    final safeImageUrl =
        'https://images.weserv.nl/?url=${Uri.encodeComponent(imageUrl)}';
    final name = product['name'] ?? 'Unnamed Cake';
    final price = product['price'] ?? '\$0.00';
    final category = product['category'] ?? 'Birthday Cakes';
    final inStock = product['inStock'] ?? true;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Image.network(safeImageUrl,
                    fit: BoxFit.contain, height: 250),
              ),
              const SizedBox(width: 30),
              Expanded(
                flex: 1,
                child: _CakeDetailsContent(
                  name: name,
                  price: price,
                  category: category,
                  inStock: inStock,
                  quantity: quantity,
                  onQuantityChange: onQuantityChange,
                  sku: product['sku'] ?? '0000',
                  product: product, // ✅ Added
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _socialIcons(),
        ],
      ),
    );
  }
}

class _CakeDetailsContent extends StatelessWidget {
  final String name;
  final String price;
  final String category;
  final bool inStock;
  final String sku;
  final int quantity;
  final ValueChanged<int> onQuantityChange;
  final Map product; // ✅ add this

  const _CakeDetailsContent({
    required this.name,
    required this.price,
    required this.category,
    required this.inStock,
    required this.sku,
    required this.quantity,
    required this.onQuantityChange,
    required this.product, // ✅ add this
  });

  @override
  Widget build(BuildContext context) {
    final instructionsController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: GoogleFonts.raleway(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              "Availability : ",
              style: GoogleFonts.raleway(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              inStock ? "In Stock" : "Out of Stock",
              style: GoogleFonts.raleway(
                fontSize: 14,
                color: inStock ? Colors.green : const Color(0xffE2001A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          "Price: \$${double.tryParse(price)?.toStringAsFixed(2) ?? price}",
          style: GoogleFonts.raleway(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xffE2001A),
          ),
        ),
        const SizedBox(height: 20),

        // 📝 Textarea (Special Instructions)
        TextField(
          controller: instructionsController,
          decoration: InputDecoration(
            labelText: "Special Instructions",
            labelStyle: GoogleFonts.raleway(),
            border: const OutlineInputBorder(),
          ),
          maxLines: 3,
        ),

        const SizedBox(height: 20),

        // Quantity + Add to Cart
        Row(
          children: [
            IconButton(
              onPressed: () {
                if (quantity > 1) onQuantityChange(quantity - 1);
              },
              icon: const Icon(Icons.remove),
            ),
            Text('$quantity', style: GoogleFonts.raleway(fontSize: 18)),
            IconButton(
              onPressed: () => onQuantityChange(quantity + 1),
              icon: const Icon(Icons.add),
            ),
            const SizedBox(width: 10),
            // ✅ Correct call (fix argument order)
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xffE2001A),
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
  ),
  onPressed: () {
    final double parsedPrice =
        double.tryParse(price.toString().replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0;

    _addToCart(
      context,
      product['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(), // ✅ productId
      name, // ✅ correct title
      parsedPrice,
      quantity,
      '', // option
      instructionsController.text, // special instructions
      [], // selected options
    );
  },
  child: Text(
    "Add to Cart",
    style: GoogleFonts.raleway(
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
),

          ],
        ),

        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.favorite_border),
          label: Text(
            "Add to Wishlist",
            style: GoogleFonts.raleway(),
          ),
        ),

        const SizedBox(height: 20),
        Text(
          "SKU: #$sku",
          style: GoogleFonts.raleway(color: Colors.grey[700]),
        ),
        Text(
          "Category: $category",
          style: GoogleFonts.raleway(color: Colors.grey[700]),
        ),
      ],
    );
  }
}

void _addToCart(
  BuildContext context,
  String productId, // ✅ fixed param
  String title,
  double price,
  int quantity,
  String option,
  String specialInst,
  List<Map<String, String>> selectedoptions,
) {
  // print('🛒 ADD TO CART CALLED');
  // print('ID: $productId');
  // print('Title: $title');
  // print('Price: $price');
  // print('Quantity: $quantity');
  // print('Option: $option');
  // print('Special Instructions: $specialInst');
  // print('Selected Options: $selectedoptions');

  final cart = Provider.of<Cart>(context, listen: false);

  cart.addItem(
    productId,
    title,
    price,
    quantity,
    option,
    selectedoptions,
    specialInst,
  );

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('$title has been added to your cart!'),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
    ),
  );
}



Widget _socialIcons() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        FaIcon(FontAwesomeIcons.facebook, color: Colors.black54),
        SizedBox(width: 12),
        FaIcon(FontAwesomeIcons.twitter, color: Colors.black54),
        SizedBox(width: 12),
        FaIcon(FontAwesomeIcons.pinterest, color: Colors.black54),
      ],
    );
