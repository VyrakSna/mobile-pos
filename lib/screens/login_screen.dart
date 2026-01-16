import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    final response = await http.post(
      Uri.parse('https://49231011d00b.ngrok-free.app/auth/login'),
      body: jsonEncode({
        "email": _emailController.text,
        "password": _passwordController.text,
      }),
      headers: {
        "Content-Type": "application/json"
      }
    );
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
