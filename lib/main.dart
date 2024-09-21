import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geekhaven/Navbar/BottomNav.dart';
import 'package:geekhaven/Pages/Login.dart';
import 'package:geekhaven/Pages/suggestion_page.dart';
import 'package:geekhaven/Theme/theme_provider.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _initializeFirebase();
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LogIn(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}

_initializeFirebase() async{
  return await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}


