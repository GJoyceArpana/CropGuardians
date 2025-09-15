import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'profile_screen.dart';
import 'feedback_screen.dart';
import 'data_driven_predictions_screen.dart';
import 'soil_field_insights_screen.dart';

// Theme Provider
class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

// Language Provider
class LanguageProvider with ChangeNotifier {
  String _currentLanguage = 'English';
  String _currentLanguageCode = 'en';
  Map<String, String> _translations = {};

  String get currentLanguage => _currentLanguage;
  String get currentLanguageCode => _currentLanguageCode;
  Map<String, String> get translations => _translations;

  final List<Map<String, String>> languages = [
    {'name': 'English', 'code': 'en'},
    {'name': 'Hindi', 'code': 'hi'},
    {'name': 'Marathi', 'code': 'mr'},
    {'name': 'Tamil', 'code': 'ta'},
    {'name': 'Kannada', 'code': 'kn'},
  ];

  Future<void> changeLanguage(String languageName) async {
    final language = languages.firstWhere((lang) => lang['name'] == languageName);
    _currentLanguage = languageName;
    _currentLanguageCode = language['code']!;
    
    await _loadTranslations();
    notifyListeners();
  }

  Future<void> _loadTranslations() async {
    try {
      _translations = {
        'welcome': await _translateText('Welcome!', _currentLanguageCode),
        'what_would_you_like': await _translateText('What would you like to do today?', _currentLanguageCode),
        'profile': await _translateText('Profile', _currentLanguageCode),
        'data_predictions': await _translateText('Data Predictions', _currentLanguageCode),
        'soil_field_insights': await _translateText('Soil & Field Insights', _currentLanguageCode),
        'feedback': await _translateText('Feedback', _currentLanguageCode),
        'help': await _translateText('Help', _currentLanguageCode),
        'my_profile': await _translateText('My Profile', _currentLanguageCode),
        'sign_out': await _translateText('Sign Out', _currentLanguageCode),
        'crop_guardians': await _translateText('CropGuardians', _currentLanguageCode),
        'scan_plant': await _translateText('Scan Plant / Take Picture', _currentLanguageCode),
      };
    } catch (e) {
      print('Error loading translations: $e');
    }
  }

  Future<String> _translateText(String text, String targetLang) async {
    if (targetLang == 'en') return text;
    
    try {
      Map<String, Map<String, String>> demoTranslations = {
        'hi': {
          'Welcome!': 'स्वागत हे!',
          'What would you like to do today?': 'आज आप क्या करना चाहेंगे?',
          'Profile': 'प्रोफाइल',
          'Data Predictions': 'डेटा भविष्यवाणियाँ',
          'Soil & Field Insights': 'मृदा और क्षेत्र अंतर्दृष्टि',
          'Feedback': 'प्रतिक्रिया',
          'Help': 'मदद',
          'My Profile': 'मेरी प्रोफाइल',
          'Sign Out': 'साइन आउट',
          'CropGuardians': 'फसल संरक्षक',
          'Scan Plant / Take Picture': 'पौधे को स्कैन करें / तस्वीर लें',
        },
        'mr': {
          'Welcome!': 'स्वागत आहे!',
          'What would you like to do today?': 'तुम्हाला आज काय करायचे आहे?',
          'Profile': 'प्रोफाइल',
          'Data Predictions': 'डेटा भाकीत',
          'Soil & Field Insights': 'मृदा आणि फील्ड इनसाइट्स',
          'Feedback': 'अभिप्राय',
          'Help': 'मदत',
          'My Profile': 'माझे प्रोफाइल',
          'Sign Out': 'साइन आउट',
          'CropGuardians': 'क्रॉपगार्डियन्स',
          'Scan Plant / Take Picture': 'वनस्पती स्कॅन करा / चित्र घ्या',
        },
        'ta': {
          'Welcome!': 'வரவேற்கிறோம்!',
          'What would you like to do today?': 'இன்று நீங்கள் என்ன செய்ய விரும்புகிறீர்கள்?',
          'Profile': 'சுயவிவரம்',
          'Data Predictions': 'தரவு கணிப்புகள்',
          'Soil & Field Insights': 'மண் மற்றும் கள நுண்ணறிவு',
          'Feedback': 'கருத்து',
          'Help': 'உதவி',
          'My Profile': 'எனது சுயவிவரம்',
          'Sign Out': 'வெளியேறு',
          'CropGuardians': 'கிராப் கார்டியன்ஸ்',
          'Scan Plant / Take Picture': 'தாவரத்தை ஸ்கேன் செய்யுங்கள் / படம் எடுக்கவும்',
        },
        'kn': {
          'Welcome!': 'ಸ್ವಾಗತ!',
          'What would you like to do today?': 'ನೀವು ಇಂದು ಏನು ಮಾಡಲು ಬಯಸುತ್ತೀರಿ?',
          'Profile': 'ಪ್ರೊಫೈಲ್',
          'Data Predictions': 'ಡೇಟಾ ಭವಿಷ್ಯಸೂಚನೆಗಳು',
          'Soil & Field Insights': 'ಮಣ್ಣು ಮತ್ತು ಕ್ಷೇತ್ರ ಒಳನೋಟಗಳು',
          'Feedback': 'ಪ್ರತಿಕ್ರಿಯೆ',
          'Help': 'ಸಹಾಯ',
          'My Profile': 'ನನ್ನ ಪ್ರೊಫೈಲ್',
          'Sign Out': 'ಸೈನ್ ಔಟ್',
          'CropGuardians': 'ಕ್ರಾಪ್ ಗಾರ್ಡಿಯನ್ಸ್',
          'Scan Plant / Take Picture': 'ಸಸ್ಯವನ್ನು ಸ್ಕ್ಯಾನ್ ಮಾಡಿ / ಚಿತ್ರ ತೆಗೆಯಿರಿ',
        },
      };
      
      return demoTranslations[targetLang]?[text] ?? "[$targetLang] $text";
    } catch (e) {
      print('Translation error: $e');
      return text;
    }
  }

  String getText(String key) {
    return _translations[key] ?? key;
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    // Load initial translations
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LanguageProvider>(context, listen: false)._loadTranslations();
    });
  }

  void _signOut() async {
    try {
      await _auth.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-out failed: $e')),
      );
    }
  }

  void _showProfileMenu() {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(languageProvider.getText('my_profile')),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text(languageProvider.getText('sign_out'), style: const TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(ctx);
                _signOut();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final pickedImage = await _picker.pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        setState(() {
          _imageFile = File(pickedImage.path);
        });
        // TODO: Proceed with image processing or ML inference here
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Image captured'),
            content: Image.file(_imageFile!),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: themeProvider.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Icon(Icons.eco, color: Colors.green, size: 32),
            const SizedBox(width: 10),
            Text(
              languageProvider.getText('crop_guardians'),
              style: TextStyle(
                color: themeProvider.isDarkMode ? Colors.white : const Color(0xFF152340),
                fontWeight: FontWeight.bold,
                fontSize: 24,
                letterSpacing: -0.5,
              ),
            ),
            const Spacer(),
          ],
        ),
        actions: [
          // Language dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              value: languageProvider.currentLanguage,
              items: languageProvider.languages
                  .map((lang) => DropdownMenuItem(
                        value: lang['name'],
                        child: Text(lang['name']!),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  languageProvider.changeLanguage(value);
                }
              },
              underline: const SizedBox(),
              style: TextStyle(
                color: themeProvider.isDarkMode ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              dropdownColor: themeProvider.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            ),
          ),
          // Dark/Bright theme toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode, 
                      color: Colors.green),
          ),
          Switch(
            value: themeProvider.isDarkMode,
            onChanged: (val) => themeProvider.toggleTheme(),
            activeColor: Colors.green,
          ),
          // Profile avatar
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 18, 0),
            child: GestureDetector(
              onTap: _showProfileMenu,
              child: CircleAvatar(
                backgroundColor: Colors.green.shade50,
                child: Icon(Icons.person, color: Colors.green.shade800),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              languageProvider.getText('welcome'),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: themeProvider.isDarkMode ? Colors.white : const Color(0xFF152340),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              languageProvider.getText('what_would_you_like'),
              style: TextStyle(
                fontSize: 16,
                color: themeProvider.isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: Text(languageProvider.getText('scan_plant')),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: Colors.green[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _pickImageFromCamera,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.0,
                children: [
                  _HomeMenuCard(
                    icon: Icons.person,
                    label: languageProvider.getText('profile'),
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
                    label: languageProvider.getText('data_predictions'),
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
                    label: languageProvider.getText('soil_field_insights'),
                    color: Colors.brown,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SoilFieldInsightsScreen()),
                      );
                    },
                  ),
                  _HomeMenuCard(
                    icon: Icons.feedback,
                    label: languageProvider.getText('feedback'),
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
                    label: languageProvider.getText('help'),
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: themeProvider.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
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
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: themeProvider.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}