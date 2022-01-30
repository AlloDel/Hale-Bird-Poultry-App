import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart'; //support file picking in ios

class IosWebViewStack extends StatefulWidget {
  const IosWebViewStack({Key? key}) : super(key: key);

  @override
  _IosWebViewStackState createState() => _IosWebViewStackState();
}

class _IosWebViewStackState extends State<IosWebViewStack> {
  ///
  /// TO-DO
  /// Add refreshindicator
  ///
  ///
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
    final snackBar = SnackBar(
      duration: const Duration(seconds: 30),
      content:
          const Text('Check your internet!'), // Text('Tap to Refresh page!'),
      action: SnackBarAction(
          label: 'Reload',
          onPressed: () {
            _controller!.reload();
            // ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }),
    );

    return SafeArea(
      child: WillPopScope(
        onWillPop: _goBack,

        // child: RefreshIndicator(
        //   ///pull to reload page
        //   onRefresh: () => _controller!.reload(),

        child: Scaffold(
          body: Stack(
            children: [
              Positioned(child: Container()),
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
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                  javascriptMode: JavascriptMode.unrestricted,
                  gestureNavigationEnabled: true,
                  onWebResourceError: (WebResourceError error) {
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }),
              if (loadingPercentage < 100)
                LinearProgressIndicator(
                  backgroundColor: Colors.white,
                  color: Colors.green,
                  value: loadingPercentage / 100,
                ),
            ],
          ),
        ),
        ////
        // ),
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
        SystemNavigator.pop(); //
      }
      return goBack!;
    }
  }
}
