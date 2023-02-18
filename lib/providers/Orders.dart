import 'package:flutter/material.dart';

import '../models/CartItem.dart';
import '../models/Order.dart';

class Orders with ChangeNotifier {
  final List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  void addToOrders(List<CartItem> products, double totalPrice) {
    _items.insert(
      0,
      Order(
        id: UniqueKey().toString(),
        date: DateTime.now(),
        totalPrice: totalPrice,
        products: products,
      ),
    );
    notifyListeners();
  }
}
