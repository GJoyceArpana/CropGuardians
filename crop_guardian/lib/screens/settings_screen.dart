import 'package:flutter/material.dart';
import 'profile_screen.dart'; // For edit profile navigation

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    String currentLanguage = "English"; // You can use state or provider for real app

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color(0xFFF8F9FB),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Settings",
                style: TextStyle(
                  fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black87
                ),
              ),
              const SizedBox(height: 16),
              // Edit Profile
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blueGrey),
                title: const Text(
                  "Edit Profile",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black45),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  );
                },
              ),
              // Change Language Preference
              ListTile(
                leading: const Icon(Icons.language, color: Colors.deepPurple),
                title: const Text(
                  "Change Language",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(currentLanguage),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black45),
                onTap: () {
                  // Show language picker, dialog, or navigate to language screen
                  // For now, just display a snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Show language picker here")),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
