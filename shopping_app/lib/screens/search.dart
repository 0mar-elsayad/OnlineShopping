import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import '../Widget/productwidget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchQuery = ""; // User input for search

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search Products'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Search bar input
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search for a product',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
                onChanged: (query) {
                  setState(() {
                    searchQuery = query; // Update search query
                  });
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('products')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("No products available."));
                    }

                    // Filter products based on search query and quantity > 0
                    final filteredProducts = snapshot.data!.docs.where((doc) {
                      final name = doc['name']?.toString().toLowerCase() ?? '';
                      final quantity = doc['quantity'] ?? 0;
                      return name.contains(searchQuery.toLowerCase()) &&
                             quantity > 0; // Exclude products with quantity = 0
                    }).toList();

                    if (filteredProducts.isEmpty) {
                      return const Center(child: Text("No matching products found."));
                    }

                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 4.5 / 7,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];

                        // Safely access Firestore fields
                        final productName = product['name'] ?? 'No Name';
                        final productPrice = product['price']?.toString() ?? '0';
                        final productImageBase64 = product['imageBase64'];

                        // Decode Base64 image if available, otherwise use placeholder
                        final productImage = productImageBase64 != null
                            ? Image.memory(
                                base64Decode(productImageBase64),
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                'https://via.placeholder.com/150', // Placeholder image
                                fit: BoxFit.cover,
                              );

                        return Productwidget(
                          id: product.id,
                          name: productName,
                          price: productPrice,
                          imageUrl: productImageBase64 != null
                              ? "data:image/png;base64,$productImageBase64"
                              : 'https://via.placeholder.com/150',
                          maxQuantity: product['quantity'] ?? 0,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
