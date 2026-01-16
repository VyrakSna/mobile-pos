import 'package:device_preview/device_preview.dart';
import 'package:first_start/screens/home_screen.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(DevicePreview(enabled: kDebugMode, builder: (context) => Myapp()));
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        useMaterial3: false,
        appBarTheme: AppBarThemeData(
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(fontSize: 16, color: Colors.black),
          iconTheme: IconThemeData(color: Colors.black),
          actionsIconTheme: IconThemeData(color: Colors.black),
          shape: LinearBorder.bottom(
            side: BorderSide(
              width: 0.65,
              color: Colors.black.withValues(alpha: 0.1),
            ),
          ),
        ),
      ),
    );
  }
}
