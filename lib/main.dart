import 'package:fam_assignment_work/provider/cards_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CardsProvider(),
      child: MaterialApp(
        title: 'Fam',
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
