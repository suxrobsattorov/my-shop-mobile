import 'package:flutter/material.dart';
import 'package:my_shop/models/Product.dart';
import 'package:my_shop/providers/Cart.dart';
import 'package:provider/provider.dart';

import '../screens/ProductDetailsScreen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.black54,
          leading: Consumer<Product>(
            builder: (ctx, pro, child) {
              return IconButton(
                onPressed: () {
                  pro.toggleFavorite();
                },
                icon: Icon(
                  pro.isFavorite ? Icons.favorite : Icons.favorite_outline,
                  color: Theme.of(context).primaryColor,
                ),
              );
            },
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addToCard(
                  product.id, product.title, product.imageURL, product.price);
            },
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailsScreen.routeName,
                arguments: product.id);
          },
          child: Image.network(
            product.imageURL,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
