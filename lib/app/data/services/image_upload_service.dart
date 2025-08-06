import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

class ImageUploadException implements Exception {
  final String message;
  ImageUploadException(this.message);

  @override
  String toString() => 'ImageUploadException: $message';
}

class ImageUploadService {
  final Uri _uploadUri = Uri.parse(
    'https://img-uploader-haoh.onrender.com/upload-images',
  );

  Future<String> uploadImage(File imageFile) async {
    if (!imageFile.existsSync()) {
      throw ImageUploadException(
        'Image file does not exist: ${imageFile.path}',
      );
    }

    final mimeType = lookupMimeType(imageFile.path);
    if (mimeType == null || !mimeType.startsWith('image/')) {
      throw ImageUploadException('Unsupported file type: $mimeType');
    }

    final fileSize = await imageFile.length();
    if (fileSize > 10 * 1024 * 1024) {
      throw ImageUploadException('Image size exceeds 10MB limit.');
    }

    final request = http.MultipartRequest('POST', _uploadUri)
      ..files.add(
        await http.MultipartFile.fromPath(
          'images',
          imageFile.path,
          contentType: MediaType.parse(mimeType),
          filename: path.basename(imageFile.path),
        ),
      );

    debugPrint(
      'Uploading ${path.basename(imageFile.path)} (${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB)...',
    );

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(responseBody);
      if (jsonResponse is Map &&
          jsonResponse['urls'] is List &&
          jsonResponse['urls'].isNotEmpty) {
        return jsonResponse['urls'][0];
      } else {
        throw ImageUploadException(
          'Upload succeeded but response format is invalid.',
        );
      }
    } else {
      throw ImageUploadException('HTTP ${response.statusCode} - $responseBody');
    }
  }
}
