import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:firebase_core/firebase_core.dart'; // Import the login screen

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'College Complaint App',
      theme: ThemeData(
        primarySwatch: Colors.blue, // You can customize this theme as needed
      ),
      home: LoginPage(), // Set LoginScreen as the home screen
    );
  }
}
