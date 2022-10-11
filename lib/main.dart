import 'package:flutter/material.dart';
import 'package:pokemon_vba/ui/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 68, 62, 62),
        colorScheme: ColorScheme.dark(
          primary: Colors.grey,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
        ),
      ),
      home: MainScreen(),
    );
  }
}
