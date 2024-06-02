import 'package:flutter/material.dart';
import 'package:mobile_app/services/user_service.dart';
import 'package:mobile_app/views/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  final service = UserService();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Login",
              style: TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 50),
            TextField(
              controller: usernameCtrl,
              decoration: const InputDecoration(label: Text("Username")),
            ),
            TextField(
              controller: passwordCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                label: Text("Password"),
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
                onPressed: () {
                  service.login(usernameCtrl.text, passwordCtrl.text).then(
                      (onValue) => Navigator.pushNamed(context, "/upload"));
                },
                child: const Text("Entrar")),
            const SizedBox(height: 20),
            TextButton(
                onPressed: () => Navigator.pushNamed(context, "/signup"),
                child: const Text("Cadastrar-se"))
          ],
        ),
      ),
    ));
  }
}
