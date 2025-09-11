import 'package:flutter/material.dart';
import 'profile_screen.dart';   // Import ProfileScreen
import 'settings_screen.dart';  // Import SettingsScreen
import 'feedback_screen.dart';  // Import FeedbackScreen

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
          children: [
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _HomeIconButton(
                  icon: Icons.person,
                  label: "Profile",
                  color: Colors.green,
                  onTap: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()));
                  },
                ),
                const SizedBox(width: 32),
                _HomeIconButton(
                  icon: Icons.settings,
                  label: "Settings",
                  color: Colors.blue,
                  onTap: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SettingsScreen()));
                  },
                ),
                const SizedBox(width: 32),
                _HomeIconButton(
                  icon: Icons.feedback,
                  label: "Feedback",
                  color: Colors.orange,
                  onTap: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const FeedbackScreen()));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _HomeIconButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Ink(
          decoration: ShapeDecoration(
            color: color.withOpacity(0.15),
            shape: const CircleBorder(),
          ),
          child: IconButton(
            icon: Icon(icon),
            iconSize: 40,
            color: color,
            onPressed: onTap,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
