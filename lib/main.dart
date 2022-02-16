import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:halebirdpoultryapp/pages/home.dart';
import 'package:halebirdpoultryapp/src/android_web_view_stack.dart';
import 'package:halebirdpoultryapp/src/general_view.dart';
import 'package:halebirdpoultryapp/src/ios_web_view_stack.dart';
import 'package:permission_handler/permission_handler.dart';

// import 'package:halebirdpoultryapp/pages/homepage.dart';

///removed second splash screen

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  await Permission.camera.request();
  await Permission.storage.request();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HALE BIRD POULTRY APP',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const GeneralWebview(),
      // home: const Home(),
      // home: Platform.isAndroid
      //     ? const AndroidWebViewStack()
      //     : const IosWebViewStack(),
    );
  }
}
