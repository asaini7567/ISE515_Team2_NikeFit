import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'widget_tree.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAuWZ_n0yT3E_oS9wsXi_sQMt3ajZUclWs",
      authDomain: "nike-fit-website.firebaseapp.com",
      projectId: "nike-fit-website",
      storageBucket: "nike-fit-website.firebasestorage.app",
      messagingSenderId: "474939447196",
      appId: "1:474939447196:web:b52985c99c4acafdf8da59",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nike Fit - Team 2',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WidgetTree(), // Set SignInScreen as the home screen
    );
  }
}
