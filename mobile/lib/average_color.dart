import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class AvgColor {
  static getAverageColor(String url) async {
    img.Image bitmap = img.decodeImage(await _fileFromImageUrl(url));
    int redBucket = 0;
    int greenBucket = 0;
    int blueBucket = 0;
    int pixelCount = 0;

    for (int y = 0; y < 10; y++) {
      for (int x = 0; x < bitmap.width; x++) {
        int c = bitmap.getPixel(x, y);

        pixelCount++;
        redBucket += img.getRed(c);
        greenBucket += img.getGreen(c);
        blueBucket += img.getBlue(c);
      }
    }

    return Color.fromRGBO(redBucket ~/ pixelCount,
        greenBucket ~/ pixelCount, blueBucket ~/ pixelCount, 1); 
    }

  static Future<Uint8List> _fileFromImageUrl(String url) async {
    final bytes = await http.get(Uri.parse(url));
    return bytes.bodyBytes;
  }
}