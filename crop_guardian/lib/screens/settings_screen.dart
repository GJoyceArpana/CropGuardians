import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool _darkMode = false;
  String _currentLanguage = 'English';
  bool _notificationsEnabled = true;
  bool _cropUpdates = true;
  bool _weatherAlerts = true;
  late DocumentReference _settingsDoc;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _settingsDoc = _firestore.collection('users').doc(_auth.currentUser!.uid).collection('settings').doc('preferences');
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final snapshot = await _settingsDoc.get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
      setState(() {
        _darkMode = data['darkMode'] ?? false;
        _currentLanguage = data['language'] ?? 'English';
        _notificationsEnabled = data['notifications'] ?? true;
        _cropUpdates = data['cropUpdates'] ?? true;
        _weatherAlerts = data['weatherAlerts'] ?? true;
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  Future<void> _saveSettings() async {
    await _settingsDoc.set({
      'darkMode': _darkMode,
      'language': _currentLanguage,
      'notifications': _notificationsEnabled,
      'cropUpdates': _cropUpdates,
      'weatherAlerts': _weatherAlerts,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved successfully')),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                _LanguageOption(
                  language: 'English',
                  selected: _currentLanguage == 'English',
                  onTap: () {
                    setState(() => _currentLanguage = 'English');
                    Navigator.pop(context);
                  },
                ),
                _LanguageOption(
                  language: 'Hindi',
                  selected: _currentLanguage == 'Hindi',
                  onTap: () {
                    setState(() => _currentLanguage = 'Hindi');
                    Navigator.pop(context);
                  },
                ),
                _LanguageOption(
                  language: 'Marathi',
                  selected: _currentLanguage == 'Marathi',
                  onTap: () {
                    setState(() => _currentLanguage = 'Marathi');
                    Navigator.pop(context);
                  },
                ),
                _LanguageOption(
                  language: 'Tamil',
                  selected: _currentLanguage == 'Tamil',
                  onTap: () {
                    setState(() => _currentLanguage = 'Tamil');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color(0xFFF8F9FB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Appearance",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SwitchListTile(
                  title: const Text('Dark Mode'),
                  value: _darkMode,
                  onChanged: (value) => setState(() => _darkMode = value),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Language & Region",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.language, color: Colors.deepPurple),
                title: const Text('Language'),
                subtitle: Text(_currentLanguage),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _showLanguageDialog,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Notifications",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Enable Notifications'),
                    value: _notificationsEnabled,
                    onChanged: (value) => setState(() => _notificationsEnabled = value),
                  ),
                  Divider(height: 1, color: Colors.grey[300]),
                  SwitchListTile(
                    title: const Text('Crop Updates'),
                    value: _notificationsEnabled && _cropUpdates,
                    onChanged: _notificationsEnabled
                        ? (value) => setState(() => _cropUpdates = value)
                        : null,
                  ),
                  Divider(height: 1, color: Colors.grey[300]),
                  SwitchListTile(
                    title: const Text('Weather Alerts'),
                    value: _notificationsEnabled && _weatherAlerts,
                    onChanged: _notificationsEnabled
                        ? (value) => setState(() => _weatherAlerts = value)
                        : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Account",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.privacy_tip, color: Colors.blue),
                    title: const Text('Privacy Policy'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                  Divider(height: 1, color: Colors.grey[300]),
                  ListTile(
                    leading: const Icon(Icons.help, color: Colors.orange),
                    title: const Text('Help & Support'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                  Divider(height: 1, color: Colors.grey[300]),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Log Out'),
                    onTap: () {
                      // Add logout functionality
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveSettings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save Settings',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String language;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.language,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(language),
      trailing: selected ? const Icon(Icons.check, color: Colors.green) : null,
      onTap: onTap,
    );
  }
}