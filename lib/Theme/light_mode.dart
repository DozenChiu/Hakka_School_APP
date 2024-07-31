import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  appBarTheme: const AppBarTheme(color: Colors.blue), // 設置頂部背景顏色為藍色
  colorScheme: ColorScheme.light(
    surface: Colors.white,
    primary: Colors.grey.shade700,
    inversePrimary: Colors.grey.shade900,
  ),
);