import 'package:flutter/material.dart';
import 'package:geekhaven/Navbar/BottomNav.dart';
import 'package:geekhaven/Pages/suggestion_page.dart';
import 'package:geekhaven/Theme/theme_provider.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

void main() {
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
      home: BottomNav(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}


