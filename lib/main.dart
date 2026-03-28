import 'package:flutter/material.dart';
import 'auth/login.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web Auth',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins', // Ensure this is in your pubspec.yaml
      ),
      home: const LoginPage(), 
    );
  }
}