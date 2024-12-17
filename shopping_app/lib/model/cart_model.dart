class CartModel {
  String id; // Product ID
  String name;
  String price;
  String imageUrl;
  int quantity;
  int maxQuantity; // Maximum stock available

  CartModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.maxQuantity,
  });

  double get totalPrice => double.parse(price) * quantity;

  // Method to update quantity
  void updateQuantity(int newQuantity) {
    if (newQuantity <= maxQuantity) {
      quantity = newQuantity;
    }
  }
}
