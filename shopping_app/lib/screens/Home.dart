

import 'package:flutter/material.dart';
import 'package:shopping_app/Widget/productwidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
{
  final List <Map<String,dynamic>>categories=[
    {'icons':Icons.mobile_friendly,
    'title':"Iphone"},
    {'icons':Icons.computer_outlined,
    'title':"Laptop"},
    {'icons':Icons.watch,
    'title':"Watches"}];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text("E_commerce",style:TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
              SizedBox(height: 40,),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index){
                    return Column(
                      children: [
                        Icon(categories[index]['icons']),
                        Text(categories[index]['title']),
                        SizedBox(width: 135,),
                        
                      ],
                    
                    
                    );
                  },
                ),
              ),
              Text("Our Products",style:TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
              SizedBox(
                height: 30,
              ),
              GridView.count(
                childAspectRatio: 4.5/7,
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children:List.generate(5,(index){
                  return Productwidget();
                }),
              )
              
            ],
          ),
        ),
      ),
    );
  }
}