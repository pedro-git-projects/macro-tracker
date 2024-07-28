import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:macro_tracker/providers/macro_provider.dart';
import 'package:macro_tracker/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MacroProvider(),
      child: MaterialApp(
        title: 'Macro Tracker',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
