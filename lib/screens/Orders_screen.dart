import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/Orders.dart';
import '../widgets/Order_item.dart';
import 'package:shop_app/widgets/app_drawer.dart';

class ordersScreen extends StatefulWidget {
  static const routename = '/orderScreen';

  const ordersScreen({Key? key}) : super(key: key);

  @override
  State<ordersScreen> createState() => _ordersScreenState();
}

class _ordersScreenState extends State<ordersScreen> {
  var _isloading = false;

  @override
  void initState() {
    // Future.delayed(Duration.zero).then((_) async {
    //   setState(() {
    //     _isloading = true;
    //   });
    //
    //   await Provider.of<Orders>(context, listen: false).fetchandset().then((_) {
    //     setState(() {
    //       _isloading = false;
    //     });
    //   });
    // });
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    final order = Provider.of<Orders>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).fetchandset(),
          builder: (ctx, datasnapshot) {
            if (datasnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, order, child) => ListView.builder(
                  itemBuilder: (ctx, i) => orderItem(order.orders[i]),
                  itemCount: order.orders.length,
                ),
              );
            }
          },
        ));
  }
}
