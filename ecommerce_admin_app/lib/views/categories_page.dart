import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin_app/views/add_category.dart';
import 'package:ecommerce_admin_app/views/UpdateCategoryPage.dart';
import 'package:ecommerce_admin_app/views/CategoryProductsPage.dart'; // Update Category Page
import 'dart:typed_data'; // For Base64 decoding

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  // Method to delete all products related to a category
  Future<void> _deleteCategoryAndProducts(BuildContext context, String categoryId, List products) async {
    try {
      // Create a batch for deleting products
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Delete all the products in the category
      for (var productId in products) {
        batch.delete(FirebaseFirestore.instance.collection('products').doc(productId));
      }

      // Commit the batch to delete the products
      await batch.commit();

      // Then delete the category itself
      await FirebaseFirestore.instance.collection('categories').doc(categoryId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Category and its products deleted")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete category and products: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('categories').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No categories available."));
          }

          final categories = snapshot.data!.docs;

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final categoryName = category['name'];
              final imageBase64 = category['imageBase64'];
              final products = category['products'] ?? [];

              return Dismissible(
                key: Key(category.id),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.startToEnd,
                confirmDismiss: (direction) async {
                  // Confirm before deleting
                  return await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Delete Category"),
                      content: Text("Are you sure you want to delete this category and its products?"),
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
                  );
                },
                onDismissed: (direction) async {
                  // Call the method to delete both the category and its associated products
                  await _deleteCategoryAndProducts(context, category.id, products);

                  // Refresh the UI after deletion
                  setState(() {});
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: imageBase64 != null
                        ? MemoryImage(base64Decode(imageBase64))
                        : null,
                    child: imageBase64 == null ? Icon(Icons.image) : null,
                  ),
                  title: Text(categoryName),
                  subtitle: Text("${products.length} products"),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Navigate to Update Category Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateCategoryPage(category.id),
                        ),
                      );
                    },
                  ),
                  onTap: () {
                    // Navigate to a category-specific product list
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryProductsPage(category.id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add Category Page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCategoryPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
