import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class ImageService {
  final String baseUrl = "http://192.168.96.235:80/images";

  Future<dynamic> uploadImage(File imageFile) async {
    final url = Uri.parse('$baseUrl/upload');

    var request = http.MultipartRequest('POST', url);

    var multipartFile = await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
      filename: basename(imageFile.path),
    );

    request.files.add(multipartFile);

    var response = await request.send();

    if (response.statusCode == 200) {
      var contentType = response.headers['content-type'];
      if (contentType != null && contentType.startsWith('image')) {
        var responseBytes = await response.stream.toList();

        var concatenatedBytes = Uint8List.fromList(
            responseBytes.expand((element) => element).toList());
        return concatenatedBytes;
      } else {
        var responseString = await response.stream.bytesToString();
        return responseString;
      }
    } else {
      throw Exception('Failed to upload image');
    }
  }
}
