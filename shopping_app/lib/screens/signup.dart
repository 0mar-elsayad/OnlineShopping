import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/screens/bottombar.dart';
import 'package:shopping_app/screens/Login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  bool isLoading=false;

final name = TextEditingController();
final email = TextEditingController();
final password = TextEditingController();

void signup() async {
  try {
    setState(() {
      isLoading = true;
    });

    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email.text,
      password: password.text,
    );
    await FirebaseFirestore




    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => BottomBar(),
      ),
    );
  } on FirebaseException catch (error) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error.toString()),
        duration: Duration(seconds: 3),
      ),
    );
  } finally {
    setState(() {
      isLoading = false; 
    });
  }
}

@override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }



  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  'Shopping-App',
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 50,
                ),
                Form(
                  key: formkey,
                  child: Column(
                    children: [
                      TextFormField(
                          controller: name,


                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a valid name!';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)),
                          hintText: 'User-Name',
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                          controller: email,


                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Please enter a valid email adress';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)),
                          hintText: 'Email Address',
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: password, 



                        validator: (value) {
                          if (value!.isEmpty || value.length < 7) {
                            return 'Password should be at least 7 characters';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)),
                          hintText: 'Password',
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[900]),
                        onPressed: () {
                          formkey.currentState!.save();
                          if (formkey.currentState!.validate()) {
                            signup();
                          }
                        },
                        child:isLoading?CircularProgressIndicator(): Text(
                          'Sign up',
                          style: TextStyle(color: Colors.white),
                        ))),
                SizedBox(height: 30),
                Text('already have an account?'),
                TextButton(onPressed: () {
                  Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
                }, child: Text('Login'))
              ],
            ),
          ),
        ),
      )),
    );
  }
}

