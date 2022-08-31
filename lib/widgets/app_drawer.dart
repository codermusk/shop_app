import 'package:flutter/material.dart ';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/Orders_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello Friend'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ordersScreen.routename);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('MANAGE PRODUCTS'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(userProducts.route);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('LOG OUT '),
            onTap: () {
              Navigator.of(context).pop();
              // Navigator.of(context).pushReplacementNamed(userProducts.route);
            Provider.of<Auth>(context , listen: false).logout();
            },
          )
        ],
      ),
    );
  }
}
