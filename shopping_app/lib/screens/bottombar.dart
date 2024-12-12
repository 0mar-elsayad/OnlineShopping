import 'package:flutter/material.dart';
import 'package:shopping_app/screens/Home.dart';

class BottomBar extends StatefulWidget { 
  const BottomBar({super.key});
  
  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int selected = 0;

  // Pages corresponding to the BottomNavigationBar items
  final List<Widget> pagelist = [
    HomeScreen(),
    const Scaffold(),
    const Scaffold(body: Center(child: Text('Cart Page'))),
    const Scaffold(body: Center(child: Text('Profile Page'))),
  ];

  void selectedPage(int index) {
    setState(() {
      selected = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pagelist[selected],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selected,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: selectedPage,
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
