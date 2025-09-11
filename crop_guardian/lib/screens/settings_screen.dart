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
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  Future<void> _saveSettings() async {
    await _settingsDoc.set({'darkMode': _darkMode, 'language': _currentLanguage});
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings saved')));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Settings", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Dark Mode'),
                value: _darkMode,
                onChanged: (value) {
                  setState(() {
                    _darkMode = value;
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.language, color: Colors.deepPurple),
                title: const Text('Language'),
                subtitle: Text(_currentLanguage),
                onTap: () async {
                  // For demo: toggle between English and Spanish
                  setState(() {
                    _currentLanguage = _currentLanguage == 'English' ? 'Spanish' : 'English';
                  });
                },
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _saveSettings,
                  child: const Text('Save Settings'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
