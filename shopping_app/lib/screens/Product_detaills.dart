import 'package:flutter/material.dart';
import 'package:shopping_app/Widget/Elevatedbotton.dart';
import 'package:shopping_app/screens/CartScreen.dart';

class Productdetaills extends StatelessWidget {
  const Productdetaills({super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 40,
              ),
              Image.network(
                'https://www.dslr-zone.com/wp-content/uploads/2021/10/1-2.jpeg',
                width: double.infinity,
                height: height * 0.5,
              ),
              Text(
                'Iphone',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 25,
              ),
              Text('Iphone pro max', style: TextStyle(fontSize: 16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('4000', style: TextStyle(fontSize: 16)),
                  ElevatedWidget(
                      title: 'add to cart',
                      color: Colors.blue,
                      function: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CartScreen()),
                        );
                      })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
