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
          TextButton(
              onPressed: () {
                service
                    .login(usernameCtrl.text, passwordCtrl.text)
                    .then((onValue) => Navigator.pushNamed(context, "/login"));
              },
              child: Text("Cadastrar"))
        ],
      ),
    ));
  }
}
