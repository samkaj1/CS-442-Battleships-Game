import 'package:battleships/views/homepage.dart';
import 'package:battleships/views/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:battleships/utils/authmanager.dart';
import 'package:http/http.dart' as http;


class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogIn();
}

class _LogIn extends State<LogIn> {
  bool checkLogIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final loggedIn = await AuthManager.isLoggedIn();
    final response = await http.get(Uri.parse('http://165.227.117.48/games'),headers: {'Authorization' : 'Bearer ${await AuthManager.getToken()}'});
    if (mounted) {
      setState(() {
        checkLogIn = response.statusCode==200 ? loggedIn : false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Battleships',
      home: checkLogIn ? const HomePage() : const LoginPage(),
    );
  }
}




