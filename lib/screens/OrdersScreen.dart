import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_shop/providers/Orders.dart';
import 'package:my_shop/widgets/AppDrawer.dart';
import 'package:provider/provider.dart';

import '../widgets/OrderItem.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders";

  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Buyurtmalar"),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: orders.items.length,
        itemBuilder: (ctx, index) {
          final order = orders.items[index];
          return OrderItem(
            totalPrice: order.totalPrice,
            date: order.date,
            products: order.products,
          );
        },
      ),
    );
  }
}
