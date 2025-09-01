import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/product.dart';
import '../providers/cart_provider.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);

    return ListTile(
      title: Text(product.title),
      subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
      trailing: ElevatedButton(
        onPressed: () {
          cart.addItem(product.id, product.title, product.price);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${product.title} added to cart')),
          );
        },
        child: const Text('Add to Cart'),
      ),
    );
  }
}
