import 'package:flutter/material.dart';
import 'core/app_router.dart';

void main() {
  runApp(const GoGoApp());
}

class GoGoApp extends StatelessWidget {
  const GoGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GoGo App',
      theme: ThemeData(
        // The global green theme you wanted for the app
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}