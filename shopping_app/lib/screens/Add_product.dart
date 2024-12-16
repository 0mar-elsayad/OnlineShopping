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

  void uploadimage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    var selected = File(image!.path);
    setState(() {
      pickedimage = selected;
    });
  }

  final formkey = GlobalKey<FormState>();
  String category = 'iphone';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  'Shopping-App',
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 50,
                ),
                Form(
                  key: formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a valid title';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)),
                          hintText: 'Title',
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a valid description';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)),
                          hintText: ' description',
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'enter price';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)),
                          hintText: 'price',
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                DropdownButtonHideUnderline(
                    child: DropdownButton(
                  hint: const Text('Select category'),
                  onChanged: (value) {
                    setState(() {
                      category = value!;
                    });
                  },
                  items: const [
                    DropdownMenuItem(
                      value: 'Iphone',
                      child: Text('Iphone'),
                    ),
                    DropdownMenuItem(
                      value: 'Labtop',
                      child: Text('Labtop'),
                    ),
                    DropdownMenuItem(
                      value: 'Watch',
                      child: Text('Watch'),
                    )
                  ],
                )),
                const SizedBox(height: 30),
                TextButton(
                    onPressed: () {
                      uploadimage();
                    },
                    child: pickedimage == null
                        ? const Text('choose image')
                        : Image.file(pickedimage!)),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[900]),
                        onPressed: () {
                          formkey.currentState!.save();
                          if (formkey.currentState!.validate()) {}
                        },
                        child: const Text(
                          'Upload ',
                          style: TextStyle(color: Colors.white),
                        ))),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
