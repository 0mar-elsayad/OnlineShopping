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
  int selected = 0;

  // Pages corresponding to the BottomNavigationBar items
  final List<Widget> pagelist = [
    const HomeScreen(),
     SearchScreen(),
    const CartScreen(),
    ProfileScreen()
  ];

  void selectedPage(int index) {
  print('User selected tab: $index'); // Logs the selected tab
  setState(() {
    selected = index;
  });
}

@override
Widget build(BuildContext context) {
  print('Building BottomBar with selected index: $selected'); // Logs the selected index
  return Scaffold(
    body: IndexedStack(
      index: selected,
      children: pagelist.map((page) {
        print('Rendering page: ${page.runtimeType}'); // Logs the page type
        return page;
      }).toList(),
    ),
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