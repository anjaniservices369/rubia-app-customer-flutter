// =============================================================================
// WHAT : Shows Rubia's Terms and Conditions, Privacy Policy or Refund Policy
//        inside the app. The text is written by the Rubia team in the admin
//        dashboard (Customers > Terms & Policies) and loaded from the server.
// NOTES: Server: /api/user/legal-page?type=terms|privacy|refund (no login, so
//        it also works from the login screen). The text is HTML from the
//        dashboard's editor; it is drawn with scripts switched off and links
//        blocked, so it can only be read.
// =============================================================================
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

import '../constants/apiConstants.dart';
import '../constants/constants.dart';

// >>> START: LegalDocumentPage - a Terms / Privacy / Refund text loaded from the server
class LegalDocumentPage extends StatefulWidget {
  const LegalDocumentPage({Key? key, required this.type, required this.title})
      : super(key: key);

  /// 'terms', 'privacy' or 'refund'.
  final String type;
  final String title;

  static const String terms = 'terms';
  static const String privacy = 'privacy';
  static const String refund = 'refund';

  /// Opens the document on top of the current screen.
  static Future<void> open(BuildContext context, String type, String title) {
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => LegalDocumentPage(type: type, title: title)));
  }

  @override
  State<LegalDocumentPage> createState() => _LegalDocumentPageState();
}

class _LegalDocumentPageState extends State<LegalDocumentPage> {
  WebViewController? _controller;
  String? _title;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  // >>> START: _load - fetches the text from the server and shows it
  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await http
          .get(Uri.parse('$apiBaseUrl$LEGAL_PAGE${widget.type}'))
          .timeout(const Duration(seconds: 20));
      final body = json.decode(res.body);
      if (body is Map && body['status'] == 'OK' && body['details'] is Map) {
        final d = body['details'] as Map;
        final controller = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.disabled)
          ..setBackgroundColor(Colors.white)
          ..setNavigationDelegate(NavigationDelegate(
              onNavigationRequest: (_) => NavigationDecision.prevent))
          ..loadHtmlString(
              _page('${d['description']}', '${d['updated_on'] ?? ''}'));
        if (!mounted) return;
        setState(() {
          _title = '${d['title'] ?? ''}'.trim();
          _controller = controller;
          _loading = false;
        });
        return;
      }
      if (!mounted) return;
      setState(() {
        // The server says why (for example the page is not published yet).
        _error = body is Map && body['error'] != null
            ? '${body['error']}'
            : 'This page could not be loaded.';
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error =
            'This page could not be loaded. Check your internet connection.';
        _loading = false;
      });
    }
  }
  // <<< END: _load - fetches the text from the server and shows it

  // >>> START: _page - wraps the dashboard text in a readable phone page
  String _page(String body, String updated) => '''
<!DOCTYPE html><html><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
body{font-family:sans-serif;color:#1b2a49;background:#ffffff;font-size:16px;line-height:1.65;margin:0;padding:20px 20px 36px;}
h1,h2,h3,h4{color:#144272;line-height:1.3;margin-top:1.4em;margin-bottom:.55em;}
h1{font-size:26px;} h2{font-size:21px;} h3{font-size:18px;} h4{font-size:16px;}
p,li{margin-top:.45em;margin-bottom:.65em;}
ul,ol{padding-left:1.4em;}
img,table{max-width:100%;height:auto;} table{border-collapse:collapse;display:block;overflow-x:auto;}
th,td{padding:8px;border:1px solid #e5eaf0;} a{color:#144272;}
blockquote{margin:1em 0;padding:10px 14px;border-left:3px solid #ff8f0c;background:#fff8ed;}
.updated{color:#757575;font-size:12px;margin-top:28px;border-top:1px solid #e5eaf0;padding-top:12px;}
</style></head><body>$body
${updated.isEmpty ? '' : '<p class="updated">Last updated: $updated</p>'}
</body></html>''';
  // <<< END: _page - wraps the dashboard text in a readable phone page

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tBackground,
      appBar: AppBar(
        backgroundColor: tYellow,
        elevation: 0,
        iconTheme: IconThemeData(color: tDarkNavyblue),
        title: Text(
            (_title != null && _title!.isNotEmpty) ? _title! : widget.title,
            style: TextStyle(
              color: tDarkNavyblue,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            )),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(color: tPrimaryColor),
            )
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: tWhite,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: const [tBoxShadow],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: tPrimaryColor.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.description_outlined,
                                size: 32,
                                color: tPrimaryColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _error!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: tDarkNavyblue,
                                fontSize: 15,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: tPrimaryColor,
                                  foregroundColor: tWhite,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: _load,
                                child: const Text(
                                  'Try again',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Container(
                  color: tWhite,
                  child: WebViewWidget(controller: _controller!),
                ),
    );
  }
}
// <<< END: LegalDocumentPage - a Terms / Privacy / Refund text loaded from the server
