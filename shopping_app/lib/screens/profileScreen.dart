import 'package:flutter/material.dart';
import 'package:shopping_app/Widget/Elevatedbotton.dart';
import 'package:shopping_app/Widget/Listtile_widget.dart';
import 'package:shopping_app/screens/Add_product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shopping_app/screens/Login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _Profilescreenstate()  ;
  }


class _Profilescreenstate extends State <ProfileScreen> {
@override
Widget build(BuildContext context) {
return SafeArea(
  child: Scaffold(
    body :Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: Column(
           children:[
        Text ('name',style: TextStyle(fontSize: 20),)
        , Text ('name@gmail',style: TextStyle(fontSize: 20),)  ,
        SizedBox(height: 30,) 
        , ListtileWidget(icon: Icons.request_page, title: 'orders', function: (){},) 
        ,Divider(color: Colors.grey[300],thickness: 1,)  
        , ListtileWidget(icon: Icons.favorite, title: 'favourite', function: (){},) 
        ,Divider(color: Colors.grey[300],thickness: 1,)  
        , ListtileWidget(icon: Icons.add, title: 'Add Product', function: (){

    Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => Addproduct(),
  ),
);

},),





SizedBox(height: 50,),

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
          builder: (context) => LoginScreen(),
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
           ]
        ),
      ),
    )
  
  ),
); // scaffold
}
}