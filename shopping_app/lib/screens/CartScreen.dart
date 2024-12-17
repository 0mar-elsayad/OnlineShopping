import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For user authentication
import '../model/cart_model_list.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  int _selectedRating = 1; 
  String _userName = "Anonymous"; // Default username

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  // Fetch user name from Firestore
  Future<void> _fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          _userName = userDoc['name'] ?? "Anonymous";
        });
      }
    }
  }
  void _showFeedbackForm(BuildContext context, double totalPrice, CartModelList cart) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text("Feedback and Rating"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Rating:"),
                    DropdownButton<int>(
                      value: _selectedRating,
                      onChanged: (value) {
                        setState(() {
                          _selectedRating = value!;
                        });
                      },
                      items: List.generate(5, (index) {
                        return DropdownMenuItem(
                          value: index + 1,
                          child: Text("${index + 1}"),
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _feedbackController,
                  decoration: const InputDecoration(
                    hintText: "Enter your feedback",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                Text("Total Cost: \$${totalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  await _submitFeedbackAndSaveOrder(
                      context, _feedbackController.text, _selectedRating, totalPrice, cart);
                },
                child: const Text("Submit"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
            ],
          );
        });
      },
    );
  }

  // Submit feedback, save to Firestore, and save the order
  Future<void> _submitFeedbackAndSaveOrder(
      BuildContext context, String feedback, int rating, double totalPrice, CartModelList cart) async {
    final CollectionReference feedbackCollection =
        FirebaseFirestore.instance.collection('feedback');
    final CollectionReference ordersCollection =
        FirebaseFirestore.instance.collection('orders');

    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No logged-in user. Please log in to submit.")));
      return;
    }

    final orderId = ordersCollection.doc().id;

    final orderItems = cart.cartItems.map((item) {
      return {
        "productId": item.id, 
        "productName": item.name,
        "quantity": item.quantity,
        "price": double.parse(item.price),
        "status": "delivered",
      };
    }).toList();

    try {
      await feedbackCollection.add({
        "orderId": orderId,
        "customerName": _userName,
        "rating": rating,
        "feedback": feedback,
        "details": orderItems,
        "totalCost": totalPrice,
        "timestamp": Timestamp.now(),
      });
      await ordersCollection.doc(orderId).set({
        "name": _userName,
        "price": cart.totalPrice.toString(),
        "productId": orderItems.map((item) => item["productId"]).toList(),
        "quantity": orderItems.fold<int>(0, (sum, item) {
  return sum + (item["quantity"] as int);
}),
        "status": "Pending",
        "total": totalPrice,
        "timestamp": Timestamp.now(),
        "totalAmount": totalPrice,
      });
      cart.clearCart();
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Order submitted, feedback saved, and cart cleared!")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  // Cancel order and update status
  void _cancelOrder(CartModelList cart) {
    cart.clearCart();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Order canceled and marked as deleted!")));
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModelList>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: cart.cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty!'))
          : ListView.builder(
              itemCount: cart.cartItems.length,
              itemBuilder: (context, index) {
                final item = cart.cartItems[index];
                return ListTile(
                  leading: Image.network(item.imageUrl, width: 50, height: 50),
                  title: Text(item.name),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Price: \$${item.price}"),
                      Row(
                        children: [
                          // IconButton(
                          //     icon: const Icon(Icons.remove),
                          //     onPressed: () {
                          //       if (item.quantity > 1) {
                          //         cart.updateQuantity(item, item.quantity - 1);
                          //       } else {
                          //         cart.remove(item);
                          //       }
                          //     }),
                          // Text("${item.quantity}"),
                          // IconButton(
                          //     icon: const Icon(Icons.add),
                          //     onPressed: () {
                          //       if (item.quantity < item.maxQuantity) {
                          //         cart.updateQuantity(item, item.quantity + 1);
                          //       } else {
                          //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          //             content: Text("Reached max available quantity.")));
                          //       }
                          //     }),
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.green),
                            onPressed: () {
                              if (item.quantity < item.maxQuantity) {
                                cart.updateQuantity(item, item.quantity + 1);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Max stock reached!")),
                                );
                              }
                            },
                          ),
                          Text('${item.quantity}'),
                          IconButton(
                            icon: const Icon(Icons.remove, color: Colors.red),
                            onPressed: () {
                              if (item.quantity > 1) {
                                cart.updateQuantity(item, item.quantity - 1);
                              } else {
                                cart.remove(item);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      cart.remove(item);
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Total: \$${cart.totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _cancelOrder(cart),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Cancel Order"),
                ),
                ElevatedButton(
                  onPressed: () => _showFeedbackForm(context, cart.totalPrice, cart),
                  child: const Text("Checkout"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
