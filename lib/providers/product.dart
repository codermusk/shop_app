
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String? id;

  final String title;

  final String description;
  final double price;

  final String imageUrl;
  bool isFavourite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
       this.isFavourite = false});
  void toggleFavourite(String token , String userId) async {
    final oldFav = isFavourite;

    isFavourite = !isFavourite;
    final url = 'https://newapp-99265-default-rtdb.firebaseio.com//product/$userId/$id.json?auth=$token';
    try {
     final response =  await http.put(Uri.parse(url), body: json.encode(
          {
             isFavourite
          }
      ));
     if(response.statusCode>=400){
       isFavourite = oldFav ;
       notifyListeners();
     }

    }catch(error){
      isFavourite = oldFav ;
      notifyListeners();

    }
  }

  
}
