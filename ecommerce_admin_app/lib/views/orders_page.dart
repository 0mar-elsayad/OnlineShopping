import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No orders available."));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final orderId = order.id;
              final customerName = order['name'] ?? "Unknown Customer";
              final orderStatus = order['status'] ?? "Unknown Status";
              final totalAmount = order['totalAmount'] ?? 0;
              final productQuantities = order['productQuantities'] as Map<String, dynamic>;

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Order ID: $orderId",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Chip(
                            label: Text(
                              orderStatus,
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: orderStatus == "Delivered"
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Customer Name
                      Text(
                        "Customer: $customerName",
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),

                      const SizedBox(height: 8),

                      // Total Amount
                      Text(
                        "Total Amount: \$${totalAmount.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 8),

                      // Product Quantities
                      const Text(
                        "Products:",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      ...productQuantities.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 4),
                          child: Text(
                            "${entry.key}: Quantity - ${entry.value}",
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}