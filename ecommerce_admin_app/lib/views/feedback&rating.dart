import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackAndRating extends StatelessWidget {
  const FeedbackAndRating({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback & Ratings", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('feedback').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No feedback available.", style: TextStyle(fontSize: 18, color: Colors.grey)));
          }


          final feedbackList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: feedbackList.length,
            itemBuilder: (context, index) {
              final feedbackDoc = feedbackList[index];
              final feedbackData = feedbackDoc.data() as Map<String, dynamic>;

              final orderId = feedbackData['orderId'] ?? "Unknown Order ID";
              final customerName = feedbackData['customerName'] ?? "Unknown Customer";
              final rating = feedbackData['rating'] ?? 0.0;
              final feedbackText = feedbackData['feedback'] ?? "No feedback provided.";
              final details = feedbackData['details'];

              String productName = 'N/A';
              int quantity = 0;
              double price = 0.0;

              if (details is Map<String, dynamic>) {
                productName = details['productName']?.toString() ?? 'N/A';
                quantity = details['quantity'] is int ? details['quantity'] : 0;
                price = details['price'] is num ? details['price'].toDouble() : 0.0;
              } else if (details is List) {
                print("Details is a List instead of Map: $details");
                final firstItem = details.isNotEmpty ? details[0] : {};
                if (firstItem is Map<String, dynamic>) {
                  productName = firstItem['productName']?.toString() ?? 'N/A';
                  quantity = firstItem['quantity'] is int ? firstItem['quantity'] : 0;
                  price = firstItem['price'] is num ? firstItem['price'].toDouble() : 0.0;
                }
              }

              return Card(
                margin: const EdgeInsets.all(15),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
  
                      Row(
                        children: [
    
                          RatingBarIndicator(
                            rating: rating.toDouble(),
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 25.0,
                            direction: Axis.horizontal,
                          ),
                          const SizedBox(width: 15),
                          Text(
                            "$customerName",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
             
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "\"$feedbackText\"",
                          style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16, color: Colors.black87),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Order ID: $orderId",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 5),
                      Text("Product: $productName", style: const TextStyle(fontSize: 14, color: Colors.black54)),
                      Text("Quantity: $quantity", style: const TextStyle(fontSize: 14, color: Colors.black54)),
                      Text("Price: \$${price.toStringAsFixed(2)}", style: const TextStyle(fontSize: 14, color: Colors.black54)),
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
