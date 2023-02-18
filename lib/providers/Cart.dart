import 'package:flutter/material.dart';
import 'package:my_shop/models/CartItem.dart';

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int itemCount() {
    return _items.length;
  }

  double get totalPrice {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addToCard(String productId, String title, String image, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (currentProduct) => CartItem(
          id: currentProduct.id,
          title: currentProduct.title,
          image: currentProduct.image,
          price: currentProduct.price,
          quantity: currentProduct.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: UniqueKey().toString(),
          title: title,
          image: image,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (currentProduct) => CartItem(
          id: currentProduct.id,
          title: currentProduct.title,
          image: currentProduct.image,
          price: currentProduct.price,
          quantity: currentProduct.quantity - 1,
        ),
      );
      notifyListeners();
    }
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
