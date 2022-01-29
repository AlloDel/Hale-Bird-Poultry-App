import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:webview_flutter/webview_flutter.dart';  //doesnot support file picking in android
import 'package:flutter_webview_pro/webview_flutter.dart'; //support file picking in android

class AndroidWebViewStack extends StatefulWidget {
  const AndroidWebViewStack({Key? key}) : super(key: key);

  @override
  _AndroidWebViewStackState createState() => _AndroidWebViewStackState();
}

class _AndroidWebViewStackState extends State<AndroidWebViewStack> {
  /// TO-DO:
  /// Add (pull down to refresh)
  ///   RefreshIndicator  //add physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
  ///     and webviewcontroller.reload()
  /// When page does not load i.e,
  ///   onWebResourceError
  ///     show snackbar or [outlined arrow]
  ///         "Pull down to refresh"
  ///
  /// **********************************
  /// const snackBar = SnackBar(
  ///   content: Text('Pull Down To Refresh!'), || Text('Tap to Refresh page!'),
  ///   action: SnackBarAction(
  ///    label: 'Undo',
  ///    onPressed: () {
  ///      // Some code to undo the change.
  ///    },),
  /// );
  /// ----------------------------------
  ///   onWebResourceError: ScaffoldMessenger.of(context).showSnackBar(snackBar);
  ///
  ///***********************************
  ///
  ///
  /// Do also for IOS webview
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
                geolocationEnabled: true,
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
        SystemNavigator.pop(); //
      }
      return goBack!;
    }
  }
}
