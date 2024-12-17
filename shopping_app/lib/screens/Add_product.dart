import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Addproduct extends StatefulWidget {
  const Addproduct({super.key});

  @override
  State<Addproduct> createState() => _AddproductState();
}

class _AddproductState extends State<Addproduct> {
  File? pickedimage;
  String category = 'iphone'; // Default category

  // Sample list of categories
  final List<String> categories = ['iPhone', 'Laptop', 'Watch', 'Tablet', 'Accessories'];

  // Function to upload image
  void uploadimage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        pickedimage = File(image.path);
      });
    }
  }

  // Form key for validation
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text('Shopping-App', style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
              const SizedBox(height: 50),
              Form(
                key: formkey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Product Title'),
                      validator: (value) => value!.isEmpty ? 'Enter a title' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Description'),
                      validator: (value) => value!.isEmpty ? 'Enter a description' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Price'),
                      validator: (value) => value!.isEmpty ? 'Enter a price' : null,
                    ),
                    const SizedBox(height: 20),
                    DropdownButton<String>(
                      value: category,
                      onChanged: (value) {
                        setState(() {
                          category = value!;
                        });
                      },
                      items: categories.map((cat) {
                        return DropdownMenuItem<String>(
                          value: cat,
                          child: Text(cat),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 30),
                    TextButton(
                      onPressed: uploadimage,
                      child: pickedimage == null
                          ? const Text('Choose Image')
                          : Image.file(pickedimage!),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          // Add product logic
                        }
                      },
                      child: const Text('Add Product'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
