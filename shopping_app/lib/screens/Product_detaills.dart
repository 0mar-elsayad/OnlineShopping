import 'package:flutter/material.dart';
import 'package:shopping_app/Widget/Elevatedbotton.dart';
import 'package:shopping_app/screens/CartScreen.dart';

class Productdetaills extends StatelessWidget {
  const Productdetaills({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView( // Allows content to scroll if necessary
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                // Product Image
                Image.network(
                  'https://www.dslr-zone.com/wp-content/uploads/2021/10/1-2.jpeg',
                  width: double.infinity,
                  height: screenHeight * 0.4, // Dynamic height
                  fit: BoxFit.contain, // Ensures the image scales correctly
                ),
                SizedBox(height: 20),

                // Product Title
                Text(
                  'Iphone',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),

                // Product Description
                Text(
                  'Iphone pro max',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 20),

                // Price and Add to Cart Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Price
                    Text(
                      '\$4000',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    // Add to Cart Button
                    ElevatedWidget(
                      title: 'Add to Cart',
                      color: Colors.blue,
                      function: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CartScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}