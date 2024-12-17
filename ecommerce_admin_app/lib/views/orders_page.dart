import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Listening to the orders collection in Firestore
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No orders available."));
          }

          // List of orders fetched from Firestore
          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final orderId = order.id;
              final orderDate = order['date'] ?? "Unknown Date";
              final customerName = order['customerName'] ?? "Unknown Customer";
              final orderStatus = order['status'] ?? "Unknown Status";

              return ListTile(
                title: Text("Order ID: $orderId"),
                subtitle: Text("Customer: $customerName\nDate: $orderDate\nStatus: $orderStatus"),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Navigate to a page for editing order details (if needed)
                    // You can implement an edit order page here
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
