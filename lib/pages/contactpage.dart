// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:halebirdpoultryapp/pages/homepage.dart';
// import 'package:halebirdpoultryapp/src/web_view_stack.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
//       overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: Init.instance.initialize(),
//       builder: (context, AsyncSnapshot snapshot) {
//         // Show splash screen while waiting for app resources to load:
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const MaterialApp(home: Splash());
//         } else {
//           // Loading is done, return the app:
//           return MaterialApp(
//             debugShowCheckedModeBanner: false,
//             title: 'HALE BIRD POULTRY APP',
//             theme: ThemeData(
//               primarySwatch: Colors.blue,
//             ),
//             // Main app begins to run
//             home: const WebViewStack(),
//           );
//         }
//       },
//     );
//   }
// }

// class Init {
//   Init._();
//   static final instance = Init._();

//   Future initialize() async {
//     // This is where you can initialize the resources needed by your app while
//     // the splash screen is displayed.  Remove the following example because
//     // delaying the user experience is a bad design practice!
//     await Future.delayed(const Duration(seconds: 2));
//   }
// }
