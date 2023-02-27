import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartListItem extends StatelessWidget {
  final String productId;
  final String imageUrl;
  final String title;
  final double price;
  final int quantity;
  const CartListItem({
    Key? key,
    required this.productId,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.quantity,
  }) : super(key: key);

  void _notifyUserAboutDelete(BuildContext context, Function() removeItem) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Ishonchingiz komilmi?'),
          content: const Text('Savatchadan bu mahsulot o\'chmoqda!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'BEKOR QILISH',
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                removeItem();
                Navigator.of(context).pop();
              },
              child: const Text('O\'CHIRISH'),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).errorColor,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Slidable(
      key: ValueKey(productId),
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          ElevatedButton(
            onPressed: () => _notifyUserAboutDelete(
              context,
              () => cart.removeItem(productId),
            ),
            child: const Text(
              'O\'chirish',
              style: TextStyle(fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).errorColor,
              padding: const EdgeInsets.symmetric(
                vertical: 25,
                horizontal: 20,
              ),
            ),
          ),
        ],
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          title: Text(title),
          subtitle: Text('Umumiy: \$${(price * quantity).toStringAsFixed(2)}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => cart.removeSingleItem(productId),
                icon: const Icon(Icons.remove, color: Colors.black),
                splashRadius: 20,
              ),
              Container(
                alignment: Alignment.center,
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade100,
                ),
                child: Text('$quantity'),
              ),
              IconButton(
                onPressed: () => cart.addToCart(
                  productId,
                  title,
                  imageUrl,
                  price,
                ),
                icon: const Icon(Icons.add, color: Colors.black),
                splashRadius: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
