import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:flutter_webview_pro/platform_interface.dart';
// import 'package:webview_flutter/webview_flutter.dart';  //doesnot support file picking in android
// import 'package:flutter_webview_pro/webview_flutter.dart'; //support file picking in android

class GeneralWebview extends StatefulWidget {
  const GeneralWebview({Key? key}) : super(key: key);

  @override
  _GeneralWebviewState createState() => _GeneralWebviewState();
}

class _GeneralWebviewState extends State<GeneralWebview> {
  /// TO-DO
  /// Add refreshindicator
  ///

  InAppWebViewController? webViewController;
  String? urlink;
  double loadingPercentage = 0;
  bool? isError = false;
  PullToRefreshController? pullToRefreshController;

  @override
  void initState() {
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.green,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
    super.initState();
  }

  void _launchURL(String? url) async {
    if (await canLaunch(url!)) {
      await launch(
        url,
        // universalLinksOnly: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    ///
    // final snackBar = SnackBar(
    //   duration: const Duration(seconds: 30),
    //   content:
    //       const Text('Check your internet!'), // Text('Tap to Refresh page!'),
    //   action: SnackBarAction(
    //       label: 'Reload',
    //       onPressed: () {
    //         _controller!.reload();
    //         // ScaffoldMessenger.of(context).hideCurrentSnackBar();
    //       }),
    // );
    ///

    return SafeArea(
      child: WillPopScope(
        onWillPop: _goBack,
        child: Scaffold(
          body: Stack(
            children: [
              // if (isError == false)
              InAppWebView(
                initialUrlRequest: URLRequest(
                    url: Uri.parse("https://halebirdpoultry.com/login")),

                initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      useShouldOverrideUrlLoading: true,
                      mediaPlaybackRequiresUserGesture: false,
                    ),
                    android: AndroidInAppWebViewOptions(
                      useHybridComposition: true,
                    ),
                    ios: IOSInAppWebViewOptions(
                      allowsInlineMediaPlayback: true,
                    )),

                // initialUrl: "https://halebirdpoultry.com/login",
                pullToRefreshController: pullToRefreshController,

                onWebViewCreated: (controller) {
                  webViewController = controller;
                },

                // onPageStarted: (url) {
                onLoadStart: (controller, url) {
                  setState(() {
                    urlink = url.toString();
                    isError = false;
                  });
                },
                androidOnPermissionRequest:
                    (controller, origin, resources) async {
                  return PermissionRequestResponse(
                      resources: resources,
                      action: PermissionRequestResponseAction.GRANT);
                },

                shouldOverrideUrlLoading:
                    (webViewController, navigationAction) async {
                  var uri = navigationAction.request.url!.toString();
                  debugPrint("URI at navigation = $uri");

                  if (uri.contains('mailto:')) {
                    _launchURL(uri);
                    // and cancel the request
                    return NavigationActionPolicy.CANCEL;
                  }
                  if (uri.contains('instagram.com')) {
                    _launchURL(uri);
                    // and cancel the request
                    return NavigationActionPolicy.CANCEL;
                  }
                  if (uri.contains('facebook.com')) {
                    _launchURL(uri);
                    // and cancel the request
                    return NavigationActionPolicy.CANCEL;
                  }
                  if (isError == true) {
                    // checkError();
                    return NavigationActionPolicy.CANCEL;
                  }
                  return NavigationActionPolicy.ALLOW;
                },

                onLoadStop: (controller, url) => webViewController!
                    .evaluateJavascript(
                        source:
                            "document.getElementsByClassName('footer')[0].style.display='none';"),

                onLoadError: (controller, url, code, message) {
                  // pullToRefreshController!.endRefreshing();
                  setState(() {
                    isError = true;
                  });
                  webViewController!.stopLoading();
                  errorCheck();
                  // checkError();
                },
                onLoadHttpError: (controller, url, statusCode, description) {
                  // pullToRefreshController!.endRefreshing();
                  setState(() {
                    isError = true;
                  });
                  webViewController!.stopLoading();
                  errorCheck();
                  // checkError();
                },

                // onWebResourceError: (WebResourceError error) {
                //   setState(() {
                //     isError = true;
                //   });
                //   debugPrint("ISERROR in WEBSOURCE ERROR : $isError");
                //   // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                // },
                // onProgress: (progress) {

                onProgressChanged: (controller, progress) {
                  if (progress == 100) {
                    pullToRefreshController!.endRefreshing();
                  }
                  setState(() {
                    loadingPercentage = progress / 100;
                  });
                },

                // javascriptMode: JavascriptMode.unrestricted,
                // gestureNavigationEnabled: true,
                // geolocationEnabled: true,
              ),

              // PROGRESS INDICATOR REMOVED
              // if (loadingPercentage < 1)
              //   LinearProgressIndicator(
              //     backgroundColor: Colors.white,
              //     color: Colors.green,
              //     value: loadingPercentage,
              //   ),
              // if (isError == true)
              //   Center(
              //     child: Container(
              //       color: Colors.transparent,
              //       padding: const EdgeInsets.all(32),
              //       height: MediaQuery.of(context).size.height * 0.95,
              //       width: MediaQuery.of(context).size.width * 0.95,
              //       child: TextButton(
              //         onPressed: () {
              //           webViewController!.reload();
              //           setState(() {
              //             isError = false;
              //           });
              //         },
              //         child: const Text(
              //           '''Something went wrong!\n\nCheck your internet!\n\nTap to reload''',
              //           textAlign: TextAlign.center,
              //           style: TextStyle(fontSize: 16),
              //         ),
              //       ),
              //     ),
              //   )
            ],
          ),
          /////------for debugging errordialog-------/////
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     errorCheck();
          //   },
          //   child: const Icon(Icons.ac_unit),
          // ),
        ),
        ////
        // ),
      ),
    );
  }

  Future<bool> _goBack() async {
    bool? goBack;

    var value = await webViewController!.canGoBack();
    if (value) {
      webViewController!.goBack();
      return Future.value(false);
    } else {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Center(
            child: CircleAvatar(
              radius: 32,
              backgroundColor: Colors.green,
              child: Icon(
                Icons.exit_to_app,
                color: Colors.white,
                size: 36,
              ),
            ),
          ),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.6,
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Center(
                  child: Text(
                    'Exit',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Are you sure you want to exit the app?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.all(12),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: <Widget>[
            SizedBox(
              // width: MediaQuery.of(context).size.width * 0.20,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    goBack = true;
                  });
                },
                child: const Text("Yes",
                    style: TextStyle(fontSize: 16, color: Colors.blueGrey)),
              ),
            ),
            SizedBox(
              // width: MediaQuery.of(context).size.width * 0.20,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    goBack = false;
                  });
                },
                child: const Text("No",
                    style: TextStyle(fontSize: 16, color: Colors.blueGrey)),
              ),
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

  // checkError() async {
  //   await showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       content: Container(
  //         color: Colors.white,
  //         width: MediaQuery.of(context).size.width * 0.9,
  //         height: MediaQuery.of(context).size.height * 0.9,
  //         padding: const EdgeInsets.all(8),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           // crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             const Center(
  //               child: Icon(
  //                 Icons.error,
  //                 color: Colors.green,
  //                 size: 54,
  //               ),
  //             ),
  //             SizedBox(
  //               width: MediaQuery.of(context).size.width * 0.95,
  //               height: MediaQuery.of(context).size.width * 0.2,
  //               child: Container(),
  //             ),
  //             const Center(
  //               child: Text(
  //                 'Something went wrong!',
  //                 style: TextStyle(
  //                   color: Colors.blueGrey,
  //                   fontSize: 16.0,
  //                 ),
  //               ),
  //             ),
  //             SizedBox(
  //               width: MediaQuery.of(context).size.width * 0.95,
  //               height: MediaQuery.of(context).size.width * 0.1,
  //               child: Container(),
  //             ),
  //             const Center(
  //               child: Text(
  //                 'Check your internet!',
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(
  //                   color: Colors.blueGrey,
  //                   fontSize: 16.0,
  //                 ),
  //               ),
  //             ),
  //             SizedBox(
  //               width: MediaQuery.of(context).size.width * 0.95,
  //               height: MediaQuery.of(context).size.width * 0.7,
  //               child: Container(),
  //             ),
  //             Center(
  //               child: TextButton(
  //                 onPressed: () {
  //                   webViewController!.reload();
  //                   Navigator.of(context, rootNavigator: true).pop();
  //                 },
  //                 child: const Text(
  //                   "Refresh",
  //                   style: TextStyle(fontSize: 16, color: Colors.blueGrey),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  errorCheck() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Dialog(
        insetAnimationDuration: const Duration(milliseconds: 1),
        insetPadding: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        //this right here
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.98,
          width: MediaQuery.of(context).size.width * 0.98,
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
                  color: Colors.green,
                ),
                height: MediaQuery.of(context).size.height * 0.3,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    // const Divider(),
                    Center(
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.white,
                        size: 96,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.25,
                        child: Container(),
                      ),
                      const Center(
                        child: Text(
                          'Something went wrong!',
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.2,
                        child: Container(),
                      ),
                      const Center(
                        child: Text(
                          'Check your internet!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.3,
                        child: Container(),
                      ),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: Colors.green,
                          ),
                          child: TextButton(
                            onPressed: () {
                              webViewController!.reload();
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: const Text(
                              "Refresh",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
