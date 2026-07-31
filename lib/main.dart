import 'package:flutter/material.dart';
import 'views/dashboard_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const SakuSiswaApp());
}

class SakuSiswaApp extends StatelessWidget {
  const SakuSiswaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SakuSiswa',

      theme: AppTheme.lightTheme,

      home: const DashboardScreen(),
    );
  }
}