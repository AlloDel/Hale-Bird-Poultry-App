// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_webview_pro/platform_interface.dart';
// // import 'package:webview_flutter/webview_flutter.dart';  //doesnot support file picking in android
// import 'package:flutter_webview_pro/webview_flutter.dart'; //support file picking in android

// class AndroidWebViewStack extends StatefulWidget {
//   const AndroidWebViewStack({Key? key}) : super(key: key);

//   @override
//   _AndroidWebViewStackState createState() => _AndroidWebViewStackState();
// }

// class _AndroidWebViewStackState extends State<AndroidWebViewStack> {
//   ///
//   /// TO-DO
//   /// Add refreshindicator
//   ///
//   ///
//   var loadingPercentage = 0;

//   WebViewController? _controller;
//   bool? isError = false;

//   @override
//   void initState() {
//     if (Platform.isAndroid) {
//       WebView.platform = SurfaceAndroidWebView();
//     }
//     super.initState();
//   }

//   void _launchURL(String? url) async {
//     if (await canLaunch(url!)) {
//       await launch(
//         url,
//         // universalLinksOnly: true,
//       );
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     ///
//     ///
//     final snackBar = SnackBar(
//       duration: const Duration(seconds: 30),
//       content:
//           const Text('Check your internet!'), // Text('Tap to Refresh page!'),
//       action: SnackBarAction(
//           label: 'Reload',
//           onPressed: () {
//             _controller!.reload();
//             // ScaffoldMessenger.of(context).hideCurrentSnackBar();
//           }),
//     );

//     ///
//     ///
//     return SafeArea(
//       child: WillPopScope(
//         onWillPop: _goBack,
//         child: Scaffold(
//           body: Stack(
//             children: [
//               // Positioned(child: Container()),
//               // if (isError == false)
//               WebView(
//                 initialUrl: "https://halebirdpoultry.com/login",
//                 onWebViewCreated: (webViewController) {
//                   _controller = webViewController;
//                 },
//                 onPageStarted: (url) {
//                   setState(() {
//                     loadingPercentage = 0;
//                   });
//                 },
//                 onProgress: (progress) {
//                   setState(() {
//                     loadingPercentage = progress;
//                   });

//                   _controller!.evaluateJavascript(
//                       "document.getElementsByClassName('footer')[0].style.display='none';");
//                 },
//                 onPageFinished: (url) {
//                   setState(() {
//                     loadingPercentage = 100;
//                     // isError = false;
//                   });

//                   ScaffoldMessenger.of(context).hideCurrentSnackBar();
//                 },
//                 navigationDelegate: (NavigationRequest request) {
//                   if (request.url.contains('mailto:')) {
//                     _launchURL(request.url);
//                     return NavigationDecision.prevent;
//                   }
//                   if (request.url.contains('instagram')) {
//                     _launchURL(
//                         "https://instagram.com/halebirdzpoultry?utm_medium=copy_link.scheme");
//                     return NavigationDecision.prevent;
//                   }
//                   if (request.url.contains('wa.me')) {
//                     _launchURL(request.url);
//                     return NavigationDecision.prevent;
//                   }
//                   //-------------------------------------------------------//
//                   // debugPrint("ISERROR in NAVIGATION DECISION : $isError");
//                   // if (isError == true) {
//                   //   setState(() {});
//                   //   checkError();
//                   //   return NavigationDecision.prevent;
//                   // }
//                   //--------------------------------------------------------//
//                   return NavigationDecision.navigate;
//                 },
//                 onWebResourceError: (WebResourceError error) {
//                   checkError();
//                   // setState(() {
//                   //   isError = true;
//                   // });
//                   // debugPrint("ISERROR in WEBSOURCE ERROR : $isError");
//                   // _controller!.reload();
//                   // ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                 },
//                 javascriptMode: JavascriptMode.unrestricted,
//                 gestureNavigationEnabled: true,
//                 geolocationEnabled: true,
//               ),
//               if (loadingPercentage < 100)
//                 LinearProgressIndicator(
//                   backgroundColor: Colors.white,
//                   color: Colors.green,
//                   value: loadingPercentage / 100,
//                 ),

//               // if (isError == true)
//               //   Center(
//               //     child: Padding(
//               //       padding: const EdgeInsets.all(32),
//               //       child: TextButton(
//               //         onPressed: () {
//               //           // _controller!.reload();
//               //           setState(() {
//               //             isError = false;
//               //           });
//               //         },
//               //         child: const Text(
//               //           '''Something went wrong!\nCheck your internet and\nTap to reload''',
//               //           textAlign: TextAlign.center,
//               //         ),
//               //       ),
//               //     ),
//               //   )
//             ],
//           ),
//         ),
//         ////
//         // ),
//       ),
//     );
//   }

//   checkError() async {
//     await showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Center(
//           child: Icon(
//             Icons.error,
//             color: Colors.green,
//             size: 48,
//           ),
//         ),
//         content: Container(
//           padding: const EdgeInsets.all(8),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: const [
//               Center(
//                 child: Text(
//                   'Something went wrong!',
//                   style: TextStyle(
//                     color: Colors.blueGrey,
//                     fontSize: 16.0,
//                   ),
//                 ),
//               ),
//               Center(
//                 child: Text(
//                   'Check your internet!',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.blueGrey,
//                     fontSize: 16.0,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         actionsPadding: const EdgeInsets.all(12),
//         actionsAlignment: MainAxisAlignment.center,
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               Navigator.of(context, rootNavigator: true).pop();
//               _controller!.reload();
//             },
//             child: const Text("Refresh",
//                 style: TextStyle(fontSize: 16, color: Colors.blueGrey)),
//           ),
//         ],
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
//           title: const Center(
//             child: CircleAvatar(
//               radius: 32,
//               backgroundColor: Colors.green,
//               child: Icon(
//                 Icons.exit_to_app,
//                 color: Colors.white,
//                 size: 36,
//               ),
//             ),
//           ),
//           content: Container(
//             height: MediaQuery.of(context).size.height * 0.2,
//             width: MediaQuery.of(context).size.width * 0.6,
//             padding: const EdgeInsets.all(8),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: const [
//                 Center(
//                   child: Text(
//                     'Exit',
//                     style: TextStyle(
//                       color: Colors.blueGrey,
//                       fontSize: 18.0,
//                     ),
//                   ),
//                 ),
//                 Center(
//                   child: Text(
//                     'Are you sure you want to exit the app?',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Colors.blueGrey,
//                       fontSize: 16.0,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           actionsPadding: const EdgeInsets.all(12),
//           actionsAlignment: MainAxisAlignment.spaceAround,
//           actions: <Widget>[
//             SizedBox(
//               // width: MediaQuery.of(context).size.width * 0.20,
//               child: TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   setState(() {
//                     goBack = true;
//                   });
//                 },
//                 child: const Text("Yes",
//                     style: TextStyle(fontSize: 16, color: Colors.blueGrey)),
//               ),
//             ),
//             SizedBox(
//               // width: MediaQuery.of(context).size.width * 0.20,
//               child: TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   setState(() {
//                     goBack = false;
//                   });
//                 },
//                 child: const Text("No",
//                     style: TextStyle(fontSize: 16, color: Colors.blueGrey)),
//               ),
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
// }
