import 'dart:convert';
import 'dart:ffi';
import '../model/httpException.dart';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  late String? _token;

  var _expirydate;

  late String? _userid;

  bool get isauth {
    return token != null;
  }

  String get userid {
    return _userid as String;
  }

  String? get token {
    if (_expirydate != null &&
        _expirydate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signup(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBR_jgqswUlu4f8MbwQi5NttTFL7yvAi4Q';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnsecurertoken': true,
          }));
      final ResponseData = json.decode(response.body);
      if (ResponseData['error'] != null) {
        throw HttpException(ResponseData['error']['message']);
      }
      _token = ResponseData['idToken'];
      _userid = ResponseData['localId'];
      _expirydate = DateTime.now()
          .add(Duration(seconds: int.parse(ResponseData['expiresIn'])));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBR_jgqswUlu4f8MbwQi5NttTFL7yvAi4Q';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnsecurertoken': true,
          }));
      final ResponseData = json.decode(response.body);
      if (ResponseData['error'] != null) {
        throw HttpException(ResponseData['error']['message']);
      }
      _token = ResponseData['idToken'];
      _userid = ResponseData['localId'];
      _expirydate = DateTime.now()
          .add(Duration(seconds: int.parse(ResponseData['expiresIn'])));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void logout() {
    _userid = '';
    _token = '';
    _expirydate = '';
  }
}
