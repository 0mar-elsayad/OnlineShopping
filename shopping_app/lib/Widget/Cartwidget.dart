import 'package:flutter/material.dart';

class Cartwidget extends StatelessWidget {
  const Cartwidget({super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: height * 0.15,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 45,
              backgroundImage: NetworkImage(
                  'https://www.dslr-zone.com/wp-content/uploads/2021/10/1-2.jpeg'),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('iPhone 13', style: TextStyle(fontSize: 20)),
                Text('3500.00',
                    style: TextStyle(fontSize: 18, color: Colors.blue)),
              ],
            ),
          
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Container(
                child: Icon(Icons.add),
                color: Colors.lightBlue[300],
                 decoration : BoxDecoration(borderRadius: BorderRadius.circular(16))
            
              ),
              Text('2')
              
              , Container(
            
                child: Icon(Icons.remove),
                color: Colors.white,
                 decoration : BoxDecoration(borderRadius: BorderRadius.circular(16))
            
              )
            
            ],),
          )],
        ),
      ),
    );
  }
}