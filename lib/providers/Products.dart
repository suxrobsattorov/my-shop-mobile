import 'package:flutter/material.dart';

import '../models/Product.dart';

class Products with ChangeNotifier {
  final List<Product> _products = [
    Product(
      id: "1",
      title: "iPhone 13 Pro",
      description: "Ajoyib iPhone 13 Pro, Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum, Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum, Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum, Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",
      price: 1000.79,
      imageURL:
          "https://www.digitaltrends.com/wp-content/uploads/2021/09/iphone-13-pro-review-dan-baker-35.jpg?p=1",
    ),
    Product(
      id: "2",
      title: "AirPods Pro",
      description: "Ajoyib AirPods Pro",
      price: 50.99,
      imageURL:
          "https://www.apple.com/newsroom/images/product/airpods/standard/Apple-AirPods-Pro-2nd-gen-hero-220907.jpg.og.jpg?202302091606",
    ),
    Product(
      id: "3",
      title: "MacBook Pro",
      description: "Ajoyib MacBook Pro",
      price: 1500.89,
      imageURL:
          "https://s.yimg.com/os/creatr-uploaded-images/2020-12/d37e0460-3eeb-11eb-b7f9-449e864b9135",
    ),
    Product(
      id: "4",
      title: "iWatch",
      description: "Ajoyib iWatch",
      price: 16.99,
      imageURL:
          "https://images.prom.ua/2766707439_w640_h640_smart-chasy-iwatch.jpg",
    ),
  ];

  List<Product> get list {
    return [..._products];
  }

  List<Product> get favorites {
    return _products.where((product) => product.isFavorite).toList();
  }

  Product findById(String id) {
    return _products.firstWhere((product) => product.id == id);
  }
}
