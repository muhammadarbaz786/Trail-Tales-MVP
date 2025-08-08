import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailtales/routes/app_routes.dart';
import 'package:trailtales/routes/route_generator.dart';
import 'package:trailtales/utils/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Keep this if you have async setup later

  runApp(const TrailTalesApp());
}

class TrailTalesApp extends StatefulWidget {
  const TrailTalesApp({super.key});

  @override
  State<TrailTalesApp> createState() => _TrailTalesAppState();
}

class _TrailTalesAppState extends State<TrailTalesApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode =
      _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrailTales',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
