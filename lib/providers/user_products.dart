import 'package:flutter/material.dart';
import 'package:my_shop/database/products_db.dart';
import 'package:my_shop/models/product.dart';

class UserProducts with ChangeNotifier {
  List<Product> _list = [];

  List<Product> get list {
    return [..._list];
  }

  void addProduct(String title, double price, String image) {
    Product product = Product(
      id: UniqueKey().toString(),
      title: title,
      description: '',
      price: price,
      imageUrl: image,
    );
    _list.add(product);
    notifyListeners();

    ProductsDB.insert('user_products', {
      'id': product.id,
      'title': product.title,
      'price': product.price.toString(),
      'imageUrl': product.imageUrl,
    });
  }

  Future<void> getProducts() async {
    final productsList = await ProductsDB.getData('user_products');
    _list = productsList
        .map((product) => Product(
            id: product['id'],
            title: product['title'],
            description: product['description'],
            price: product['price'],
            imageUrl: product['imageUrl']))
        .toList();
    notifyListeners();
  }
}
