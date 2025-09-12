import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'feedback_screen.dart';

// Import the new feature screens
import 'data_driven_predictions_screen.dart';
import 'soil_field_insights_screen.dart';
import 'weather_features_screen.dart';
import 'actionable_recommendations_screen.dart';
import 'offline_features_screen.dart';
import 'alerts_notifications_screen.dart';
import 'user_accessibility_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
        title: const Row(
          children: [
            Icon(Icons.eco, color: Colors.green, size: 32),
            SizedBox(width: 10),
            Text(
              'CropGuardians',
              style: TextStyle(
                color: Color(0xFF152340),
                fontWeight: FontWeight.bold,
                fontSize: 24,
                letterSpacing: -0.5,
              ),
            ),
            Spacer(),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.grey),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 18, 0),
            child: CircleAvatar(
              backgroundColor: Colors.green.shade50,
              child: Icon(Icons.person, color: Colors.green.shade800),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF152340),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'What would you like to do today?',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.0,
                children: [
                  _HomeMenuCard(
                    icon: Icons.person,
                    label: "Profile",
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfileScreen()),
                      );
                    },
                  ),
                  _HomeMenuCard(
                    icon: Icons.assessment,
                    label: "Data Predictions",
                    color: Colors.teal,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const DataDrivenPredictionsScreen()),
                      );
                    },
                  ),
                  _HomeMenuCard(
                    icon: Icons.nature,
                    label: "Soil & Field Insights",
                    color: Colors.brown,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SoilFieldInsightsScreen()),
                      );
                    },
                  ),
                  _HomeMenuCard(
                    icon: Icons.cloud,
                    label: "Weather Features",
                    color: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const WeatherFeaturesScreen()),
                      );
                    },
                  ),
                  _HomeMenuCard(
                    icon: Icons.lightbulb,
                    label: "Recommendations",
                    color: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ActionableRecommendationsScreen()),
                      );
                    },
                  ),
                  _HomeMenuCard(
                    icon: Icons.offline_bolt,
                    label: "Offline Features",
                    color: Colors.grey,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const OfflineFeaturesScreen()),
                      );
                    },
                  ),
                  _HomeMenuCard(
                    icon: Icons.notifications,
                    label: "Alerts & Notifications",
                    color: Colors.red,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AlertsNotificationsScreen()),
                      );
                    },
                  ),
                  _HomeMenuCard(
                    icon: Icons.language,
                    label: "User Accessibility",
                    color: Colors.purple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const UserAccessibilityScreen()),
                      );
                    },
                  ),
                  _HomeMenuCard(
                    icon: Icons.settings,
                    label: "Settings",
                    color: Colors.blueAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SettingsScreen()),
                      );
                    },
                  ),
                  _HomeMenuCard(
                    icon: Icons.feedback,
                    label: "Feedback",
                    color: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FeedbackScreen()),
                      );
                    },
                  ),
                  _HomeMenuCard(
                    icon: Icons.help_outline,
                    label: "Help",
                    color: Colors.purple,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeMenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _HomeMenuCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
