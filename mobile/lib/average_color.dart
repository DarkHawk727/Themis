import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;

class AvgColor {
  static getAverageColor(String url) async {
    img.Image bitmap = img.decodeImage(await _fileFromImageUrl(url));
    int redBucket = 0;
    int greenBucket = 0;
    int blueBucket = 0;
    int redBucketLT = 0;
    int greenBucketLT = 0;
    int blueBucketLT = 0;
    int pixelCount = 0;

    for (int y = 0; y < bitmap.height; y++) {
      for (int x = 0; x < bitmap.width; x++) {
        int c = bitmap.getPixel(x, y);
        pixelCount++;
        redBucket += img.getRed(c);
        greenBucket += img.getGreen(c);
        blueBucket += img.getBlue(c);

        if(y > bitmap.height * 0.66 && x > bitmap.width * 0.33 && x < bitmap.width * 0.66) {
          redBucketLT += img.getRed(c);
          greenBucketLT += img.getGreen(c);
          blueBucketLT += img.getBlue(c);
        }
      }
    }

    return {
      'full': Color.fromRGBO(redBucket ~/ pixelCount,
        greenBucket ~/ pixelCount, blueBucket ~/ pixelCount, 1),
      'bottomThird': Color.fromRGBO(redBucketLT ~/ pixelCount,
        greenBucketLT ~/ pixelCount, blueBucketLT ~/ pixelCount, 1),
      }; 
  }

  static Future<Uint8List> _fileFromImageUrl(String url) async {
    final bytes = await http.get(Uri.parse(url));
    return bytes.bodyBytes;
  }
}