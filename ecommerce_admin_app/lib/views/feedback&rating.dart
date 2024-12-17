import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedbackAndRating extends StatelessWidget {
  const FeedbackAndRating({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback & Ratings"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Listening to the 'feedback' collection from Firestore
        stream: FirebaseFirestore.instance.collection('feedback').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No feedback available."));
          }

          // Fetch feedback documents
          final feedbackList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: feedbackList.length,
            itemBuilder: (context, index) {
              final feedbackDoc = feedbackList[index];
              final feedbackData = feedbackDoc.data() as Map<String, dynamic>;

              // Extract data from Firestore document
              final orderId = feedbackData['orderId'] ?? "Unknown Order ID";
              final customerName = feedbackData['customerName'] ?? "Unknown Customer";
              final rating = feedbackData['rating'] ?? 0.0;
              final feedbackText = feedbackData['feedback'] ?? "No feedback provided.";
              final details = feedbackData['details'] ?? {};

              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    child: Text(
                      "$rating",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    "Order ID: $orderId",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Customer: $customerName"),
                      Text("Feedback: $feedbackText"),
                      const SizedBox(height: 5),
                      Text(
                        "Product: ${details['productName'] ?? 'N/A'}\n"
                        "Quantity: ${details['quantity'] ?? 'N/A'}\n"
                        "Price: \$${details['price'] ?? '0.0'}",
                      ),
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
