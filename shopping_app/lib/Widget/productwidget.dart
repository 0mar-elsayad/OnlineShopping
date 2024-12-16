import 'package:flutter/material.dart';
import 'package:shopping_app/model/cart_model.dart';
import 'package:shopping_app/model/cart_model_list.dart';
import 'package:provider/provider.dart'; // Import provider

class Productwidget extends StatefulWidget {
  final String name;
  final String price;
  final String imageUrl;

  const Productwidget({
    required this.name,
    required this.price,
    required this.imageUrl,
    super.key,
  });

  @override
  _ProductwidgetState createState() => _ProductwidgetState();
}

class _ProductwidgetState extends State<Productwidget> {
  int _productCount = 0;

  void _addToCart() {
    if (_productCount > 0) {
      final CartModel newProduct = CartModel(
        name: widget.name,
        price: widget.price,
        imageUrl: widget.imageUrl,
        quantity: _productCount,
      );

      final cart = Provider.of<CartModelList>(context, listen: false);
      cart.add(newProduct);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.name} added to cart!')),
      );
    }
  }

  void _incrementCounter() {
    setState(() {
      _productCount++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_productCount > 0) _productCount--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Image.network(widget.imageUrl),
          Text(widget.name, style: const TextStyle(fontSize: 20)),
          Text("\$${widget.price}",
              style: const TextStyle(fontSize: 18, color: Colors.blue)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: _incrementCounter, icon: const Icon(Icons.add)),
              Text("Quantity: $_productCount"),
              IconButton(
                  onPressed: _decrementCounter, icon: const Icon(Icons.remove)),
            ],
          ),
          ElevatedButton(
            onPressed: () => _addToCart(),
            child: const Text("Add to Cart"),
          ),
        ],
      ),
    );
  }
}
