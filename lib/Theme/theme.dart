import 'package:flutter/material.dart';

ThemeData lightmode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.white,
    primary: Colors.lightBlueAccent,
    secondary: Colors.greenAccent,
  )
);

ThemeData darkmode = ThemeData(
  brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      background: Colors.black45,
      primary: Colors.lightBlueAccent,
      secondary: Colors.greenAccent,
    )
);