import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'presentation/pages/form_input_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp();
  }

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
