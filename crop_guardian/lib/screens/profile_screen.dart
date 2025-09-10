import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color(0xFFF8F9FB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            // Profile Picture circle (added)
            Center(
              child: CircleAvatar(
                radius: 56,
                backgroundColor: Colors.green.shade100,
                backgroundImage:
                    const AssetImage('images/profile_pic.png'), // Replace with your profile image
                child: const Text(
                  'JF',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ), // fallback initials if image not loaded
              ),
            ),
            const SizedBox(height: 18),
            // Profile Header Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  // Profile "pic" circle removed here because added above
                  const SizedBox(width: 18),
                  // Name and details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "John Farmer",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "+1 (555) 123-4567",
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Member since March 2024",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            // Personal Info Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Personal Information",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  SizedBox(height: 18),
                  InfoRow(icon: Icons.person, label: "First Name", value: "John"),
                  InfoRow(icon: Icons.person, label: "Last Name", value: "Farmer"),
                  InfoRow(icon: Icons.tablet_android, label: "Phone Number", value: "+1 (555) 123-4567"),
                  InfoRow(icon: Icons.location_on, label: "State", value: "California"),
                  InfoRow(icon: Icons.place, label: "City/District", value: "Fresno"),
                  InfoRow(icon: Icons.place_outlined, label: "Region", value: "Central Valley"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoRow({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 22),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500))),
          Text(value, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }
}
