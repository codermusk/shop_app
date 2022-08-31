import 'package:flutter/material.dart';
import 'package:shop_app/providers/Orders.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/screens/Orders_screen.dart';
import 'package:shop_app/screens/edit_product.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';
import './screens/products_overview_screen.dart';
import 'package:provider/provider.dart';
import './providers/product_provider.dart';
import './screens/auth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (_) => Products(null, [], ''),
            update: (ctx, auth, previousProducts) => Products(
                auth.token as String,
                previousProducts == null ? [] : previousProducts.items,
                auth.userid as String),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
              create: (_) => Orders([], null , ''),
              update: (ctx, auth, previousProducts) =>
                  Orders(previousProducts!.orders, auth.token as String , auth.userid )),
        ],
        child: Consumer<Auth>(
          builder: (ctx, Auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              canvasColor: Colors.blueGrey,
              fontFamily: 'Lato',
            ),
            home: Auth.isauth ? productOverview() : AuthScreen(),
            routes: {
              productDetailScreen.routename: (ctx) => productDetailScreen(),
              cartScreen.route: (ctx) => cartScreen(),
              ordersScreen.routename: (ctx) => ordersScreen(),
              userProducts.route: (ctx) => userProducts(),
              editProductScreen.route: (ctx) => editProductScreen(),
            },
          ),
        ));
  }
}
