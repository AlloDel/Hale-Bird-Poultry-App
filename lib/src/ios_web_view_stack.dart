import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart'; //support file picking in ios

class IosWebViewStack extends StatefulWidget {
  const IosWebViewStack({Key? key}) : super(key: key);

  @override
  _IosWebViewStackState createState() => _IosWebViewStackState();
}

class _IosWebViewStackState extends State<IosWebViewStack> {
  var loadingPercentage = 0;

  WebViewController? _controller;

  @override
  void initState() {
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: _goBack,
        child: Scaffold(
          body: Stack(
            children: [
              WebView(
                initialUrl: "https://halebirdpoultry.com/",
                onWebViewCreated: (webViewController) {
                  _controller = webViewController;
                },
                onPageStarted: (url) {
                  setState(() {
                    loadingPercentage = 0;
                  });
                },
                onProgress: (progress) {
                  setState(() {
                    loadingPercentage = progress;
                  });
                },
                onPageFinished: (url) {
                  setState(() {
                    loadingPercentage = 100;
                  });
                },
                javascriptMode: JavascriptMode.unrestricted,
                gestureNavigationEnabled: true,
              ),
              if (loadingPercentage < 100)
                LinearProgressIndicator(
                  backgroundColor: Colors.white,
                  color: Colors.green,
                  value: loadingPercentage / 100,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _goBack() async {
    bool? goBack;

    var value = await _controller!.canGoBack();
    if (value) {
      _controller!.goBack();
      return Future.value(false);
    } else {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Do you want to exit this app?'),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.green),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  goBack = false;
                });
              },
              child: const Text('No'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.green),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  goBack = true;
                });
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );
      if (goBack == true) {
        Navigator.pop(context);
      }
      return goBack!;
    }
  }
}
