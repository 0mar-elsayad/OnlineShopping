import 'package:flutter/material.dart';
import '../Widget/Cartwidget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
        ],
        title: Text(
          'My Cart',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ), // AppBar
      body: ListView.builder(
        itemCount: 4, // 4 items in cart
        itemBuilder: (context, index) {
          return Cartwidget(); // Reuse Cartwidget
        },
      ), // ListView.builder
    );
  }
}