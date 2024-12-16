import 'package:flutter/material.dart';

class Cartwidget extends StatelessWidget {
  final String name;
  final String price;
  final String imageUrl;
  final int quantity;

  const Cartwidget({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 45,
              backgroundImage: NetworkImage(imageUrl),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(name, style: const TextStyle(fontSize: 20)),
                Text("\$$price",
                    style: const TextStyle(fontSize: 18, color: Colors.blue)),
                Text("Quantity: $quantity"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
