import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class OrderItem {
  final String id;

  final double amount;

  final DateTime date;

  final List<cartItem> products;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.date});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];

  }

  void addOrder(List<cartItem> cartProducts, double total) {
    _orders.insert(
        0,
        OrderItem(
            id: DateTime.now().toString(),
            amount: total,
            products: cartProducts,
            date: DateTime.now()));
  }
  notifyListeners();
}
