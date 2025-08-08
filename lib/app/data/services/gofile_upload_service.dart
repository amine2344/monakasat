import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;

class GofileUploadException implements Exception {
  final String message;
  GofileUploadException(this.message);

  @override
  String toString() => 'GofileUploadException: $message';
}

class GofileUploadService {
  final Uri _uploadUri = Uri.parse('https://upload.gofile.io/uploadfile');
  final String _apiToken = '3byMV5QxtAm2KVp0ON0jUBC3gz1l2RgU';

  Future<String> uploadFile(File file, {String? folderId}) async {
    if (!file.existsSync()) {
      throw GofileUploadException('File does not exist: ${file.path}');
    }

    final mimeType = lookupMimeType(file.path);
    if (mimeType == null) {
      throw GofileUploadException(
        'Unable to determine file type: ${file.path}',
      );
    }

    final fileSize = await file.length();
    if (fileSize > 10 * 1024 * 1024) {
      throw GofileUploadException('File size exceeds 10MB limit.');
    }

    int retries = 3;
    int attempt = 1;
    while (retries > 0) {
      try {
        final request = http.MultipartRequest('POST', _uploadUri)
          ..headers['Authorization'] = 'Bearer $_apiToken'
          ..files.add(
            await http.MultipartFile.fromPath(
              'file',
              file.path,
              contentType: MediaType.parse(mimeType),
              filename: path.basename(file.path),
            ),
          );
        if (folderId != null) {
          request.fields['folderId'] = folderId;
        }

        debugPrint(
          'Attempt $attempt: Uploading ${path.basename(file.path)} (${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB)...',
        );

        final response = await request.send().timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            throw GofileUploadException('Upload timed out after 30 seconds');
          },
        );
        final responseBody = await response.stream.bytesToString();
        debugPrint('Attempt $attempt: Response: $responseBody');

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(responseBody);
          if (jsonResponse['status'] == 'ok' && jsonResponse['data'] != null) {
            final downloadPage = jsonResponse['data']['downloadPage'];
            if (downloadPage == null) {
              throw GofileUploadException('Missing downloadPage in response');
            }
            debugPrint('Upload successful: $downloadPage');
            return downloadPage;
          } else {
            throw GofileUploadException(
              'Invalid response format: $responseBody',
            );
          }
        } else if (response.statusCode == 429) {
          retries--;
          attempt++;
          debugPrint(
            'Rate limit hit, retrying in 2 seconds... ($retries attempts left)',
          );
          await Future.delayed(const Duration(seconds: 2));
        } else {
          throw GofileUploadException(
            'HTTP ${response.statusCode} - $responseBody',
          );
        }
      } catch (e) {
        debugPrint('Attempt $attempt: Upload error: $e');
        retries--;
        attempt++;
        if (retries == 0) {
          throw GofileUploadException('Failed after $attempt attempts: $e');
        }
        await Future.delayed(const Duration(seconds: 1));
      }
    }
    throw GofileUploadException(
      'Failed to upload file after $attempt attempts',
    );
  }
}
