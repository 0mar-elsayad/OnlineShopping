import 'package:flutter/material.dart';
import 'package:shopping_app/Widget/Elevatedbotton.dart';
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
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 4, // 4 items in cart
              itemBuilder: (context, index) {
                return Cartwidget(); // Reuse Cartwidget
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '50000.00',
                  style: TextStyle(fontSize: 22),
                ),
                ElevatedWidget(
                  title: 'check out',
                  color: Colors.blue,
                  function: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}