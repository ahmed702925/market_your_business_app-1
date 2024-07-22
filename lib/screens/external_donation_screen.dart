import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ExternalDonation extends StatefulWidget {
  @override
  _ExternalDonationState createState() => _ExternalDonationState();
}

class _ExternalDonationState extends State<ExternalDonation> {
  bool? _isLoading;
  WebViewController? controller;
  @override
  void initState() {
    super.initState();
    _isLoading = true;
  }

  @override
  Widget build(BuildContext context) {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse("https://pay.jumia.com.eg/services/donations"));
    return PopScope(
      onPopInvoked: _onBackPressed(),
      // TO DO
      // onWillPop: _onBackPressed,
      // onWillPop: () {
      //   _onBackPressed();
      //   return null;
      // },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('التبرعات الخارجية'),
          backgroundColor: Colors.blue,
        ),
        body: Stack(
          children: <Widget>[
            WebViewWidget(
              controller: controller!,
            ),
            _isLoading!
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                      Text(
                        'جاري توجيهك الى صفحة خارجية \n عن تطبيق برهان ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            backgroundColor: Colors.black54,
                            color: Colors.white,
                            fontSize: 25.0),
                      )
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => (Platform.isAndroid)
          ? new AlertDialog(
              elevation: 25.0,
              title: const Text('الخروج'),
              content: const Text('هل تريد الخروج من التبرعات الخارجية ؟'),
              actions: <Widget>[
                new GestureDetector(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Text("لا"),
                ),
                SizedBox(width: 30),
                new GestureDetector(
                  onTap: () => Navigator.of(context).pop(true),
                  child: const Text("نعم",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold)),
                ),
              ],
            )
          : CupertinoAlertDialog(
              title: const Text('الخروج'),
              content: const Text('هل تريد الخروج من التبرعات الخارجية ؟'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text("نعم",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold)),
                  isDefaultAction: true,
                  onPressed: () => Navigator.of(context).pop(true),
                ),
                CupertinoDialogAction(
                  child: const Text("لا"),
                  onPressed: () => Navigator.of(context).pop(false),
                )
              ],
            ),
    );
  }
}
