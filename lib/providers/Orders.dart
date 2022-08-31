import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/widgets/Order_item.dart';
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

  final String? auth;
  final String UserId ;

  Orders(this._orders, this.auth , this.UserId);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchandset() async {
    final url =
        'https://newapp-99265-default-rtdb.firebaseio.com//orders/$UserId.json?auth=$auth';
    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadeditem = [];
    final ExtractedData = json.decode(response.body) as Map<String, dynamic>?;
    if (ExtractedData == null) {
      _orders = [];
      notifyListeners();
      return;
    }
    ExtractedData.forEach((orderId, Orderdata) {
      loadeditem.add(OrderItem(
          id: orderId,
          amount: Orderdata['amount'],
          products: (Orderdata['products'] as List<dynamic>)
              .map((e) => cartItem(
                  id: e['id'],
                  title: e['title'],
                  Quantity: e['quantity'],
                  price: e['price']))
              .toList(),
          date: DateTime.parse(Orderdata['dateTime'])));
    });
    _orders = loadeditem.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<cartItem> cartProducts, double total) async {
    final url =
        'https://newapp-99265-default-rtdb.firebaseio.com//orders/$UserId.json?auth=$auth';
    final timestamp = DateTime.now();
    final response = await http.post(Uri.parse(url),
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'Quantity': e.Quantity,
                    'price': e.price,
                  })
              .toList(),
        }));
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartProducts,
            date: DateTime.now()));
    notifyListeners();
  }
}
