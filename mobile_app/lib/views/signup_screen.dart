import 'package:flutter/material.dart';
import 'package:mobile_app/services/user_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
            Text(
              "Cadastro",
              style: TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 50),
            TextField(
              controller: usernameCtrl,
              decoration: InputDecoration(label: Text("Username")),
            ),
            TextField(
              controller: passwordCtrl,
              obscureText: true,
              decoration: InputDecoration(label: Text("Password")),
            ),
            const SizedBox(height: 50),
            TextButton(
                onPressed: () {
                  service.register(usernameCtrl.text, passwordCtrl.text).then(
                      (onValue) => Navigator.pushNamed(context, "/login"));
                },
                child: Text("Cadastrar"))
          ],
        ),
      ),
    ));
  }
}
