import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/app_state.dart';
import 'core/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GoGoApp());
  unawaited(_bootstrapApp());
}

Future<void> _bootstrapApp() async {
  final firebaseReady = await _initFirebase();
  try {
    await AppState.instance.init(cloudEnabled: firebaseReady);
  } catch (err, stack) {
    debugPrint('App init failed: $err');
    debugPrintStack(stackTrace: stack);
  }
}

Future<bool> _initFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return true;
  } catch (err, stack) {
    debugPrint('Firebase init failed: $err');
    debugPrintStack(stackTrace: stack);
    return false;
  }
}

class GoGoApp extends StatefulWidget {
  const GoGoApp({super.key});

  @override
  State<GoGoApp> createState() => _GoGoAppState();
}

class _GoGoAppState extends State<GoGoApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      AppState.instance.saveSession();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        return MaterialApp.router(
          title: 'GoGo',
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          themeMode: AppState.instance.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,
        );
      },
    );
  }
}