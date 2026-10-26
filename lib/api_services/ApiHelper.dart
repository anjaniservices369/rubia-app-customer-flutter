// =============================================================================
// WHAT : The single place that talks to the Rubia server over the internet
//        (GET/POST).
// NOTES: Adds the login token, retries safe calls once, shows 'Check Internet'
//        on failure, and sends a rejected session to SessionGuard. Every API
//        call goes through here.
// =============================================================================
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:base_project_flutter/api_services/sessionGuard.dart';
import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:base_project_flutter/constants/apiConstants.dart';
import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// >>> START: ApiHelper - the one door to the Rubia server: sends requests, handles errors and expired logins
/// Shared HTTP helpers.
///
/// Every request returns the decoded JSON, or `null` when the request failed
/// (no network, timeout, bad reply, non-200). Callers must handle `null`.
/// A reply that rejects the session is routed to [SessionGuard].
class ApiHelper {
  // No request may take longer than 30 seconds.
  static const Duration _timeout = Duration(seconds: 30);

  // >>> START: getTypePost - sends form data to the server (POST) and returns its reply
  /// POST (multipart form) to [uri]; shows a message and returns null on failure.
  /// Set [idempotent] only for calls that are safe to repeat: they are retried
  /// once when the connection drops.
  getTypePost(BuildContext context, String uri, Map<String, String> params,
      {bool idempotent = false}) async {
    return _send(context, uri, () async {
      // Build a form (multipart) POST to  <server address> + <endpoint path>.
      final request = http.MultipartRequest('POST', Uri.parse(apiBaseUrl + uri));
      // Put the form fields (mobile number, OTP, booking details...) in it.
      request.fields.addAll(params);
      // Send it and read the whole reply.
      return http.Response.fromStream(await request.send());
    }, retry: idempotent);
  }
  // <<< END: getTypePost - sends form data to the server (POST) and returns its reply

  // >>> START: getTypePostBG - same as getTypePost but silent, for work done in the background
  /// Same as [getTypePost] without a UI context (background work): errors are
  /// swallowed and null is returned.
  getTypePostBG(String uri, Map<String, String> params) async {
    try {
      // Build and send the form POST exactly like getTypePost.
      final request = http.MultipartRequest('POST', Uri.parse(apiBaseUrl + uri));
      request.fields.addAll(params);
      final response =
          await http.Response.fromStream(await request.send()).timeout(_timeout);
      // Anything other than HTTP 200 is treated as "no answer".
      if (response.statusCode != 200) return null;
      // Decode the JSON reply and run the expired-login check.
      final jsonMap = json.decode(response.body);
      if (uri.contains('auth_code')) await SessionGuard.handle(jsonMap);
      return jsonMap;
    } catch (e) {
      // Background work must never crash the app: log and give up quietly.
      debugPrint('getTypePostBG($uri) failed: $e');
      return null;
    }
  }
  // <<< END: getTypePostBG - same as getTypePost but silent, for work done in the background

  // >>> START: getTypeGet - asks the server for data (GET) and returns its reply
  /// GET [uri]; shows a message and returns null on failure.
  getTypeGet(BuildContext context, String uri) async {
    // A GET only reads data, so it is always safe to retry once.
    return _send(context, uri, () => http.get(Uri.parse(apiBaseUrl + uri)),
        retry: true);
  }
  // <<< END: getTypeGet - asks the server for data (GET) and returns its reply

  // Runs one request and turns every possible failure into "null + a message".
  // >>> START: _send - runs one request: time limit, one retry if the connection drops, error messages, expired-login check
  Future<dynamic> _send(BuildContext context, String uri,
      Future<http.Response> Function() request,
      {bool retry = false}) async {
    try {
      http.Response response;
      try {
        // 1. Make the request with the 30 second limit.
        response = await request().timeout(_timeout);
      } on http.ClientException {
        // 2. A dropped connection: repeat once when the call is safe to repeat.
        if (!retry) rethrow;
        response = await request().timeout(_timeout);
      }
      // 3. Any HTTP code other than 200 (not found, server error...) is shown
      //    to the user by Twl.errorHandler.
      if (response.statusCode != 200) {
        Twl.errorHandler(context, response.statusCode);
        return null;
      }
      // 4. Decode the JSON reply.
      final jsonMap = json.decode(response.body);
      // 5. If the reply says the login is invalid, sign the customer out.
      if (uri.contains('auth_code')) await SessionGuard.handle(jsonMap);
      return jsonMap;
    } on SocketException {
      // No internet.
      _showNetworkError(context);
    } on TimeoutException {
      // The server did not answer in 30 seconds.
      _showNetworkError(context);
    } on http.ClientException catch (e) {
      // The connection was cut while talking to the server.
      debugPrint('Request to $uri failed: $e');
      _showNetworkError(context);
    } on FormatException catch (e) {
      // The server answered with something that is not valid JSON.
      debugPrint('Unreadable reply from $uri: $e');
      _showNetworkError(context);
    }
    return null;
  }
  // <<< END: _send - runs one request: time limit, one retry if the connection drops, error messages, expired-login check

  // Shows the short "Check Internet" message at the bottom of the screen.
  // >>> START: _showNetworkError - tells the user the internet is not working
  void _showNetworkError(BuildContext context) {
    // The screen may have closed while we were waiting.
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Check Internet')),
    );
  }
  // <<< END: _showNetworkError - tells the user the internet is not working

  // >>> START: getHeader - prepares the login header, first confirming the saved login is still valid
  /// Headers for an authenticated call. The stored `auth_code` is verified with
  /// the `check` endpoint first, so a dead session is cleared before use.
  getHeader(BuildContext context) async {
    // 1. Read the login code saved on the phone ('1' means "not logged in").
    final prefs = await SharedPreferences.getInstance();
    final authCode = prefs.getString('authCode') ?? '1';
    try {
      // 2. Ask the server whether this login is still valid ...
      final res = await UserAPI().checkApi(authCode);
      // 3. ... and sign the customer out if it is not.
      await SessionGuard.handle(res);
    } catch (e) {
      debugPrint('getHeader: session check failed: $e');
    }
    // 4. Return the header carrying the login code.
    return _headers(authCode);
  }
  // <<< END: getHeader - prepares the login header, first confirming the saved login is still valid

  // >>> START: getHeaderBG - same as getHeader but without checking (for background work)
  /// Same as [getHeader] for code that has no UI context.
  getHeaderBG() async {
    final prefs = await SharedPreferences.getInstance();
    return _headers(prefs.getString('authCode') ?? '1');
  }
  // <<< END: getHeaderBG - same as getHeader but without checking (for background work)

  // The header every authenticated request carries; 'auth_code' identifies the
  // customer to the server.
  // >>> START: _headers - builds the header that carries the customer's login code
  Map<String, String> _headers(String authCode) => {
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
        'Accept': ' application/json',
        'Accept-Encoding': 'gzip, deflate, br',
        'auth_code': authCode,
      };
  // <<< END: _headers - builds the header that carries the customer's login code
}
// <<< END: ApiHelper - the one door to the Rubia server: sends requests, handles errors and expired logins
