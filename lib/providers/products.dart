import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../services/http_exception.dart';
import '../models/product.dart';

class Products with ChangeNotifier {
  List<Product> _list = [
    // Product(
    //   id: 'p1',
    //   title: 'Macbook Pro',
    //   description:
    //       'Ajoyib Macbook Pro - u juda ham ajoyib!Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Ajoyib Macbook Pro - u juda ham ajoyib!Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Ajoyib Macbook Pro - u juda ham ajoyib!Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    //   price: 29.99,
    //   imageUrl:
    //       'https://images.unsplash.com/photo-1580522154071-c6ca47a859ad?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1740&q=80',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'iPhone 13',
    //   description: 'Ajoyib iPhone.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://images.unsplash.com/photo-1632661674596-df8be070a5c5?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Apple Watch',
    //   description: 'Uzgacha va qulay - xuddi siz xohlaganingizdek.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1772&q=80',
    // ),
  ];

  List<Product> get list {
    return [..._list];
  }

  List<Product> get favorites {
    return _list.where((product) => product.isFavorite).toList();
  }

  Future<void> getProductsFromFirebase() async {
    final url = Uri.parse(
        'https://my-shop-45cb3-default-rtdb.firebaseio.com/products.json');

    try {
      final response = await http.get(url);

      if (jsonDecode(response.body) != null) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final List<Product> loadedProducts = [];
        data.forEach((productId, productData) {
          loadedProducts.add(Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            imageUrl: productData['imageUrl'],
            isFavorite: productData['isFavorite'],
          ));
        });

        _list = loadedProducts;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    // http formula = Http Endpoint (url) + http so'rovi = natija
    final url = Uri.parse(
        'https://my-shop-45cb3-default-rtdb.firebaseio.com/products.json');

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite,
          },
        ),
      );

      final name = (jsonDecode(response.body) as Map<String, dynamic>)['name'];
      final newProduct = Product(
        id: name,
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _list.add(newProduct);
      // _list.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      // throw error;
      rethrow;
    }
  }

  Future<void> updateProduct(Product updatedProduct) async {
    final productIndex = _list.indexWhere(
      (product) => product.id == updatedProduct.id,
    );
    if (productIndex >= 0) {
      final url = Uri.parse(
          'https://my-shop-45cb3-default-rtdb.firebaseio.com/products/${updatedProduct.id}.json');
      try {
        await http.patch(
          url,
          body: jsonEncode(
            {
              'title': updatedProduct.title,
              'description': updatedProduct.description,
              'price': updatedProduct.price,
              'imageUrl': updatedProduct.imageUrl,
            },
          ),
        );
        _list[productIndex] = updatedProduct;
        notifyListeners();
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://my-shop-45cb3-default-rtdb.firebaseio.com/products/$id.json');

    try {
      var deletingProduct = _list.firstWhere((product) => product.id == id);
      final productIndex = _list.indexWhere((product) => product.id == id);
      _list.removeWhere((product) => product.id == id);
      notifyListeners();

      final response = await http.delete(url);

      if (response.statusCode >= 400) {
        _list.insert(productIndex, deletingProduct);
        notifyListeners();
        throw HttpException('Kechirasiz, o\'chirishda xatolik');
      }
    } catch (e) {
      rethrow;
    }
  }

  Product findById(String productId) {
    return _list.firstWhere((product) => product.id == productId);
  }
}
