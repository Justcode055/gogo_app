import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/app_constants.dart';
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
  ThemeData _buildLightTheme() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppConstants.brandPrimary,
      brightness: Brightness.light,
    );
    final base = ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: AppConstants.brandSurface,
      useMaterial3: true,
    );
    final textTheme = Typography.material2021()
        .black
        .apply(
          fontFamily: 'serif',
          bodyColor: AppConstants.brandTextPrimary,
          displayColor: AppConstants.brandTextPrimary,
        )
        .copyWith(
          titleLarge: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
          bodyMedium: const TextStyle(
            fontSize: 15,
            height: 1.35,
          ),
        );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppConstants.brandSurfaceAlt),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppConstants.brandSurfaceAlt),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppConstants.brandSurfaceAlt),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppConstants.brandPrimary, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppConstants.brandPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.brandPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppConstants.brandPrimaryDark,
        contentTextStyle: TextStyle(color: Colors.white),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppConstants.brandPrimary,
      brightness: Brightness.dark,
    );
    final base = ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
    );
    final textTheme = Typography.material2021()
        .white
        .apply(fontFamily: 'serif');

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

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
          theme: _buildLightTheme(),
          darkTheme: _buildDarkTheme(),
          themeMode: AppState.instance.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,
        );
      },
    );
  }
}