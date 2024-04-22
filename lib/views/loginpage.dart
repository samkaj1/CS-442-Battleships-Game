import 'dart:convert';
import 'package:battleships/views/homepage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:battleships/utils/authmanager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: userIdController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: pwController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => _authenticate(context, isLogin: true),
                  child: const Text('Log in'),
                ),
                TextButton(
                  onPressed: () => _authenticate(context, isLogin: false),
                  child: const Text('Register'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _authenticate(BuildContext context, {required bool isLogin}) async {
  final username = userIdController.text;
  final password = pwController.text;
  final url = Uri.parse(isLogin ? 'http://165.227.117.48/login' : 'http://165.227.117.48/register');
  final actionText = isLogin ? 'Login' : 'Registration';

  final response = await http.post(url, 
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'username': username, 'password': password}),
  );

  if (!mounted) return;

  if (response.statusCode == 200) {
    final sessionToken = response.body.split("\"")[3];
    await AuthManager.setToken(sessionToken);
    await AuthManager.setUserName(username);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => const HomePage(),
    ));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$actionText failed')),
    );
  }
}
}
