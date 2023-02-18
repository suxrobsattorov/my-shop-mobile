import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_shop/providers/Cart.dart';
import 'package:provider/provider.dart';

class CartListItem extends StatelessWidget {
  final String productId;
  final String imageUrl;
  final String title;
  final double price;
  final int quantity;

  const CartListItem({
    super.key,
    required this.productId,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.quantity,
  });

  void _notifyUserUserAboutDelete(BuildContext context, Function() removeItem) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Ishonchingiz komilmi?"),
          content: const Text("Savatchadan bu maxsulot o'chmoqda!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "BEKOR QILISH",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                removeItem();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).errorColor,
              ),
              child: const Text("O'CHIRISH"),
            )
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
        extentRatio: 0.22,
        motion: const ScrollMotion(),
        children: [
          ElevatedButton(
            onPressed: () => _notifyUserUserAboutDelete(
                context, () => cart.removeItem(productId)),
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).colorScheme.error,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            ),
            child: const Text("O'chirish"),
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
          subtitle: Text(
            "Umumiy:  \$${(price * quantity).toStringAsFixed(2)}",
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => cart.removeSingleItem(productId),
                icon: const Icon(
                  Icons.remove,
                  color: Colors.black,
                ),
                splashRadius: 20,
              ),
              Container(
                alignment: Alignment.center,
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade100,
                ),
                child: Text(
                  "$quantity",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () =>
                    cart.addToCard(productId, title, imageUrl, price),
                icon: const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                splashRadius: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
