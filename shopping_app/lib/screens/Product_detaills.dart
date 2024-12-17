import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app/model/cart_model.dart';
import 'package:shopping_app/model/cart_model_list.dart';

class ProductDetails extends StatefulWidget {
  final String productId;

  const ProductDetails({super.key, required this.productId});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Map<String, dynamic>? productData;
  int selectedQuantity = 1;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
  }

  // Fetch product details from Firestore
  Future<void> fetchProductDetails() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .get();

      if (docSnapshot.exists) {
        setState(() {
          productData = docSnapshot.data();
          isLoading = false;
        });
      } else {
        throw Exception("Product not found.");
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  // Add product to cart
void addToCart() async {
  final cart = Provider.of<CartModelList>(context, listen: false);

  // Check if selected quantity exceeds available stock
  if (selectedQuantity > (productData?['quantity'] ?? 0)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Not enough stock available!")),
    );
    return;
  }

  // Add the product to the cart locally
  final productToAdd = CartModel(
    id: widget.productId,
    name: productData?['name'] ?? 'No Name',
    price: productData?['price'].toString() ?? '0',
    imageUrl: productData?['imageBase64'] != null
        ? "data:image/png;base64,${productData!['imageBase64']}"
        : 'https://via.placeholder.com/150',
    quantity: selectedQuantity,
    maxQuantity: productData?['quantity'] ?? 0,
  );
  cart.add(productToAdd);

  // Calculate total for this product
  final productTotal = selectedQuantity *
      double.parse(productData?['price']?.toString() ?? '0');

  try {
    // Add an order to Firestore with product details
    await FirebaseFirestore.instance.collection('orders').add({
      "orderItems": [
        {
          "name": productData?['name'] ?? 'No Name',
          "price": productData?['price']?.toString() ?? '0',
          "productId": widget.productId,
          "quantity": selectedQuantity,
          "status": "Pending",
          "total": productTotal,
        }
      ],
      "status": "Pending", 
      "timestamp": Timestamp.now(),
      "totalAmount": productTotal,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Product added to cart and order created!")),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error creating order: $e")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (productData == null) {
      return const Scaffold(
        body: Center(child: Text("Product not found.")),
      );
    }

    final imageWidget = productData?['imageBase64'] != null
        ? Image.memory(
            base64Decode(productData!['imageBase64']),
            fit: BoxFit.cover,
            height: 300,
            width: double.infinity,
          )
        : Image.network(
            'https://via.placeholder.com/150',
            fit: BoxFit.cover,
            height: 300,
            width: double.infinity,
          );

    return Scaffold(
      appBar: AppBar(
        title: Text(productData?['name'] ?? "Product Details"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageWidget,
            ),
            const SizedBox(height: 20),

            // Product Name
            Text(
              productData?['name'] ?? "No Name",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Price
            Text(
              "Price: \$${productData?['price'] ?? '0'}",
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
            const SizedBox(height: 10),

            // Stock Quantity
            Text(
              "Available Stock: ${productData?['quantity'] ?? 0}",
              style: const TextStyle(fontSize: 16, color: Colors.redAccent),
            ),
            const SizedBox(height: 20),

            // Quantity Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Select Quantity:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (selectedQuantity > 1) {
                          setState(() => selectedQuantity--);
                        }
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text(
                      '$selectedQuantity',
                      style: const TextStyle(fontSize: 18),
                    ),
                    IconButton(
                      onPressed: () {
                        if (selectedQuantity <
                            (productData?['quantity'] ?? 0)) {
                          setState(() => selectedQuantity++);
                        }
                      },
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Add to Cart Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
