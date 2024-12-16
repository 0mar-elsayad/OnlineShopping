import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin_app/views/add_product.dart'; // Navigate to AddProductPage
import 'package:ecommerce_admin_app/views/update_product.dart'; // Navigate to UpdateProductPage
import 'dart:convert';

class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProductPage()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No products available."));
          }

          final products = snapshot.data!.docs;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final productName = product['name'];
              final productPrice = product['price'].toString();
              final imageBase64 = product['imageBase64'];
              final productCategory = product['category'];

              return ListTile(
                leading: imageBase64 != null
                    ? Image.memory(
                        base64Decode(imageBase64),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.image),
                title: Text(productName),
                subtitle: Text("Price: \$${productPrice}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateProductPage(productId: product.id),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final shouldDelete = await _confirmDelete(context, productName);
                        if (shouldDelete) {
                          _deleteProduct(product.id, productCategory);
                        }
                      },
                    ),
                  ],
                ),
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
              TextButton(onPressed: () => Navigator.pop(context, false), child: Text("Cancel")),
              TextButton(onPressed: () => Navigator.pop(context, true), child: Text("Delete")),
            ],
          ),
        ) ??
        false;
  }

  void _deleteProduct(String productId, String categoryName) async {
    try {
      // Delete product from Firestore
      await FirebaseFirestore.instance.collection('products').doc(productId).delete();

      // Remove product ID from the related category's product list
      final categorySnapshot = await FirebaseFirestore.instance
          .collection('categories')
          .where('name', isEqualTo: categoryName)
          .get();

      if (categorySnapshot.docs.isNotEmpty) {
        final categoryDoc = categorySnapshot.docs.first;
        final products = List.from(categoryDoc['products'] ?? []);
        products.remove(productId);

        await FirebaseFirestore.instance.collection('categories').doc(categoryDoc.id).update({
          'products': products,
        });
      }
    } catch (e) {
      print("Error deleting product: $e");
    }
  }
}