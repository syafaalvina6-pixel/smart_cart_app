import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> items = [];

  int get itemCount => items.fold(0, (s, i) => s + i.quantity);

  int get totalPrice => items.fold(0, (s, i) => s + (i.product.price * i.quantity));

  void addToCart(Product p) {
    final idx = items.indexWhere((i) => i.product.id == p.id);
    idx >= 0 ? items[idx].quantity++ : items.add(CartItem(product: p));
    notifyListeners();
  }

  void incrementItem(String id) {
    final idx = items.indexWhere((i) => i.product.id == id);
    if (idx >= 0) {
      items[idx].quantity++;
      notifyListeners();
    }
  }

  void decrementItem(String id) {
    final idx = items.indexWhere((i) => i.product.id == id);
    if (idx >= 0) {
      items[idx].quantity > 1 ? items[idx].quantity-- : items.removeAt(idx);
      notifyListeners();
    }
  }
}