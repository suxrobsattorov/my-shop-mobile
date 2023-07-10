import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:my_shop/models/my_location.dart';
import 'package:my_shop/screens/save_product_screen.dart';
import 'package:provider/provider.dart';

import '../helpers/location_helper.dart';
import '../screens/home_screen.dart';
import '../screens/map_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/manage_products_screen.dart';
import '../providers/auth.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  Future<LocationData> _getCurrentLocation() async {
    try {
      return await Location().getLocation();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: const Text('Salom Do\'stim!'),
          ),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Magazin'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(HomeScreen.routeName),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Buyurtmalar'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(OrdersScreen.routeName),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Mahsulotlarni Boshqarish'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(ManageProductsScreen.routeName),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.save_alt),
            title: const Text('Saqlanganlar'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(SaveProductScreen.routeName),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Mening Manzilim'),
            onTap: () async {
              final locationData = await _getCurrentLocation();

              // ignore: unnecessary_null_comparison
              if (locationData != null) {
                final String formattedAddress =
                    await LocationHelper.getFormattedAddress(
                        locationData.latitude!, locationData.longitude!);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => MapScreen(
                      myLocation: MyLocation(
                        latitude: locationData.latitude!,
                        longitude: locationData.longitude!,
                        address: formattedAddress,
                      ),
                    ),
                  ),
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => MapScreen(
                      myLocation: MyLocation(
                          latitude: 41.307741,
                          longitude: 69.239525,
                          address: 'Tashkent'),
                    ),
                  ),
                );
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Chiqish'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
