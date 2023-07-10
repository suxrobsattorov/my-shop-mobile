import 'package:flutter/material.dart';
import 'package:my_shop/providers/user_products.dart';
import 'package:my_shop/screens/product_details_screen.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';

class SaveProductScreen extends StatelessWidget {
  const SaveProductScreen({Key? key}) : super(key: key);

  static const routeName = '/save_products';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Saqlanganlar'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<UserProducts>(context, listen: false).getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Consumer<UserProducts>(
            builder: (context, placeProvider, child) {
              if (placeProvider.list.isNotEmpty) {
                return ListView.builder(
                  itemCount: placeProvider.list.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        placeProvider.list[index].imageUrl,
                      ),
                    ),
                    title: Text(
                      placeProvider.list[index].title,
                    ),
                    trailing: Text(
                      '${placeProvider.list[index].price.toStringAsFixed(0)}\$',
                    ),
                  ),
                );
              } else {
                return child!;
              }
            },
            child: const Center(
              child: Text('Saqlanganlar mavjud emas.'),
            ),
          );
        },
      ),
    );
  }
}
