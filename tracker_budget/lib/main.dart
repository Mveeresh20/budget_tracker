import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Ensure this path is correct
import 'auth/auth_gate.dart';
import 'utils/theme.dart';
import 'utils/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    print("Initializing Firebase...");
    await Firebase.initializeApp(
      name: "my-first-project-9dd0e",
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized.");
  } else {
    print("Firebase already initialized.");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode themeMode, __) {
        return MaterialApp(
          title: 'Budget Tracker',
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: themeMode,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en', ''),
            Locale('es', ''),
          ],
          home: AuthGate(),
          localeResolutionCallback: (locale, supportedLocales) {
            loadLocalizedJson(locale!); // Call this when locale changes
            return locale;
          },
        );
      },
    );
  }
}

Future<void> loadLocalizedJson(Locale locale) async {
  String fileName =
      locale.languageCode == 'es' ? 'assets/es.json' : 'assets/en.json';
  try {
    String jsonString = await rootBundle.loadString(fileName);
    var jsonData = json.decode(jsonString);
    print(
        'Loaded JSON data for ${locale.languageCode}: $jsonData'); // Replace with how you need to use the data
  } catch (e) {
    print('Error loading JSON file: $e');
  }
}
