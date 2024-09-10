import 'package:flutter/material.dart';
import 'package:geekhaven/Theme/theme_provider.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: GestureDetector(
        onTap: (){
          Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
        },
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(15)),
            child: Text("mode change button"),
          ),
        ),
      ),
    );
  }
}
