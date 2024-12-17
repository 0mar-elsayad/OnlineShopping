import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Widget/productwidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController; // Controller for TabBar
  List<String> _categories = []; // List to hold dynamic categories

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  /// Fetch categories dynamically from Firestore
  Future<void> _fetchCategories() async {
    final categoriesSnapshot =
        await FirebaseFirestore.instance.collection('categories').get();

    setState(() {
      // Add "All" as the default category
      _categories = ['All', ...categoriesSnapshot.docs.map((doc) => doc['name']).toList()];
      _tabController = TabController(length: _categories.length, vsync: this);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home Screen'),
          backgroundColor: Colors.blueAccent,
          bottom: _categories.isEmpty
              ? null
              : TabBar(
                  controller: _tabController,
                  isScrollable: true, // Allows dynamic tabs to scroll if needed
                  tabs: _categories.map((category) => Tab(text: category)).toList(),
                ),
        ),
        body: _categories.isEmpty
            ? const Center(child: CircularProgressIndicator()) // Show loader while categories load
            : TabBarView(
                controller: _tabController,
                children: _categories.map((category) {
                  return _buildProductList(category: category);
                }).toList(),
              ),
      ),
    );
  }

  /// Build product list filtered by category
   Widget _buildProductList({required String category}) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
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

        // Filter products based on category and quantity > 0
        final filteredProducts = snapshot.data!.docs.where((product) {
          final productCategory = product['category'] ?? '';
          final productQuantity = product['quantity'] ?? 0;
          return (category == 'All' || productCategory == category) && productQuantity > 0;
        }).toList();

        if (filteredProducts.isEmpty) {
          return const Center(child: Text("No products available."));
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
            final productName = product['name'] ?? 'No Name';
            final productPrice = product['price']?.toString() ?? '0';
            final productQuantity = product['quantity'] ?? 0;
            final imageBase64 = product['imageBase64'];

            // Decode Base64 image or use placeholder
            final productImageUrl = imageBase64 != null
                ? "data:image/png;base64,$imageBase64"
                : 'https://via.placeholder.com/150';

            return Productwidget(
              id: product.id, // Pass product ID
              name: productName,
              price: productPrice,
              imageUrl: productImageUrl,
              maxQuantity: productQuantity, // Limit user selection to database quantity
            );
          },
        );
      },
    );
  }
}
