import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/Orders.dart';
import '../widgets/Order_item.dart';
import 'package:shop_app/widgets/app_drawer.dart';

class ordersScreen extends StatelessWidget {
  static const routename = '/orderScreen';

  const ordersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final order = Provider.of<Orders>(context , listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(


        itemBuilder: (ctx, i) => orderItem(order.orders[i]),
        itemCount: order.orders.length,
      ),
    );
  }
}
