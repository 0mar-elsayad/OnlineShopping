import 'package:flutter/material.dart';
import 'cart_model.dart';

// cart_model_list.dart

class CartModelList extends ChangeNotifier {
  final List<CartModel> _cartItems = [];

  List<CartModel> get cartItems => _cartItems;

  double get totalPrice =>
      _cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  // Add to cart (Update quantity if already exists)
  void add(CartModel item) {
    // Check if item already exists in cart
    final existingItemIndex = _cartItems.indexWhere((cartItem) => cartItem.name == item.name);

    if (existingItemIndex != -1) {
      // If item exists, update quantity
      _cartItems[existingItemIndex].updateQuantity(_cartItems[existingItemIndex].quantity + item.quantity);
    } else {
      // If item doesn't exist, add new item
      _cartItems.add(item);
    }
  print("Cart Items: ${_cartItems.map((e) => e.name)}"); // Debugging
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

  // Remove all items from the cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
