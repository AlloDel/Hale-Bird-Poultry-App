// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_webview_pro/platform_interface.dart';
// // import 'package:webview_flutter/webview_flutter.dart';  //doesnot support file picking in android
// import 'package:flutter_webview_pro/webview_flutter.dart'; //support file picking in android

// class AndroidWebViewStack extends StatefulWidget {
//   const AndroidWebViewStack({Key? key}) : super(key: key);

//   @override
//   _AndroidWebViewStackState createState() => _AndroidWebViewStackState();
// }

// class _AndroidWebViewStackState extends State<AndroidWebViewStack>
//     with WidgetsBindingObserver {
//   ///
//   /// TO-DO
//   /// Add refreshindicator
//   ///
//   ///
//   var loadingPercentage = 0;
//   double? _webViewHeight;
//   bool _isPageLoading = true;
//   WebViewController? _controller;

//   @override
//   void initState() {
//     if (Platform.isAndroid) {
//       WebView.platform = SurfaceAndroidWebView();
//     }
//     super.initState();
//     WidgetsBinding.instance!.addObserver(this);
//   }

//   @override
//   void dispose() {
//     // remove listener
//     WidgetsBinding.instance!.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   void didChangeMetrics() {
//     // on portrait / landscape or other change, recalculate height
//     _setWebViewHeight();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final snackBar = SnackBar(
//       content: const Text(
//           'Pull Down Page To Refresh!'), // Text('Tap to Refresh page!'),
//       action: SnackBarAction(
//           label: 'Reload', onPressed: () => _controller!.reload()),
//     );
//     if (_webViewHeight == null) {
//       final initalWebViewHeight = MediaQuery.of(context).size.height;
//       debugPrint('WebView inital height set to: $initalWebViewHeight');
//       _webViewHeight = initalWebViewHeight;
//     }

//     return SafeArea(
//       child: WillPopScope(
//         onWillPop: _goBack,

//         // child: RefreshIndicator(
//         //   ///pull to reload page
//         //   onRefresh: () => _controller!.reload(),

//         child: Scaffold(
//           body: Stack(
//             children: [
//               /////////
//               RefreshIndicator(
//                 onRefresh: () => _controller!.reload(),
//                 child: SingleChildScrollView(
//                   // physics: const AlwaysScrollableScrollPhysics(),
//                   child: SizedBox(
//                     height: _webViewHeight,
//                     child: WebView(
//                         initialUrl: "https://halebirdpoultry.com/",
//                         onWebViewCreated: (webViewController) {
//                           _controller = webViewController;
//                         },
//                         onPageStarted: (url) {
//                           setState(() {
//                             loadingPercentage = 0;
//                             _isPageLoading = true;
//                           });
//                         },
//                         onProgress: (progress) {
//                           setState(() {
//                             loadingPercentage = progress;
//                           });
//                         },
//                         onPageFinished: (url) {
//                           setState(() {
//                             loadingPercentage = 100;
//                             _isPageLoading = false;
//                           });
//                           _setWebViewHeight();
//                         },
//                         javascriptMode: JavascriptMode.unrestricted,
//                         gestureNavigationEnabled: true,
//                         geolocationEnabled: true,
//                         onWebResourceError: (WebResourceError error) {
//                           ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                         }),
//                   ),
//                 ),
//               ),
//               ///////
//               if (loadingPercentage < 100)
//                 LinearProgressIndicator(
//                   backgroundColor: Colors.white,
//                   color: Colors.green,
//                   value: loadingPercentage / 100,
//                 ),
//             ],
//           ),
//         ),
//         ////
//         // ),
//       ),
//     );
//   }

//   Future<bool> _goBack() async {
//     bool? goBack;

//     var value = await _controller!.canGoBack();
//     if (value) {
//       _controller!.goBack();
//       return Future.value(false);
//     } else {
//       await showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Do you want to exit this app?'),
//           actions: <Widget>[
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(primary: Colors.green),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 setState(() {
//                   goBack = false;
//                 });
//               },
//               child: const Text('No'),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(primary: Colors.green),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 setState(() {
//                   goBack = true;
//                 });
//               },
//               child: const Text('Yes'),
//             ),
//           ],
//         ),
//       );
//       if (goBack == true) {
//         SystemNavigator.pop(); //
//       }
//       return goBack!;
//     }
//   }

//   void _setWebViewHeight() {
//     // we don't updage if WebView is not ready yet
//     // or page load is in progress
//     // if (_controller == null || _isPageLoading) {
//     //   return;
//     // }
//     // execute JavaScript code in the loaded page
//     // to get body height
//     _controller!
//         .evaluateJavascript('document.body.clientHeight')
//         .then((documentBodyHeight) {
//       // set height
//       setState(() {
//         debugPrint('WebView height set to: $documentBodyHeight');
//         _webViewHeight = double.parse(documentBodyHeight);
//       });
//     });
//   }
// }
