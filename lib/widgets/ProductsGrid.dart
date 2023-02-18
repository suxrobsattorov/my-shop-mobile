import 'package:flutter/material.dart';
import 'package:my_shop/models/Product.dart';
import 'package:my_shop/providers/Products.dart';
import 'package:provider/provider.dart';

import 'ProductItem.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavorites;

  const ProductsGrid(this.showFavorites, {super.key});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavorites ? productsData.favorites : productsData.list;
    print(products.map((e) {
      return e.title;
    }));
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 3 / 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ChangeNotifierProvider<Product>.value(
          value: products[index],
          child: ProductItem(),
        );
      },
    );
  }
}
