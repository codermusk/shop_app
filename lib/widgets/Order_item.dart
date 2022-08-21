import 'package:flutter/material.dart  ';
import 'package:intl/intl.dart';
import '../providers/Orders.dart';
import 'dart:math';

class orderItem extends StatefulWidget {
  final OrderItem order;

  const orderItem(this.order);

  @override
  State<orderItem> createState() => _orderItemState();
}

class _orderItemState extends State<orderItem> {
  bool Expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            title: Text('\$ ${widget.order.amount}'),
            subtitle: Text(
              DateFormat('dd MM  yyyy hh:mm').format(widget.order.date),
            ),
            trailing: IconButton(
                icon: Icon(Expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    Expanded = !Expanded;
                  });
                }),
          ),
          if (Expanded)
            Container(
              height: min(widget.order.products.length * 20.0 + 100, 180),
              child: ListView(
                children: widget.order.products
                    .map(
                      (prod) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            prod.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${prod.Quantity}x \$${prod.price}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
