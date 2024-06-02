import 'package:flutter/material.dart';
import 'package:shipping_app/screens/app.dart';
import 'package:shipping_app/screens/auth/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 119, 0),
          primary: const Color.fromARGB(255, 255, 146, 51),
          secondary: const Color.fromARGB(255, 255, 173, 102),
          surface: const Color.fromARGB(255, 238, 238, 238),
          error: const Color.fromARGB(255, 255, 0, 0),
          background: const Color.fromARGB(255, 225, 225, 225),
          onBackground: const Color.fromARGB(255, 0, 0, 0),
        ),
        navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.resolveWith(
            (states) {
              if (states.contains(MaterialState.selected)) {
                return const TextStyle(
                  color: Color.fromARGB(255, 255, 127, 0),
                );
              }
              return const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
              );
            },
          ),
        ),
      ),
      home: const AppScreen(
        currentIndex: 0,
      ),
    );
  }
}
