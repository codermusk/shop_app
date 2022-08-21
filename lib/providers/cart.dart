import 'package:flutter/foundation.dart';

class cartItem {
  final String id;

  final String title;

  final int Quantity;

  final double price;

  cartItem(
      {required this.id,
      required this.title,
      required this.Quantity,
      required this.price});
}

class Cart with ChangeNotifier {
  Map<String, cartItem> _items = {};

  Map<String, cartItem> get items {
    return {..._items};
  }

  int get cartcount {
    return _items == null ? 0 : _items.length;
  }

  double get totalamt {
    double total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.Quantity;
    });
    return total;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }
  void removeSingletem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.Quantity > 1) {
      _items.update(
          productId,
              (value) => cartItem(
              id: value.id,
              title: value.title,
              Quantity: value.Quantity - 1,
              price: value.price));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void addItem(String id, String title, double price) {
    if (_items.containsKey(id)) {
      _items.update(
          id,
          (val) => cartItem(
              id: val.id,
              title: val.title,
              Quantity: val.Quantity + 1,
              price: val.price));
    } else {
      _items.putIfAbsent(
          id,
          () => cartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              Quantity: 1));
    }



    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
//good job bro..!