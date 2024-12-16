import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shopping_app/screens/bottombar.dart';
import 'package:shopping_app/screens/signup.dart';

  class LoginScreen extends StatefulWidget {
    const LoginScreen({super.key});

    @override
    State<LoginScreen> createState() => _LoginScreenState();
  }

  class _LoginScreenState extends State<LoginScreen> {
     bool isLoading=false;


final email = TextEditingController();
final password = TextEditingController();

void login() async {
  try {
    setState(() {
      isLoading = true;
    });

    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.text,
      password: password.text,
    );


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

    email.dispose();
    password.dispose();
    super.dispose();
  }
    final formkey = GlobalKey<FormState>();
    @override
    @override
Widget build(BuildContext context) {
  debugPrint('LoginScreen build method called');
  return SafeArea(
    child: Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                              login();
                            }
                          },
                          child:isLoading?CircularProgressIndicator(): Text(
                            'Login',
                            style: TextStyle(color: Colors.white),
                          ))),
                  SizedBox(height: 30),
                  Text("you don't have an account ?"),
                  TextButton(onPressed: () {
                         Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SignupScreen(),
                ),
              );
                  }, child: Text('Signup'))
                ],
              ),
            ),
          ),
        )),
      );
    }
  }

