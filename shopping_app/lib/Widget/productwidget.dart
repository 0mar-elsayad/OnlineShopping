import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/model/cart_model.dart';
import 'package:shopping_app/model/cart_model_list.dart';

class Productwidget extends StatefulWidget {
  final String id; // Product ID
  final String name;
  final String price;
  final String imageUrl;
  final int maxQuantity; // Max quantity in stock

  const Productwidget({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.maxQuantity,
  });

  @override
  _ProductwidgetState createState() => _ProductwidgetState();
}

class _ProductwidgetState extends State<Productwidget> {
  int selectedQuantity = 1;

  void _incrementQuantity() {
    setState(() {
      if (selectedQuantity < widget.maxQuantity) {
        selectedQuantity++;
      }
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (selectedQuantity > 1) {
        selectedQuantity--;
      }
    });
  }

  void _addToCart() {
    final cart = Provider.of<CartModelList>(context, listen: false);

    cart.add(
      CartModel(
        id: widget.id,
        name: widget.name,
        price: widget.price,
        imageUrl: widget.imageUrl,
        quantity: selectedQuantity,
        maxQuantity: widget.maxQuantity,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${widget.name} added to cart!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(widget.imageUrl, fit: BoxFit.cover),
            ),
          ),
          // Product Name and Price
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "\$${widget.price}",
                  style: const TextStyle(color: Colors.blueAccent, fontSize: 14),
                ),
                // Quantity Adjuster
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: _decrementQuantity,
                      icon: const Icon(Icons.remove),
                    ),
                    Text(
                      "Quantity: $selectedQuantity",
                      style: const TextStyle(fontSize: 14),
                    ),
                    IconButton(
                      onPressed: _incrementQuantity,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                // Add to Cart Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _addToCart,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                    child: const Text(
                      "Add to Cart",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
