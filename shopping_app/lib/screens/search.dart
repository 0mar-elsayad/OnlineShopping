import 'package:flutter/material.dart';
import '../Widget/productwidget.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

final List<Map<String, String>> products = [
  {'name': 'iPhone 13', 'price': '3500'},
  {'name': 'MacBook Air', 'price': '1200'},
  {'name': 'Apple Watch', 'price': '400'},
  {'name': 'iPad Pro', 'price': '800'},
  {'name': 'AirPods', 'price': '250'},
];


  List<Map<String, String>> filteredProducts = [];

  @override
  void initState() {
    super.initState();

    filteredProducts = List.from(products);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Search Screen'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [

              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search for a product',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                onChanged: (value) {

                  setState(() {
                    filteredProducts = products.where((product) {
                      return product['name']!
                          .toLowerCase()
                          .contains(value.toLowerCase());
                    }).toList();
                  });
                },
              ),

              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 4.5 / 7,
                  children: filteredProducts.map((product) {
                    return Productwidget( );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//  import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import '../Widget/productwidget.dart';

// class SearchScreen extends StatefulWidget {
//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   final List<Map<String, String>> products = [
//     {'name': 'iPhone 13', 'price': '3500', 'image': 'https://www.dslr-zone.com/wp-content/uploads/2021/10/1-2.jpeg'},
//     {'name': 'MacBook Air', 'price': '1200', 'image': 'https://example.com/image-not-found.jpg'},
//     {'name': 'Apple Watch', 'price': '400', 'image': 'https://example.com/image-not-found.jpg'},
//     {'name': 'iPad Pro', 'price': '800', 'image': 'https://www.dslr-zone.com/wp-content/uploads/2021/10/1-2.jpeg'},
//   ];

//   List<Map<String, String>> filteredProducts = [];
//   final TextEditingController _searchController = TextEditingController();
//   late stt.SpeechToText _speech; // Speech-to-text instance
//   bool _isListening = false;
//   String _voiceInput = "";

//   @override
//   void initState() {
//     super.initState();
//     filteredProducts = List.from(products);
//     _speech = stt.SpeechToText();
//   }

//   void _startListening() async {
//     bool available = await _speech.initialize();
//     if (available) {
//       setState(() {
//         _isListening = true;
//       });
//       _speech.listen(onResult: (result) {
//         setState(() {
//           _voiceInput = result.recognizedWords;
//           _searchController.text = _voiceInput;
//           _filterProducts(_voiceInput);
//         });
//       });
//     }
//   }

//   void _stopListening() {
//     _speech.stop();
//     setState(() {
//       _isListening = false;
//     });
//   }

//   void _filterProducts(String query) {
//     setState(() {
//       filteredProducts = products.where((product) {
//         return product['name']!.toLowerCase().contains(query.toLowerCase());
//       }).toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Search Screen'),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               // Search Field with Voice Search Button
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _searchController,
//                       decoration: InputDecoration(
//                         prefixIcon: Icon(Icons.search),
//                         hintText: 'Search for a product',
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(color: Colors.blue),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(color: Colors.grey),
//                         ),
//                       ),
//                       onChanged: _filterProducts,
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
//                     color: _isListening ? Colors.red : Colors.grey,
//                     onPressed: _isListening ? _stopListening : _startListening,
//                   ),
//                 ],
//               ),
//               // Product Grid
//               Expanded(
//                 child: GridView.count(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                   childAspectRatio: 4.5 / 7,
//                   children: filteredProducts.map((product) {
//                     return Productwidget( );
//                   }).toList(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }