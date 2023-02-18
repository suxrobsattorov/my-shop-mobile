import 'package:flutter/material.dart';
import 'package:my_shop/providers/Cart.dart';
import 'package:my_shop/screens/CartScreen.dart';
import 'package:provider/provider.dart';

import '../providers/Products.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = "/product-details";

  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments;
    final product = Provider.of<Products>(context, listen: false)
        .findById(productId as String);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Image.network(
                product.imageURL,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(product.description),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        height: 80,
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Narxi:",
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
                Text(
                  "\$${product.price}",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Consumer<Cart>(
              builder: (ctx, cart, child) {
                final isProductAdded = cart.items.containsKey(productId);
                if (isProductAdded) {
                  return ElevatedButton.icon(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(CartScreen.routeName),
                    icon: const Icon(
                      Icons.shopping_bag_outlined,
                      size: 20,
                      color: Colors.black,
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 12),
                      backgroundColor: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    label: const Text(
                      "Savatchaga borish",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  );
                } else {
                  return ElevatedButton(
                    onPressed: () => cart.addToCard(productId, product.title,
                        product.imageURL, product.price),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 12),
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Savatchaga qo'shish"),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
