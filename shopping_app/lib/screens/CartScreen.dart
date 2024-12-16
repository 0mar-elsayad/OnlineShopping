// cartScreen.dart

import 'package:flutter/material.dart';
import 'package:shopping_app/model/cart_model_list.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModelList>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: cart.cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty!'))
          : ListView.builder(
              itemCount: cart.cartItems.length,
              itemBuilder: (context, index) {
                final item = cart.cartItems[index];
                return ListTile(
                  leading: Image.network(
                    item.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(item.name),
                  subtitle: Text("Price: \$${item.price} x ${item.quantity}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                         IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          cart.updateQuantity(item, item.quantity + 1);
                        },
                      ),
                      Text('${item.quantity}'),
                                            IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          // Decrease quantity or remove
                          if (item.quantity > 1) {
                            cart.updateQuantity(item, item.quantity - 1);
                          } else {
                            cart.remove(item);
                          }
                        },
                      ),
                   IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          cart.remove(item);
                        },
                      ),
                    ],
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
              'Total: \$${cart.totalPrice}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Checkout"),
                    content: Text("Your total is \$${cart.totalPrice}"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          cart.clearCart();
                          Navigator.pop(context);
                        },
                        child: const Text("Confirm"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                    ],
                  ),
                );
              },
              child: const Text("Checkout"),
            ),
          ],
        ),
      ),
    );
  }
}
