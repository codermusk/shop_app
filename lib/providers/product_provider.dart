import 'package:shop_app/model/httpException.dart';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'product.dart';
import 'dart:convert';

class Products with ChangeNotifier {
  final String? token;
  final String? userId ;

  Products(this.token, this._items , this.userId);

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  // var showFavourite = false ;

  List<Product> get items {
    // if(showFavourite){
    //   return _items.where((element) => element.isFavourite ).toList();
    //
    // }
    return [..._items];
  }

  //  void ShowFavourite(){
  // showFavourite = true ;
  //    notifyListeners();
  //  }
  //  void showAll(){
  //    showFavourite = false ;
  //    notifyListeners() ;
  //  }

  Future<void> getsetProduct([bool filterByUser = false]) async {
    var filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId' : ' ';
    var url =
        'https://newapp-99265-default-rtdb.firebaseio.com//product.json?auth=$token&$filterString'
        '';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
       url = 'https://newapp-99265-default-rtdb.firebaseio.com//product/$userId.json?auth=$token';
      final favouriteResponse = await http.get(Uri.parse(url));
      final favouriteData =  json.decode(favouriteResponse.body);
      final List<Product> Loadeddata = [];
      extractedData.forEach((productId, Productdata) {
        Loadeddata.add(Product(
            id: productId,
            title: Productdata['title'],
            description: Productdata['description'],
            price: Productdata['price'],
            imageUrl: Productdata['imageUrl'],
            isFavourite:favouriteData == null ? false :  favouriteData[productId],
        ));
      });
      _items = Loadeddata;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Product findBy(String productId) {
    return _items.firstWhere((element) => element.id == productId);
  }

  Future<void> addProducts(Product product) async {
    final url =
        'https://newapp-99265-default-rtdb.firebaseio.com//product.json?auth=$token';
    try {
      final value = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavourite': product.isFavourite,
          'creatorId' : userId ,
        }),
      );
      final newProduct = Product(
          id: jsonDecode(value.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print('error occured');
      rethrow;
    }

    // .catchError((error){

    // });
  }

  List<Product> get favourites {
    return _items
        .where(
          (element) => element.isFavourite,
    )
        .toList();
  }

  void refreshProductList() {
    notifyListeners();
  }

  Future<void> UpdateProuct(String id, Product newProduct) async {
    final index = _items.indexWhere((element) => element.id == id);
    final url =
        'https://newapp-99265-default-rtdb.firebaseio.com//product/$id.json?auth=$token';
    await http.patch(Uri.parse(url),
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price,
        }));
    if (index >= 0) {
      _items[index] = newProduct;
      notifyListeners();
    }
  }


  Future<void> DeleteProduct(String id) async {
    final existingProductIndex =
    _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();
    final url =
        'https://newapp-99265-default-rtdb.firebaseio.com//product/$id.json';
    final response = await http.delete(Uri.parse(url)).then((response) {
      if (response.statusCode >= 400) {
        throw HttpException('Could Not Delete The Product');
      }
    }).catchError((_) {
      _items.insert(existingProductIndex, existingProduct);
    });
    notifyListeners();
  }
}
