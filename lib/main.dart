import 'package:flutter/material.dart';
import 'package:shop_app/providers/Orders.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/screens/Orders_screen.dart';
import 'package:shop_app/screens/edit_product.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';
import './screens/products_overview_screen.dart';
import 'package:provider/provider.dart';
import './providers/product_provider.dart';

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
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ) , 
        ChangeNotifierProvider(create :(ctx) => Orders()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          canvasColor: Colors.blueGrey,
          fontFamily: 'Lato',
        ),
        home: productOverview(),
        routes: {

          productDetailScreen.routename: (ctx) => productDetailScreen(),
          cartScreen.route : (ctx)=> cartScreen() ,
          ordersScreen.routename : (ctx) =>  ordersScreen(),
          userProducts.route : (ctx) => userProducts(),
          editProductScreen.route : (ctx)=> editProductScreen(),
        },
      ),
    );
  }
}
