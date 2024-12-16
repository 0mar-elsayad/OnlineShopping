import 'dart:convert'; // To encode image as Base64
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // To handle files
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCategoryPage extends StatefulWidget {
  @override
  _AddCategoryPageState createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final TextEditingController _categoryNameController = TextEditingController();
  File? _selectedImageFile;
  Uint8List? _selectedImageBytes; // For web compatibility
  bool _isLoading = false;

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        // For Web: Use image bytes
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
        });
      } else {
        // For Mobile: Use File
        setState(() {
          _selectedImageFile = File(pickedFile.path);
        });
      }
    }
  }

  // Function to convert the image to Base64
  Future<String> _convertImageToBase64() async {
    if (kIsWeb && _selectedImageBytes != null) {
      return base64Encode(_selectedImageBytes!);
    } else if (_selectedImageFile != null) {
      final bytes = await _selectedImageFile!.readAsBytes();
      return base64Encode(bytes);
    } else {
      throw Exception("No image selected");
    }
  }

  // Function to save the category data to Firestore
  Future<void> _saveCategory() async {
    final name = _categoryNameController.text.trim();

    if (name.isEmpty || (_selectedImageFile == null && _selectedImageBytes == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please provide a category name and select an image")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Convert the selected image to Base64
      final base64Image = await _convertImageToBase64();

      // Save the category with Base64 image to Firestore
      await FirebaseFirestore.instance.collection('categories').add({
        'name': name,
        'imageBase64': base64Image,
        'products': [], // Initialize with an empty list
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Category added successfully")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Category")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _categoryNameController,
              decoration: InputDecoration(labelText: "Category Name"),
            ),
            SizedBox(height: 16),
            // Display image preview
            kIsWeb
                ? (_selectedImageBytes != null
                    ? Image.memory(_selectedImageBytes!, width: 100, height: 100, fit: BoxFit.cover)
                    : SizedBox(height: 100, width: 100, child: Icon(Icons.image, size: 50)))
                : (_selectedImageFile != null
                    ? Image.file(_selectedImageFile!, width: 100, height: 100, fit: BoxFit.cover)
                    : SizedBox(height: 100, width: 100, child: Icon(Icons.image, size: 50))),
            TextButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.add_a_photo),
              label: Text("Select Image"),
            ),
            SizedBox(height: 16),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _saveCategory,
                    child: Text("Save Category"),
                  ),
          ],
        ),
      ),
    );
  }
}
