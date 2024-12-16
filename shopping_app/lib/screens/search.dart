import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../Widget/productwidget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required List<String> productList});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<Map<String, String>> products = [
    {
      'name': 'iPhone 13',
      'price': '3500',
      'imageUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQtkScJu7uJWUM2HXMluAkmnXHMvWeSoepePg&s',
    },
    {
      'name': 'MacBook Air',
      'price': '1200',
      'imageUrl':
          'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/mba13-midnight-select-202402?wid=904&hei=840&fmt=jpeg&qlt=90&.v=1708367688034,'
    },
    {
      'name': 'Apple Watch',
      'price': '400',
      'imageUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTxc_mmycGKjssaK86jb1uoEGK2POQhHLtLWA&s',
    },
    {
      'name': 'iPad Pro',
      'price': '800',
      'imageUrl':
          'https://m.media-amazon.com/images/I/71vg3LNWBTL._AC_SL1500_.jpg'
    },
    {
      'name': 'AirPods',
      'price': '250',
      'imageUrl':
          'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/MQD83_AV2?wid=1144&hei=1144&fmt=jpeg&qlt=95&.v=1660803960086',
    },
  ];

  List<Map<String, String>> filteredProducts = [];
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredProducts = products;
    _speech = stt.SpeechToText();
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts = products;
      } else {
        filteredProducts = products
            .where((product) =>
                product['name']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _startListening() async {
    bool available = await _speech.initialize(
      onError: (val) => print("Error: $val"),
      onStatus: (val) => print("Status: $val"),
    );

    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (val) {
        setState(() {
          _searchQuery = val.recognizedWords;
          _filterProducts(_searchQuery);
        });
      });
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search Screen'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search for a product',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                      onChanged: _filterProducts,
                      controller: TextEditingController(text: _searchQuery),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _isListening ? _stopListening : _startListening,
                    child: CircleAvatar(
                      backgroundColor: _isListening ? Colors.red : Colors.blue,
                      child: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 4.5 / 7,
                  children: filteredProducts.map((product) {
                    return Productwidget(
                      name: product['name']!,
                      price: product['price']!,
                      imageUrl: product['imageUrl']!,
                    );
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
