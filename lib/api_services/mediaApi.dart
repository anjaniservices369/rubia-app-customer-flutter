// =============================================================================
// WHAT : Uploads a picture (for example the profile photo) to the Rubia server.
// NOTES: Replaces the old Firebase Storage. The server returns a link that is
//        then saved on the profile.
// =============================================================================
import 'dart:convert';
import 'dart:io';

import 'package:base_project_flutter/api_services/ApiHelper.dart';
import 'package:base_project_flutter/api_services/sessionGuard.dart';
import 'package:base_project_flutter/constants/apiConstants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// >>> START: MediaApi - uploads pictures to the Rubia server
/// Uploads files to the backend media store (`POST /api/media/upload`).
///
/// The returned `url` is what the other endpoints expect in the fields that
/// used to carry a Firebase Storage URL (e.g. the profile picture).
class MediaApi {
  /// Server default cap is 4 MB (`params['media']['maxBytes']`).
  static const int maxBytes = 4 * 1024 * 1024;

  // >>> START: upload - uploads one picture and returns its link
  /// Returns the media url, or null when the upload failed.
  static Future<String?> upload(BuildContext context, File file) async {
    try {
      // 1. Refuse files the server would reject anyway (over 4 MB).
      if (await file.length() > maxBytes) {
        debugPrint('MediaApi: file is larger than $maxBytes bytes');
        return null;
      }
      // 2. Get the customer's login header (also checks the login is valid).
      final headers = await ApiHelper().getHeader(context);
      // 3. Build a multipart (file) request to the upload address.
      final request =
          http.MultipartRequest('POST', Uri.parse('$apiBaseUrl/media/upload'));
      request.headers['auth_code'] = headers['auth_code'];
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      // 4. Send it and read the reply.
      final response = await http.Response.fromStream(await request.send());
      if (response.statusCode != 200) {
        debugPrint('MediaApi: HTTP ${response.statusCode}');
        return null;
      }
      final body = json.decode(response.body);
      // 5. If the server says the login is invalid, sign the customer out.
      if (await SessionGuard.handle(body)) return null;
      // 6. Success: return the link of the stored picture.
      if (body is Map && body['status'] == 'OK' && body['url'] != null) {
        return body['url'].toString();
      }
      debugPrint('MediaApi: upload rejected: ${body is Map ? body['error'] : body}');
    } catch (e) {
      // Any other problem (no network, bad reply) simply means "not uploaded".
      debugPrint('MediaApi.upload failed: $e');
    }
    return null;
  }
  // <<< END: upload - uploads one picture and returns its link
}
// <<< END: MediaApi - uploads pictures to the Rubia server
