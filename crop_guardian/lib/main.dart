import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';  // Add this when your settings screen exists
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CropGuardiansApp());
}

class CropGuardiansApp extends StatelessWidget {
  const CropGuardiansApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return MaterialApp(
      title: 'CropGuardians',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),  // Splash screen is app entry
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/features': (context) => const FeaturesOverviewScreen(),
        // Add more routes here as you add new screens
      },
    );
  }
}

// New FeaturesOverviewScreen to list crop guardians features

class FeaturesOverviewScreen extends StatelessWidget {
  const FeaturesOverviewScreen({super.key});

  final Map<String, List<String>> featureSections = const {
    'Data-Driven Predictions': [
      'Crop yield forecasting based on historical yields, rainfall, temperature, and soil data',
      'Irrigation recommendations using soil moisture levels and past rainfall patterns',
      'Fertilization advice based on soil nutrients, crop type, and growth stages',
      'Pest and disease risk alerts derived from regional patterns, weather, and crop type',
    ],
    'Soil & Field Insights': [
      'Soil health analysis with pH level, nitrogen, phosphorus, potassium metrics',
      'Field condition tracking with historical trends stored locally',
    ],
    'Weather-Based Features': [
      'Rainfall pattern analysis for precipitation and irrigation needs',
      'Temperature forecasts for yield predictions and stress management',
    ],
    'Actionable Recommendations': [
      'Crop-specific advisory for different growth stages',
      'Regional adaptation of recommendations tailored to local climate and soil',
    ],
    'Offline-First Features': [
      'Offline local data storage for historical crop yield, soil metrics, and user preferences',
      'Cached weather forecasts available offline',
      'On-device model-based inference for predictions',
    ],
    'Alerts & Notifications': [
      'Pest alerts updated online and accessible offline',
      'Scheduled fertilization and irrigation alerts',
    ],
    'User Accessibility': [
      'Regional language interface with translations stored locally',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CropGuardians Features'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: featureSections.length,
        itemBuilder: (context, index) {
          String sectionTitle = featureSections.keys.elementAt(index);
          List<String> features = featureSections[sectionTitle]!;
          return ExpansionTile(
            title: Text(
              sectionTitle,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            children: features
                .map(
                  (feature) => ListTile(
                    title: Text(feature),
                    leading: const Icon(Icons.check_circle_outline, color: Colors.green),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
