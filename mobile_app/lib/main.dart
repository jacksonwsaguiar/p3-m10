import 'package:flutter/material.dart';
import 'package:mobile_app/views/login_screen.dart';
import 'package:mobile_app/views/signup_screen.dart';
import 'package:mobile_app/views/upload_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Filter App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: LoginScreen(),
      initialRoute: "/login",
      routes: {
        "/login": (context) => LoginScreen(),
        "/signup": (context) => SignUpScreen(),
        "/upload": (context) => UploadImageScreen(),
      },
    );
  }
}
