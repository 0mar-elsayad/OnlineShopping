import 'package:ecommerce_admin_app/containers/dashboard_text.dart';
import 'package:ecommerce_admin_app/containers/home_button.dart';
import 'package:ecommerce_admin_app/controllers/auth_service.dart';
import 'package:ecommerce_admin_app/provider/admin_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  // Fetch total categories
  Future<int> _getTotalCategories() async {
    var snapshot = await FirebaseFirestore.instance.collection('categories').get();
    return snapshot.size;
  }

  // Fetch total products
  Future<int> _getTotalProducts() async {
    var snapshot = await FirebaseFirestore.instance.collection('products').get();
    return snapshot.size;
  }

  // Fetch total orders
  Future<int> _getTotalOrders() async {
    var snapshot = await FirebaseFirestore.instance.collection('orders').get();
    return snapshot.size; // Returns the number of orders in the collection
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            onPressed: () async {
              Provider.of<AdminProvider>(context, listen: false).cancelProvider();
              await AuthService().logout();
              Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Dashboard Summary
            Container(
              height: 300, // Adjusted height
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Consumer<AdminProvider>(
                builder: (context, value, child) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Total Categories
                    FutureBuilder<int>(
                      future: _getTotalCategories(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return DashboardText(keyword: "Total Categories", value: "Loading...");
                        } else if (snapshot.hasError) {
                          return DashboardText(keyword: "Total Categories", value: "Error");
                        } else {
                          return DashboardText(keyword: "Total Categories", value: "${snapshot.data}");
                        }
                      },
                    ),
                    // Total Products
                    FutureBuilder<int>(
                      future: _getTotalProducts(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return DashboardText(keyword: "Total Products", value: "Loading...");
                        } else if (snapshot.hasError) {
                          return DashboardText(keyword: "Total Products", value: "Error");
                        } else {
                          return DashboardText(keyword: "Total Products", value: "${snapshot.data}");
                        }
                      },
                    ),
                    // Total Orders
                    FutureBuilder<int>(
                      future: _getTotalOrders(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return DashboardText(keyword: "Total Orders", value: "Loading...");
                        } else if (snapshot.hasError) {
                          return DashboardText(keyword: "Total Orders", value: "Error");
                        } else {
                          return DashboardText(keyword: "Total Orders", value: "${snapshot.data}");
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Admin Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      HomeButton(
                        onTap: () {
                          Navigator.pushNamed(context, "/orders");
                        },
                        name: "Orders",
                      ),
                      HomeButton(
                        onTap: () {
                          Navigator.pushNamed(context, "/products");
                        },
                        name: "Products",
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      HomeButton(
                        onTap: () {
                          Navigator.pushNamed(context, "/category");
                        },
                        name: "Categories",
                      ),
                      HomeButton(
                        onTap: () {
                          Navigator.pushNamed(context, "/feedback & rating");
                        },
                        name: "feedback & rating",
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HomeButton(
                        onTap: () {
                          Navigator.pushNamed(context, "/chart");
                        },
                        name: "Best selling",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
