import 'package:flutter/material.dart';
import 'package:shopping_app/Widget/productwidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final List<Map<String, String>> products = [
    {
      'name': 'iPhone 13',
      'price': '3500',
      'category': 'Mobiles',
      'imageUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQtkScJu7uJWUM2HXMluAkmnXHMvWeSoepePg&s',
    },
    {
      'name': 'MacBook Air',
      'price': '1200',
      'category': 'Laptops',
      'imageUrl':
          'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/mba13-midnight-select-202402?wid=904&hei=840&fmt=jpeg&qlt=90&.v=1708367688034,'
    },
    {
      'name': 'Apple Watch',
      'price': '400',
      'category': 'Watches',
      'imageUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTxc_mmycGKjssaK86jb1uoEGK2POQhHLtLWA&s',
    },
    {
      'name': 'iPad Pro',
      'price': '800',
      'category': 'Mobiles',
      'imageUrl':
          'https://m.media-amazon.com/images/I/71vg3LNWBTL._AC_SL1500_.jpg'
    },
    {
      'name': 'AirPods',
      'price': '250',
      'category': 'Watches',
      'imageUrl':
          'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/MQD83_AV2?wid=1144&hei=1144&fmt=jpeg&qlt=95&.v=1660803960086',
    },
  ];

  List<Map<String, String>> filteredProducts = [];
  double _totalPrice = 0.0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    filteredProducts = products;
    _tabController = TabController(length: 4, vsync: this);  // Number of tabs for categories
  }

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

  void _filterProducts(String category) {
    setState(() {
      if (category == 'All') {
        filteredProducts = products;
      } else {
        filteredProducts = products
            .where((product) => product['category'] == category)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home Screen'),
          backgroundColor: Colors.blueAccent,
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Mobiles'),
              Tab(text: 'Accessories'),
              Tab(text: 'Laptops'),
            ],
            onTap: (index) {
              // Update the product list based on selected tab
              switch (index) {
                case 0:
                  _filterProducts('All');
                  break;
                case 1:
                  _filterProducts('Mobiles');
                  break;
                case 2:
                  _filterProducts('Watches');
                  break;
                case 3:
                  _filterProducts('Laptops');
                  break;
              }
            },
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            // Product Grid Section
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Show all products
                  _buildProductGrid(filteredProducts),
                  // Tab 2: Show Mobiles
                  _buildProductGrid(products.where((product) => product['category'] == 'Mobiles').toList()),
                  // Tab 3: Show Watches
                  _buildProductGrid(products.where((product) => product['category'] == 'Watches').toList()),
                  // Tab 4: Show Laptops
                  _buildProductGrid(products.where((product) => product['category'] == 'Laptops').toList()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGrid(List<Map<String, String>> products) {
    return GridView.count(
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
    );
  }
}