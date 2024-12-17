import 'package:flutter/material.dart';
import 'cart_model.dart';

class CartModelList extends ChangeNotifier {
  final List<CartModel> _cartItems = [];

  List<CartModel> get cartItems => _cartItems;

  double get totalPrice => _cartItems.fold(
        0,
        (total, item) => total + item.totalPrice,
      );

  // Add product to cart
  void add(CartModel item) {
    final existingItem =
        _cartItems.firstWhere((product) => product.id == item.id, orElse: () => CartModel(id: '', name: '', price: '', imageUrl: '', quantity: 0, maxQuantity: 0));
    if (existingItem.id.isEmpty) {
      _cartItems.add(item);
    } else {
      existingItem.updateQuantity(existingItem.quantity + item.quantity);
    }
    notifyListeners();
  }

  // Update the quantity of an item
  void updateQuantity(CartModel item, int newQuantity) {
    if (newQuantity > 0 && newQuantity <= item.maxQuantity) {
      item.updateQuantity(newQuantity);
      notifyListeners();
    }
  }

  // Remove an item from the cart
  void remove(CartModel item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  // Clear the cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
