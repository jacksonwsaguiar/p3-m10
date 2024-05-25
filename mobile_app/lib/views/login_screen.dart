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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: usernameCtrl,
            decoration: InputDecoration(label: Text("Email")),
          ),
          TextField(
            controller: passwordCtrl,
            decoration: InputDecoration(label: Text("Password")),
          ),
          const SizedBox(height: 50),
          ElevatedButton(
              onPressed: () {
                service
                    .login(usernameCtrl.text, passwordCtrl.text)
                    .then((onValue) => Navigator.pushNamed(context, "/upload"));
              },
              child: Text("Entrar")),
          const SizedBox(height: 20),
          TextButton(
              onPressed: () => Navigator.pushNamed(context, "/signup"),
              child: Text("Cadastrar-se"))
        ],
      ),
    ));
  }
}
