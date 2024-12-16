import 'dart:convert'; // For Base64 encoding
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // For handling files
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateCategoryPage extends StatefulWidget {
  final String categoryId;

  UpdateCategoryPage(this.categoryId);

  @override
  _UpdateCategoryPageState createState() => _UpdateCategoryPageState();
}

class _UpdateCategoryPageState extends State<UpdateCategoryPage> {
  final TextEditingController _categoryNameController = TextEditingController();
  File? _selectedImageFile;
  Uint8List? _selectedImageBytes;
  String? _currentBase64Image;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCategoryData();
  }

  Future<void> _loadCategoryData() async {
    final doc = await FirebaseFirestore.instance.collection('categories').doc(widget.categoryId).get();
    final data = doc.data();

    if (data != null) {
      setState(() {
        _categoryNameController.text = data['name'];
        _currentBase64Image = data['imageBase64'];
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
        });
      } else {
        setState(() {
          _selectedImageFile = File(pickedFile.path);
        });
      }
    }
  }

  Future<void> _updateCategory() async {
    final name = _categoryNameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please provide a category name")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String? updatedBase64Image = _currentBase64Image;

      if (_selectedImageFile != null || _selectedImageBytes != null) {
        final bytes = kIsWeb
            ? _selectedImageBytes
            : await _selectedImageFile!.readAsBytes();
        updatedBase64Image = base64Encode(bytes!);
      }

      await FirebaseFirestore.instance.collection('categories').doc(widget.categoryId).update({
        'name': name,
        'imageBase64': updatedBase64Image,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Category updated successfully")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update category: $e")),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update Category")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _categoryNameController,
              decoration: InputDecoration(labelText: "Category Name"),
            ),
            SizedBox(height: 16),
            _currentBase64Image != null
                ? Image.memory(base64Decode(_currentBase64Image!), width: 100, height: 100)
                : Container(height: 100, width: 100, color: Colors.grey),
            TextButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.add_a_photo),
              label: Text("Select Image"),
            ),
            SizedBox(height: 16),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _updateCategory,
                    child: Text("Update Category"),
                  ),
          ],
        ),
      ),
    );
  }
}
