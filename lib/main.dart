import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'widget_tree.dart';
import 'measurement.dart';
import 'database_helper.dart';

Future<void> main() async {
  // Ensure all Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
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

  // Initialize Hive and open a box for measurements
  await Hive.initFlutter();
  Hive.registerAdapter(MeasurementAdapter());
  await Hive.openBox<Measurement>('measurements');
  await Hive.openBox<Measurement>('previous_searches');
  await DatabaseHelper.init();

  debugPrint(
      'Measurements loaded: ${DatabaseHelper.instance.fetchAllMeasurements().length}');

  // Run the app
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
