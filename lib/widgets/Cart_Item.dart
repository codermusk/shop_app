import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class cartItem extends StatelessWidget {
  final String id;
  final String Productid;

  final String title;

  final int quantity;

  final double price;

  cartItem(this.id, this.Productid, this.quantity, this.price, this.title);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
       return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('ARE YOU SURE'),
            content: Text('Do you want to remove from the cart '),
            actions: [
              FlatButton(onPressed: (){
                Navigator.of(context).pop(false);
              }, child: Text('NO')),
              FlatButton(onPressed: (){
                Navigator.of(context).pop(true);
              }, child: Text( 'YES'))
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(Productid);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: Padding(
              padding: EdgeInsets.all(10),
              child: FittedBox(
                fit: BoxFit.fill,
                child: CircleAvatar(
                  radius: 35,
                  child: Text('\$ $price'),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total : \$ ${(price * quantity)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
