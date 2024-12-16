import 'dart:convert';
import 'dart:typed_data';
import 'dart:io'; // For File
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedCategory;
  List<String> _categories = [];
  String? _imageBase64;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final snapshot = await FirebaseFirestore.instance.collection('categories').get();
    final categoryNames = snapshot.docs.map((doc) => doc['name'] as String).toList();
    setState(() {
      _categories = categoryNames;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBase64 = base64Encode(bytes);
      });
    }
  }

  Future<void> _saveProduct() async {
    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim());
    final quantity = int.tryParse(_quantityController.text.trim());
    final description = _descriptionController.text.trim();

    if (name.isEmpty || price == null || quantity == null || _selectedCategory == null || _imageBase64 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields and select an image")),
      );
      return;
    }

    // Add product to Firestore
    final productRef = await FirebaseFirestore.instance.collection('products').add({
      'name': name,
      'price': price,
      'quantity': quantity,
      'description': description,
      'category': _selectedCategory,
      'imageBase64': _imageBase64,
    });

    // Update the category's products list
    final categorySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .where('name', isEqualTo: _selectedCategory)
        .get();

    if (categorySnapshot.docs.isNotEmpty) {
      final categoryDoc = categorySnapshot.docs.first;
      final products = List.from(categoryDoc['products'] ?? []);
      products.add(productRef.id);

      await FirebaseFirestore.instance.collection('categories').doc(categoryDoc.id).update({
        'products': products,
      });
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Product")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: _nameController, decoration: InputDecoration(labelText: "Name")),
              TextField(controller: _descriptionController, decoration: InputDecoration(labelText: "Description")),
              TextField(controller: _priceController, decoration: InputDecoration(labelText: "Price")),
              TextField(controller: _quantityController, decoration: InputDecoration(labelText: "Quantity")),
              DropdownButton<String>(
                value: _selectedCategory,
                hint: Text("Select Category"),
                onChanged: (newValue) => setState(() => _selectedCategory = newValue),
                items: _categories.map((category) => DropdownMenuItem(value: category, child: Text(category))).toList(),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text("Select Image"),
              ),
              if (_imageBase64 != null)
                Container(
                  height: 150,
                  margin: EdgeInsets.only(top: 10),
                  child: Image.memory(base64Decode(_imageBase64!)),
                ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _saveProduct, child: Text("Save Product")),
            ],
          ),
        ),
      ),
    );
  }
}