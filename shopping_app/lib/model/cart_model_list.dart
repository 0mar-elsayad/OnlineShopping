import 'package:flutter/material.dart';
import 'cart_model.dart';

class CartModelList extends ChangeNotifier {
  final List<CartModel> _cartItems = [];

  List<CartModel> get cartItems => _cartItems;

  double get totalPrice =>
      _cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  // Add to cart
  void add(CartModel item) {
    _cartItems.add(item);
    notifyListeners();
  }

  // Remove from cart
  void remove(CartModel item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  // Update the quantity of a product in the cart
  void updateQuantity(CartModel item, int newQuantity) {
    item.updateQuantity(newQuantity);
    notifyListeners();
  }
}
