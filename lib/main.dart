import 'package:flutter/material.dart';
import 'package:my_shop/providers/Cart.dart';
import 'package:my_shop/providers/Orders.dart';
import 'package:my_shop/providers/Products.dart';
import 'package:my_shop/screens/CartScreen.dart';
import 'package:my_shop/screens/HomeScreen.dart';
import 'package:my_shop/screens/ProductDetailsScreen.dart';
import 'package:my_shop/styles/MyShopStyle.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Products>(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider<Cart>(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider<Orders>(
          create: (context) => Orders(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: MyShopStyle.theme,
        home: const HomeScreen(),
        routes: {
          ProductDetailsScreen.routeName: (context) =>
              const ProductDetailsScreen(),
          CartScreen.routeName: (context) => const CartScreen(),
        },
      ),
    );
  }
}
