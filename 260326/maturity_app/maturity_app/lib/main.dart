// main.dart
// Az alkalmazás belépési pontja

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/student_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // StudentProvider az egész app számára elérhető lesz
      create: (_) => StudentProvider(),
      child: MaterialApp(
        title: 'Érettségi Törzslapok',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
        ],
        // Material 3 téma kék/indigo pallettával
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1A237E), // indigo sötétkék
            brightness: Brightness.light,
          ),
          // AppBar téma
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1A237E),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          // Kártya téma
          cardTheme: CardThemeData  (
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          // Input mezők
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF1A237E),
                width: 2,
              ),
            ),
          ),
          // ElevatedButton alapértelmezés
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A237E),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
