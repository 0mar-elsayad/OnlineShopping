import 'package:flutter/material.dart';
import 'package:shopping_app/Widget/Elevatedbotton.dart';
import 'package:shopping_app/Widget/Listtile_widget.dart';
import 'package:shopping_app/screens/Add_product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app/screens/Login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _Profilescreenstate();
}

class _Profilescreenstate extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .get(),
              builder: (context, snapshot) {
                final name = snapshot.data?.data()!['name'];
                final email = snapshot.data?.data()!['email'];
                if (snapshot.hasError) {
                  return const Text('error');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasData) {
                  return Column(children: [
                    Text(
                      name,
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      email,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ListtileWidget(
                      icon: Icons.request_page,
                      title: 'orders',
                      function: () {},
                    ),
                    Divider(
                      color: Colors.grey[300],
                      thickness: 1,
                    ),
                    ListtileWidget(
                      icon: Icons.favorite,
                      title: 'favourite',
                      function: () {},
                    ),
                    Divider(
                      color: Colors.grey[300],
                      thickness: 1,
                    ),
                    // ListtileWidget(
                    //   icon: Icons.add,
                    //   title: 'Add Product',
                    //   function: () {
                    //     Navigator.pushReplacement(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => const Addproduct(),
                    //       ),
                    //     );
                    //   },
                    // ),
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[900],
                        ),
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: ElevatedWidget(
                          color: Colors.grey,
                          title: 'Sign out',
                          function: () {},
                        ),
                      ),
                    )
                  ]);
                }
                return const Text('');
              }),
        ),
      )),
    ); // scaffold
  }
}
