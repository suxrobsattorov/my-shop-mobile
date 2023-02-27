import 'package:flutter/material.dart';
import 'package:my_shop/providers/auth.dart';
import 'package:my_shop/providers/auth.dart';
import 'package:my_shop/screens/auth_screen.dart';
import 'package:provider/provider.dart';

import './screens/home_screen.dart';
import './screens/product_details_screen.dart';
import './screens/cart_screen.dart';
import './screens/manage_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/orders_screen.dart';
import './styles/my_shop_style.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  ThemeData theme = MyShopStyle.theme;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider<Products>(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider<Cart>(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider<Orders>(
          create: (ctx) => Orders(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, authData, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Mening Do\'konim',
            theme: theme,
            home: const AuthScreen(),
            routes: {
              HomeScreen.routeName: (ctx) => const HomeScreen(),
              ProductDetailsScreen.routeName: (ctx) =>
                  const ProductDetailsScreen(),
              CartScreen.routeName: (ctx) => const CartScreen(),
              OrdersScreen.routeName: (ctx) => const OrdersScreen(),
              ManageProductsScreen.routeName: (ctx) =>
                  const ManageProductsScreen(),
              EditProductScreen.routeName: (ctx) => const EditProductScreen(),
            },
          );
        },
      ),
    );
  }
}
