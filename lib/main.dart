import 'package:flutter/material.dart';

import 'package:babyshop/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BabyShopHub',
      // Global background: Clean off-white/cream with very subtle teal tint
      builder: (context, child) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF5F9FA), // Soft almost-white teal
          ),
          child: child,
        );
      },
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        useMaterial3: true,
        // Primary Teal Color
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF53D3D1), // Teal
          primary: const Color(0xFF53D3D1),
          surface: const Color(0xFFF5F9FA),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF263238), // Dark button text/bg contrast if needed
            foregroundColor: Colors.white,
            elevation: 0,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
