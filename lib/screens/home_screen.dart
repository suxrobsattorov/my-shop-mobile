import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../widgets/custom_cart.dart';
import '../widgets/app_drawer.dart';
import '../providers/cart.dart';
import 'cart_screen.dart';

enum FiltersOption {
  Favorites,
  All,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = '/home';

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
        title: const Text('Mening Do\'konim'),
        actions: [
          PopupMenuButton(
            onSelected: (FiltersOption filter) {
              setState(() {
                if (filter == FiltersOption.All) {
                  //... barchasini ko'rsat
                  _showOnlyFavorites = false;
                } else {
                  //... sevimlilarni ko'rsat
                  _showOnlyFavorites = true;
                }
              });
            },
            itemBuilder: (ctx) {
              return const [
                PopupMenuItem(
                  child: Text('Barchasi'),
                  value: FiltersOption.All,
                ),
                PopupMenuItem(
                  child: Text('Sevimli'),
                  value: FiltersOption.Favorites,
                )
              ];
            },
          ),
          Consumer<Cart>(
            builder: (ctx, cart, child) {
              return CustomCart(
                child: child!,
                number: cart.itemsCount().toString(),
              );
            },
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () =>
                  Navigator.of(context).pushNamed(CartScreen.routeName),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
