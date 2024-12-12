  import 'package:flutter/material.dart';

  class Productwidget extends StatelessWidget {
    const Productwidget({super.key});

    @override
    Widget build(BuildContext context) {
      return Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed:(){}, icon: Icon(Icons.add)),
                IconButton(onPressed:(){}, icon: Icon(Icons.favorite)),
              ],
            )
            ,
            Image.network("https://www.dslr-zone.com/wp-content/uploads/2021/10/1-2.jpeg"),
          Text("Iphone 13",style: TextStyle(fontSize: 20),),
          Text("3500.00",style: TextStyle(fontSize: 18,color: Colors.blue),),
          ],
          
        ),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12)
        ),
      );
    }
  }