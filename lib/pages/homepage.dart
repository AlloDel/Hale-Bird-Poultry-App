import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:halebirdpoultryapp/src/android_web_view_stack.dart';
import 'package:halebirdpoultryapp/src/ios_web_view_stack.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
      () {
        if (Platform.isAndroid) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const AndroidWebViewStack()));
        } else if (Platform.isIOS) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const IosWebViewStack()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // bool lightMode =
    // MediaQuery.of(context).platformBrightness == Brightness.light;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Colors.green,
              ]),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  height: 50,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(75.0),
                  child: Image.asset(
                    "assets/app_icon.png",
                    height: 150.0,
                    width: 150.0,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(
                  height: 150,
                ),
                const Text(
                  "The farmer's choice",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    // fontStyle: FontStyle.italic,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
    // Scaffold(
    //   backgroundColor:
    //       lightMode ? const Color(0xffe1f5fe) : const Color(0xff042a49),
    //   body: Center(
    //       child: lightMode
    //           ? Image.asset('assets/splash.png')
    //           : Image.asset('assets/splash_dark.png')),
    // );
  }
}
