import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/Orders.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/Cart_Item.dart';

class cartScreen extends StatelessWidget {
  const cartScreen({Key? key}) : super(key: key);
  static const route = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Spacer(),
                  Chip(
                    label: Text('\$ ${cart.totalamt}'),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) => cartItem(
                cart.items.values.toList()[i].id,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].Quantity,
                cart.items.values.toList()[i].price,
                cart.items.values.toList()[i].title,
              ),
              itemCount: cart.items.length,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}



class _OrderButtonState extends State<OrderButton> {
  var _isloading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed:
            // :
         ()
        async {
                setState(() {
                  _isloading = true;
                });
                await Provider.of<Orders>(context, listen: false).addOrder(
                    widget.cart.items.values.toList(), widget.cart.totalamt

                );
                setState(() {
                  _isloading  = false ;
                });
                widget.cart.clear();
              },
        child: _isloading
            ? CircularProgressIndicator()
            :  Text(
                'ORDER NOW ',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ));
  }
}
