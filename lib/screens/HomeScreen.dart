import 'package:flutter/material.dart';
import 'package:my_shop/screens/CartScreen.dart';
import 'package:my_shop/widgets/AppDrawer.dart';
import 'package:my_shop/widgets/CustomCart.dart';
import 'package:provider/provider.dart';

import '../providers/Cart.dart';
import '../widgets/ProductsGrid.dart';

// ignore: constant_identifier_names
enum FiltersOption { ALL, FAVORITE }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = "/";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("My Shop"),
        actions: [
          PopupMenuButton(
            onSelected: (FiltersOption filter) {
              setState(() {
                if (filter == FiltersOption.ALL) {
                  _showOnlyFavorites = false;
                } else {
                  _showOnlyFavorites = true;
                }
              });
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: FiltersOption.ALL,
                  child: Text("Barchasi"),
                ),
                const PopupMenuItem(
                  value: FiltersOption.FAVORITE,
                  child: Text("Sevimli"),
                ),
              ];
            },
          ),
          Consumer<Cart>(
            builder: (ctx, cart, child) {
              return CustomCart(
                number: cart.itemCount().toString(),
                child: child!,
              );
            },
            child: IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(CartScreen.routeName),
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
