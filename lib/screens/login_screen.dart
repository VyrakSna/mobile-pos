import 'dart:convert';

import 'package:first_start/api/domain/domain.dart';
import 'package:first_start/api/end_point/api_end_point.dart';
import 'package:first_start/helper/popup_dialog.dart';
import 'package:first_start/repositories/auth_repository.dart';
import 'package:first_start/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isShowPassword = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  void togglePassword() {
    isShowPassword = !isShowPassword;
    setState(() {});
  }

  void login() async {
    PopupDialog.showLoading(context);
    final response = await http.post(
      Uri.parse(ApiDomain.domain + ApiEndPoint.login),
      body: jsonEncode({
        "email": _emailController.text,
        "password": _passwordController.text,
      }),
      headers: {"Content-Type": "application/json"},
    );
    PopupDialog.dimissLoading(context);
    final data = json.decode(response.body);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (response.statusCode == 200) {
      prefs.setString('pos.token', data['token']);
      AuthRepository.token = data['token'];
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false,
      );
    } else {
      PopupDialog.showError(
        context,
        title: 'Login Error',
        description: data['message'] ?? 'Something went wrong',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextFormField(
            controller: _emailController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email!';
              }
              if (value.contains(
                RegExp(r'/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'),
              )) {
                return "Incorrect email format!";
              }

              return null;
            },

            decoration: InputDecoration(
              fillColor: Color(0xFFF5F5F5),
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: Icon(Icons.alternate_email),
              hintText: 'Enter your email',
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _passwordController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your password";
              }
              if (value!.length < 8) {
                return "Password too short";
              }
              return null;
            },
            obscureText: !isShowPassword,
            decoration: InputDecoration(
              fillColor: Color(0xFFF5F5F5),
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: Icon(Icons.key),
              hintText: 'Enter your password',
              suffixIcon: IconButton(
                onPressed: togglePassword,
                icon: Icon(
                  isShowPassword ? Icons.visibility : Icons.visibility_off,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),

          TextButton(
            onPressed: login,
            child: Text(
              'Log In',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }
}
