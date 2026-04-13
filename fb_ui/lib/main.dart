import 'package:fb_ui/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Facebook UI Clone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Define the default AppBar theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 1.0,
          titleTextStyle: TextStyle(
            color: Color(0xFF1777F2), // Facebook Blue
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(
            color: Colors.black, // Color for icons like the menu button
          ),
        ),
        scaffoldBackgroundColor: const Color(
          0xFFF0F2F5,
        ), // Light grey background
      ),
      home: const LoginScreen(),
    );
  }
}
