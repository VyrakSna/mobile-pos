import 'dart:convert';

import 'package:first_start/api/domain/domain.dart';
import 'package:first_start/api/end_point/api_end_point.dart';
import 'package:first_start/helper/popup_dialog.dart';
import 'package:first_start/repositories/auth_repository.dart';
import 'package:first_start/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isShowPassword = false;
  // final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

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
        // can change to email vh
        "username": _usernameController.text,
        "password": _passwordController.text,
      }),
      headers: {"Content-Type": "application/json"},
    );
    PopupDialog.dimissLoading(context);
    final data = json.decode(response.body);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (response.statusCode == 201) {
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
      appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent),
      body: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              // Lottie animation
              Lottie.asset('lotties/login.json', height: 180),

              const SizedBox(height: 32),

              // Title
              const Text(
                'Welcome Back',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                'Log in to continue',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Color(0xFF6A7282)),
              ),

              const SizedBox(height: 36),

              // Email field
              TextFormField(
                controller: _usernameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email!';
                  }
                  // enable this for email validation

                  // if (value.contains(
                  //   RegExp(
                  //     r'/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                  //   ),
                  // )) {
                  //   return "Incorrect email format!";
                  // }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Username',
                  hintText: 'John123',
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.verified_user),
                ),
              ),

              const SizedBox(height: 16),

              // Password field
              TextFormField(
                controller: _passwordController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your password";
                  }
                  if (value.length < 3) {
                    return "Password too short";
                  }
                  return null;
                },
                obscureText: !isShowPassword,
                decoration: InputDecoration(
                  labelText: 'Enter your Password',
                  hintText: '••••••••',
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.key),
                  suffixIcon: IconButton(
                    onPressed: togglePassword,
                    icon: Icon(
                      isShowPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Login button
              TextButton(
                onPressed: login,
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
