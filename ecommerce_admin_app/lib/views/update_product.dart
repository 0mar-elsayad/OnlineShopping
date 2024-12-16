import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProductPage extends StatefulWidget {
  final String productId;

  UpdateProductPage({required this.productId});

  @override
  _UpdateProductPageState createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedCategory;
  List<String> _categories = [];
  String? _imageBase64;
  String? _existingImageBase64;  // To store the existing image

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchProductDetails();
  }

  // Fetch product details for editing
  Future<void> _fetchProductDetails() async {
    final productDoc = await FirebaseFirestore.instance.collection('products').doc(widget.productId).get();
    if (productDoc.exists) {
      final productData = productDoc.data()!;
      _nameController.text = productData['name'];
      _priceController.text = productData['price'].toString();
      _quantityController.text = productData['quantity'].toString();
      _descriptionController.text = productData['description'];
      _selectedCategory = productData['category'];
      _existingImageBase64 = productData['imageBase64'];  // Store the existing image
      setState(() {
        _imageBase64 = _existingImageBase64;  // Initially show the existing image
      });
    }
  }

  // Fetch the categories from Firestore
  Future<void> _fetchCategories() async {
    final snapshot = await FirebaseFirestore.instance.collection('categories').get();
    final categoryNames = snapshot.docs.map((doc) => doc['name'] as String).toList();
    setState(() {
      _categories = categoryNames;
    });
  }

  // Pick an image from the gallery
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

  // Save the updated product
  Future<void> _saveProduct() async {
    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim());
    final quantity = int.tryParse(_quantityController.text.trim());
    final description = _descriptionController.text.trim();

    if (name.isEmpty || price == null || quantity == null || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields and select an image")),
      );
      return;
    }

    // If no new image is selected, retain the old image
    final finalImageBase64 = _imageBase64 ?? _existingImageBase64;

    // Update product in Firestore
    await FirebaseFirestore.instance.collection('products').doc(widget.productId).update({
      'name': name,
      'price': price,
      'quantity': quantity,
      'description': description,
      'category': _selectedCategory,
      'imageBase64': finalImageBase64,  // Save the new or old image
    });

    Navigator.pop(context);  // Go back after saving
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update Product")),
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
              if (_imageBase64 != null || _existingImageBase64 != null)
                Container(
                  height: 150,
                  margin: EdgeInsets.only(top: 10),
                  child: Image.memory(base64Decode(_imageBase64 ?? _existingImageBase64!)),
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
