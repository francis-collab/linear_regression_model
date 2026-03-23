import 'package:flutter/material.dart';
import 'prediction_screen.dart';

void main() {
  runApp(const YouthUnemploymentApp());
}

class YouthUnemploymentApp extends StatelessWidget {
  const YouthUnemploymentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Youth Unemployment Predictor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      home: const PredictionScreen(),
    );
  }
}