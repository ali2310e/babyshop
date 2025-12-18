import 'package:flutter/foundation.dart';
import 'package:babyshop/models/product.dart';

class WishlistManager extends ChangeNotifier {
  static final WishlistManager _instance = WishlistManager._internal();

  factory WishlistManager() {
    return _instance;
  }

  WishlistManager._internal();

  final List<Product> _items = [];

  List<Product> get items => List.unmodifiable(_items);

  void toggleWishlist(Product product) {
    final index = _items.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      _items.removeAt(index);
    } else {
      _items.add(product);
    }
    notifyListeners();
  }

  bool isInWishlist(Product product) {
    return _items.any((item) => item.id == product.id);
  }

  void removeFromWishlist(Product product) {
    _items.removeWhere((item) => item.id == product.id);
    notifyListeners();
  }

  void clearWishlist() {
    _items.clear();
    notifyListeners();
  }
}
