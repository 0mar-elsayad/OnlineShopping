class CartModel {
  String name;
  String price;
  String imageUrl;
  int quantity;

  CartModel({
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });

  double get totalPrice => double.parse(price) * quantity;

  // Method to update quantity
  void updateQuantity(int newQuantity) {
    quantity = newQuantity;
  }
}
