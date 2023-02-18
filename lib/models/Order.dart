import 'CartItem.dart';

class Order {
  final String id;
  final DateTime date;
  final double totalPrice;
  final List<CartItem> products;

  Order({
    required this.id,
    required this.date,
    required this.totalPrice,
    required this.products,
  });
}
