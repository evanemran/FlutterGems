import 'package:flutter/material.dart';
import 'package:fluttergems/pages/home_page.dart';
import 'package:fluttergems/utils/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Gems',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: ColorManager.backgroundLight,
          secondary: ColorManager.containerLight,
          surface: ColorManager.containerLight, // For container
          tertiary: ColorManager.black,
          background: ColorManager.backgroundLight,
        ),
        scaffoldBackgroundColor: ColorManager.backgroundLight,
        cardColor: ColorManager.containerLight,
        textTheme: TextTheme(
          displayLarge: TextStyle(color: ColorManager.black, fontSize: 16),
          titleMedium: TextStyle(color: ColorManager.black, fontSize: 14),
          bodySmall: TextStyle(color: ColorManager.black),
          bodyLarge: TextStyle(color: ColorManager.black),
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: ColorManager.backgroundDark,
        cardColor: ColorManager.containerDark,
        canvasColor: ColorManager.backgroundDark,
        brightness: Brightness.dark, // Dark mode settings
        // Optionally customize dark mode further
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(color: ColorManager.white, fontSize: 16),
          titleMedium: TextStyle(color: ColorManager.white, fontSize: 14),
          bodySmall: TextStyle(color: ColorManager.white),
          bodyLarge: TextStyle(color: ColorManager.white),
        ),
        colorScheme: ColorScheme.dark(
          primary: ColorManager.black,
          secondary: ColorManager.containerDark,
          surface: ColorManager.containerDark, // For container
          tertiary: ColorManager.white,
          background: ColorManager.black,
        ),
      ),
      themeMode: _themeMode,
      home: HomePage(
        onThemeChanged: (ThemeMode value) {
          setState(() {
            _themeMode = value;
          });
        },
      ),
    );
  }
}
