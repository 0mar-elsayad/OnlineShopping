import 'package:flutter/material.dart';
import 'package:shopping_app/Widget/productwidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> products = [
    {
      'name': 'iPhone 13',
      'price': '3500',
      'imageUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQtkScJu7uJWUM2HXMluAkmnXHMvWeSoepePg&s',
    },
    {
      'name': 'MacBook Air',
      'price': '1200',
      'imageUrl':
          'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/mba13-midnight-select-202402?wid=904&hei=840&fmt=jpeg&qlt=90&.v=1708367688034,'
    },
    {
      'name': 'Apple Watch',
      'price': '400',
      'imageUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTxc_mmycGKjssaK86jb1uoEGK2POQhHLtLWA&s',
    },
    {
      'name': 'iPad Pro',
      'price': '800',
      'imageUrl':
          'https://m.media-amazon.com/images/I/71vg3LNWBTL._AC_SL1500_.jpg'
    },
    {
      'name': 'AirPods',
      'price': '250',
      'imageUrl':
          'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/MQD83_AV2?wid=1144&hei=1144&fmt=jpeg&qlt=95&.v=1660803960086',
    },
  ];

  double _totalPrice = 0.0;

  void _updateTotalPrice(double price) {
    setState(() {
      _totalPrice += price;
    });
  }

  void _decreaseTotalPrice(double price) {
    setState(() {
      _totalPrice -= price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home Screen'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text(
                "E_commerce",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              // Product Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 4.5 / 7,
                  children: products.map((product) {
                    return Productwidget(
                      name: product['name']!,
                      price: product['price']!,
                      imageUrl: product['imageUrl']!,
                    );
                  }).toList(),
                ),
              ),
              // Total Price Display
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Total Price: \$$_totalPrice",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
