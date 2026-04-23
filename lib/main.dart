import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
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
  TextTheme _buildPremiumTextTheme({
    required Brightness brightness,
    required Color textColor,
  }) {
    final baseTypography = brightness == Brightness.dark
        ? Typography.material2021().white
        : Typography.material2021().black;

    final bodyTheme = GoogleFonts.manropeTextTheme(baseTypography).apply(
      bodyColor: textColor,
      displayColor: textColor,
    );

    return bodyTheme.copyWith(
      displayLarge: GoogleFonts.cormorantGaramond(
        textStyle: bodyTheme.displayLarge,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        color: textColor,
      ),
      displayMedium: GoogleFonts.cormorantGaramond(
        textStyle: bodyTheme.displayMedium,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        color: textColor,
      ),
      displaySmall: GoogleFonts.cormorantGaramond(
        textStyle: bodyTheme.displaySmall,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        color: textColor,
      ),
      headlineLarge: GoogleFonts.cormorantGaramond(
        textStyle: bodyTheme.headlineLarge,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        color: textColor,
      ),
      headlineMedium: GoogleFonts.cormorantGaramond(
        textStyle: bodyTheme.headlineMedium,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        color: textColor,
      ),
      headlineSmall: GoogleFonts.cormorantGaramond(
        textStyle: bodyTheme.headlineSmall,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        color: textColor,
      ),
      titleLarge: GoogleFonts.cormorantGaramond(
        textStyle: bodyTheme.titleLarge,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        color: textColor,
      ),
      titleMedium: GoogleFonts.manrope(
        textStyle: bodyTheme.titleMedium,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleSmall: GoogleFonts.manrope(
        textStyle: bodyTheme.titleSmall,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      bodyLarge: GoogleFonts.manrope(
        textStyle: bodyTheme.bodyLarge,
        fontSize: 16,
        height: 1.35,
        color: textColor,
      ),
      bodyMedium: GoogleFonts.manrope(
        textStyle: bodyTheme.bodyMedium,
        fontSize: 15,
        height: 1.35,
        color: textColor,
      ),
      bodySmall: GoogleFonts.manrope(
        textStyle: bodyTheme.bodySmall,
        height: 1.35,
        color: textColor,
      ),
      labelLarge: GoogleFonts.manrope(
        textStyle: bodyTheme.labelLarge,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      labelMedium: GoogleFonts.manrope(
        textStyle: bodyTheme.labelMedium,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      labelSmall: GoogleFonts.manrope(
        textStyle: bodyTheme.labelSmall,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
    );
  }

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
    final textTheme = _buildPremiumTextTheme(
      brightness: Brightness.light,
      textColor: AppConstants.brandTextPrimary,
    );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppConstants.brandTextPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppConstants.brandTextPrimary),
        actionsIconTheme: const IconThemeData(color: AppConstants.brandTextPrimary),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: AppConstants.brandTextPrimary,
        ),
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
    final textTheme = _buildPremiumTextTheme(
      brightness: Brightness.dark,
      textColor: AppConstants.onboardingTextPrimary,
    );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppConstants.onboardingTextPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppConstants.onboardingTextPrimary),
        actionsIconTheme: const IconThemeData(color: AppConstants.onboardingTextPrimary),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppConstants.onboardingTextPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF2D3E35)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1A2620),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2D3E35)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2D3E35)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppConstants.brandPrimary, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppConstants.brandPrimaryDark,
        contentTextStyle: TextStyle(color: AppConstants.onboardingTextPrimary),
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