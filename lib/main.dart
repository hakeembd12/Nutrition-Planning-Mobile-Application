import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/meal_plans/providers/meal_plan_provider.dart';
import 'core/providers/locale_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/splash/splash_screen.dart';
import 'features/navigation/main_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MealPlanProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: const NutritionPlannerApp(),
    ),
  );
}

class NutritionPlannerApp extends StatelessWidget {
  const NutritionPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return MaterialApp(
          title: 'Nutrition',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF4CAF50),
            ),
            useMaterial3: true,
          ),
          locale: localeProvider.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const AuthWrapper(),
        );
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _getScreen(authProvider),
        );
      },
    );
  }

  Widget _getScreen(AuthProvider authProvider) {
    // 1. If currently doing initial auth check, show splash
    if (authProvider.isInitialLoading) {
      return const SplashScreen(key: ValueKey('splash'));
    }

    // 2. If authenticated, show home
    if (authProvider.user != null) {
      return const MainNavigationScreen(key: ValueKey('home'));
    }

    // 3. Otherwise, show login
    return const LoginScreen(key: ValueKey('login'));
  }
}
