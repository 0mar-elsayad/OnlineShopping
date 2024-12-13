import 'package:flutter/material.dart';

class ListtileWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function function;

  const ListtileWidget(
      {super.key,
      required this.title,
      required this.icon,
      required this.function});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 25, fontWeight: (FontWeight.bold)),
      ),
      leading: Icon(icon),
      trailing: IconButton(
        onPressed: () {
          print("Hello World");
          function();
        },
        icon: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
