import 'package:first_start/repositories/auth_repository.dart';
import 'package:first_start/screens/home_screen.dart';
import 'package:first_start/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() async {
    await Future.delayed(Duration(seconds: 2));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('pos.token'); //GET TOKEN
    AuthRepository.token = token;
    if (token == null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FlutterLogo(size: 86),
            SizedBox(height: 20),
            CupertinoActivityIndicator(),
          ],
        ),
      ),
    );
  }
}
