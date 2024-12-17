import 'package:flutter/material.dart';
import 'package:shopping_app/screens/CartScreen.dart';
import 'package:shopping_app/screens/Home.dart';
import 'package:shopping_app/screens/profileScreen.dart';
import 'package:shopping_app/screens/search.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int selectedIndex = 0;

  // Pages corresponding to the BottomNavigationBar items
  final List<Widget> pages = [
    const HomeScreen(),  // Home Page
    const SearchScreen(),  // Search Page
    const CartScreen(),   // Cart Page
    const ProfileScreen() // Profile Page
  ];

  // Function to handle tab changes
  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Colors.blue, // Active tab color
        unselectedItemColor: Colors.grey, // Inactive tab color
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
