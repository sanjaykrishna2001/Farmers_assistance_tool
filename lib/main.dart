import 'package:farmers_assistance_tool/auth/login.dart';
import 'package:farmers_assistance_tool/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  //  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // @override
  // Widget build(BuildContext context) {
  //   return FutureBuilder(
  //     future: _initialization,
  //     builder: (context, snapshot) {
  //       // CHeck for Errors
  //       if (snapshot.hasError) {
  //         print("Something went Wrong ");
  //       }
  //       // once Completed, show your application
  //       if (snapshot.connectionState == ConnectionState.done) {
  //         return MaterialApp(
  //           title: 'Flutter Firestore CRUD',
  //           theme: ThemeData(
  //             primarySwatch: Colors.blue,
  //           ),
  //           debugShowCheckedModeBanner: false,
  //           home: login(),
  //         );
  //       }
  //       return CircularProgressIndicator();
  //     },
  //   );

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
          // HomePage(
          //   currentIndex: 3,
          //   phoneNo: "+919902513539",
          // )
          login(),
    );
  }
}
