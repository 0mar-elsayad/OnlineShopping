import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Addproduct extends StatefulWidget {
  const Addproduct({super.key});

  @override
  State<Addproduct> createState() => _AddproductState();
}

class _AddproductState extends State<Addproduct> {

File?pickedimage;

void uploadimage()async{
var image =await ImagePicker().pickImage(source: ImageSource.gallery);
var selected =File(image!.path);
if(image!=null){
  setState(() {
    pickedimage=selected;
  });
}

}

  final formkey = GlobalKey<FormState>();
  String category ='iphone';
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
                SizedBox(
                  height: 50,
                ),
                Text(
                  'Shopping-App',
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                ),
                SizedBox(
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
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)),
                          hintText: 'Title',
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty ) {
                            return 'Please enter a valid description';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)),
                          hintText: ' description',
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                        ),
                      ),
                      SizedBox(
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
                        decoration: InputDecoration(
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
                  SizedBox(height: 20,)

                , DropdownButtonHideUnderline(child: DropdownButton(
                  hint: Text('Select category') ,
                  onChanged: (value){
                    setState(() {
                      category=value!;
                    });

                  }, 
                  items: [
                    DropdownMenuItem(child: Text('Iphone'), 
                    value:'Iphone' ,)
                    , DropdownMenuItem(child: Text('Labtop'), 
                    value:'Labtop' ,)
                    , DropdownMenuItem(child: Text('Watch'), 
                    value:'Watch' ,)

                  ],
                  
                  ))

                , SizedBox(height: 30),

                TextButton(onPressed: (){
                  uploadimage();

                }, child:pickedimage == null ?Text('choose image'):Image.file(pickedimage!)) 
                
                , SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[900]),
                        onPressed: () {
                          formkey.currentState!.save();
                          if (formkey.currentState!.validate()) {}
                        },
                        child: Text(
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
