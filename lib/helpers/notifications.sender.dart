import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:mounakassat_dz/constants/app_constants.dart';

class NotiifcationSender {
  Future<void> sendCurlRequest({
    required String token,
    required String title,
    required String message,
    required String type,
  }) async {
    if (token.isEmpty || title.isEmpty || message.isEmpty) {
      log("❗ Missing required fields: token, title, or message.");
      return;
    }

    final Map<String, dynamic> body = {
      'title': title,
      'body': message,
      'token': token,
      'type': type,
    };

    try {
      final response = await http
          .post(
            Uri.parse(sendNotificationUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        log("✅ Notification sent successfully: ${response.body}");
      } else {
        log("❌ Failed with status ${response.statusCode}: ${response.body}");
      }
    } on http.ClientException catch (e) {
      log("❌ ClientException: $e");
    } on TimeoutException {
      log("⏱️ Request timed out");
    } catch (e) {
      log("❌ Unexpected error: $e");
    }
  }
}
