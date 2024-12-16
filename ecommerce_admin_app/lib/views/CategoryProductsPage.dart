import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin_app/views/update_product.dart';

class CategoryProductsPage extends StatelessWidget {
  final String categoryId;

  CategoryProductsPage(this.categoryId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products in Category"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('categories').doc(categoryId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return Center(child: Text("No data available."));
          }

          final categoryData = snapshot.data!.data() as Map<String, dynamic>;
          final productIds = categoryData['products'] ?? [];

          if (productIds.isEmpty) {
            return Center(child: Text("No products in this category."));
          }

          return ListView.builder(
            itemCount: productIds.length,
            itemBuilder: (context, index) {
              final productId = productIds[index];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('products').doc(productId).get(),
                builder: (context, productSnapshot) {
                  if (productSnapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (productSnapshot.hasError || !productSnapshot.hasData || productSnapshot.data == null) {
                    return ListTile(title: Text("Error loading product"));
                  }

                  final productData = productSnapshot.data!.data() as Map<String, dynamic>;
                  final productName = productData['name'] ?? "Unknown Product";
                  final productPrice = productData['price'] ?? 0;
                  final productImageBase64 = productData['imageBase64'];
                  final productImage = productImageBase64 != null
                      ? MemoryImage(base64Decode(productImageBase64))
                      : null;

                  return ListTile(
                    leading: productImage != null
                        ? CircleAvatar(
                            backgroundImage: productImage,
                          )
                        : Icon(Icons.image),
                    title: Text(productName),
                    subtitle: Text("Price: \$${productPrice}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            // Navigate to the UpdateProductPage
                            _editProduct(context, productId);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            // Confirm deletion
                            final shouldDelete = await _confirmDelete(context, productName);
                            if (shouldDelete) {
                              _deleteProduct(productId, categoryId);
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context, String productName) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Delete Product"),
            content: Text("Are you sure you want to delete \"$productName\"?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text("Delete"),
              ),
            ],
          ),
        ) ?? false;
  }

  void _deleteProduct(String productId, String categoryId) async {
    try {
      // Remove product from Firestore
      await FirebaseFirestore.instance.collection('products').doc(productId).delete();

      // Remove product from the category's product list
      await FirebaseFirestore.instance.collection('categories').doc(categoryId).update({
        'products': FieldValue.arrayRemove([productId]),
      });

      print("Product deleted successfully.");
    } catch (e) {
      print("Error deleting product: $e");
    }
  }

  void _editProduct(BuildContext context, String productId) {
    // Navigate to the UpdateProductPage for the given productId
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateProductPage(productId: productId),
      ),
    );
  }
}
