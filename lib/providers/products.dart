import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../services/http_exception.dart';
import '../models/product.dart';

class Products with ChangeNotifier {
  List<Product> _list = [];

  String? _authToken;
  String? _userId;

  void setParams(String? authToken, String? userId) {
    _authToken = authToken;
    _userId = userId;
  }

  List<Product> get list {
    return [..._list];
  }

  List<Product> get favorites {
    return _list.where((product) => product.isFavorite).toList();
  }

  Future<void> getProductsFromFirebase([bool filterByUser = false]) async {
    final filterString =
    filterByUser ? 'orderBy="creatorId"&equalTo="$_userId"' : '';
    final url = Uri.parse(
        'https://my-shop-45cb3-default-rtdb.firebaseio.com/products.json?auth=$_authToken&$filterString');

    try {
      final response = await http.get(url);

      if (jsonDecode(response.body) != null) {
        final favoriteUrl = Uri.parse(
            'https://my-shop-45cb3-default-rtdb.firebaseio.com/userFavorites/$_userId.json?auth=$_authToken');

        final favoriteResponse = await http.get(favoriteUrl);
        final favoriteData = jsonDecode(favoriteResponse.body);

        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final List<Product> loadedProducts = [];
        data.forEach((productId, productData) {
          loadedProducts.add(Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            imageUrl: productData['imageUrl'],
            isFavorite:
            favoriteData == null ? false : favoriteData[productId] ?? false,
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
        'https://my-shop-45cb3-default-rtdb.firebaseio.com/products.json?auth=$_authToken');

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': _userId,
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
          'https://my-shop-45cb3-default-rtdb.firebaseio.com/products/${updatedProduct
              .id}.json?auth=$_authToken');
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
        'https://my-shop-45cb3-default-rtdb.firebaseio.com/products/$id.json?auth=$_authToken');

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
