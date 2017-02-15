import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'presentation/pages/form_input_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Input Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const FormInputPage(),
    );
  }
}
