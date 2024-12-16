import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<String?> uploadImageToCloudinary(File imageFile) async {
  final cloudName = 'di54swvun'; // Replace with your Cloudinary cloud name
  final uploadPreset = 'di54swvun'; // Set up an unsigned upload preset in Cloudinary

  final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

  final request = http.MultipartRequest('POST', url)
    ..fields['upload_preset'] = uploadPreset
    ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

  final response = await request.send();

  if (response.statusCode == 200) {
    final responseData = await response.stream.bytesToString();
    final decodedResponse = json.decode(responseData);
    return decodedResponse['secure_url']; // The URL of the uploaded image
  } else {
    print('Failed to upload image: ${response.reasonPhrase}');
    return null;
  }
}
