import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'widgets/mobile_app_frame.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase init fallback: $e");
  }
  runApp(const AgriConnectApp());
}

class AgriConnectApp extends StatelessWidget {
  const AgriConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AgriConnect',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF1E6F3D),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E6F3D),
          primary: const Color(0xFF1E6F3D),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAF8),
        fontFamily: 'Roboto',
      ),
      builder: (context, child) {
        return MobileAppFrame(child: child ?? const LoginScreen());
      },
      home: const LoginScreen(),
    );
  }
}