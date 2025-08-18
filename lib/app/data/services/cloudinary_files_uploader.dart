import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/cloudinary/cloudinary_response.dart';

class CloudinaryUploadException implements Exception {
  final String message;
  CloudinaryUploadException(this.message);

  @override
  String toString() => "CloudinaryUploadException: $message";
}

class CloudinaryUploadService {
  final String backendUrl;

  CloudinaryUploadService({required this.backendUrl});

  /// Upload a file to Cloudinary through your backend
  Future<CloudinaryResponse?> uploadFile(File file) async {
    try {
      final uri = Uri.parse('$backendUrl/upload');
      final request = http.MultipartRequest('POST', uri);

      // The file
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      // Extra fields (matching your curl command)
      request.fields['folder'] = 'test';
      request.fields['resource_type'] = 'auto';

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint("RAW BACKEND RESPONSE: ${response.body}");

      if (response.statusCode != 200) {
        throw CloudinaryUploadException(
          "Upload failed: ${response.statusCode} - ${response.body}",
        );
      }

      final data = json.decode(response.body);
      if (data is! Map<String, dynamic>) {
        throw CloudinaryUploadException(
          "Invalid response format: expected a JSON object, got $data",
        );
      }
      if (!data.containsKey('url')) {
        throw CloudinaryUploadException(
          "Missing Url in backend response: $data",
        );
      }

      return CloudinaryResponse.fromJson(data);
    } catch (e) {
      debugPrint("Cloudinary upload error: $e");
      rethrow;
    }
  }
}
