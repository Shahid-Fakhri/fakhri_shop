import 'dart:convert';
//import 'dart:html';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorate;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorate = false,
  });

  void _setFavValue(bool newValue) {
    isFavorate = newValue;
    notifyListeners();
  }

  Future<void> toggleFavorateStatus(String token, String userId) async {
    final oldStatus = isFavorate;
    isFavorate = !isFavorate;
    notifyListeners();
    final url = Uri.https(
        // access specific product with id
        'flutter-update-143c1-default-rtdb.firebaseio.com',
        '/userFavorates/$userId/$id.json',
        {'auth': token});
    try {
      final response = await http.put(url,
          body: json.encode(
            isFavorate,
          ));
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
