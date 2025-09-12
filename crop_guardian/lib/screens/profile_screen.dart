import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
 
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late DocumentReference _userDocRef;
 
  // Profile fields
  String firstName = '';
  String lastName = '';
  String phoneNumber = '';
  String state = '';
  String city = '';
  String region = '';
 
  bool _loading = true;
  bool _editing = false;
  final _formKey = GlobalKey<FormState>();
 
  // Fixed state-city mapping with unique values
  final Map<String, List<String>> _stateCityMap = {
    'Maharashtra': ['Mumbai', 'Pune', 'Nagpur', 'Nashik'],
    'Karnataka': ['Bangalore', 'Mysore', 'Hubli', 'Mangalore'],
    'Tamil Nadu': ['Chennai', 'Coimbatore', 'Madurai', 'Salem'],
    'Punjab': ['Chandigarh', 'Ludhiana', 'Amritsar', 'Jalandhar'],
  };

  // Get unique list of states
  List<String> get states => _stateCityMap.keys.toList();
 
  // Get cities for selected state (with null safety)
  List<String> get cities {
    if (state.isEmpty || !_stateCityMap.containsKey(state)) {
      return [];
    }
    return _stateCityMap[state]!;
  }
 
  @override
  void initState() {
    super.initState();
    String uid = _auth.currentUser!.uid;
    _userDocRef = _firestore.collection('users').doc(uid);
    _loadProfile();
  }
 
  Future<void> _loadProfile() async {
    DocumentSnapshot doc = await _userDocRef.get();
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String loadedState = (data['state'] ?? '').toString().trim();
      String loadedCity = (data['city'] ?? '').toString().trim();

      // Normalize state to match dropdown keys exactly (case-sensitive)
      if (!_stateCityMap.containsKey(loadedState)) {
        loadedState = '';
        loadedCity = '';
      } else {
        // Check if city belongs to loadedState, else reset city
        if (!_stateCityMap[loadedState]!.contains(loadedCity)) {
          loadedCity = '';
        }
      }

      setState(() {
        firstName = data['firstName'] ?? '';
        lastName = data['lastName'] ?? '';
        phoneNumber = data['phoneNumber'] ?? _auth.currentUser!.phoneNumber ?? '';
        state = loadedState;
        city = loadedCity;
        region = data['region'] ?? '';
        _loading = false;
      });
    } else {
      setState(() {
        phoneNumber = _auth.currentUser!.phoneNumber ?? '';
        _loading = false;
        _editing = true; // Automatically enable editing for new users
      });
    }
  }
 
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
 
    await _userDocRef.set({
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'state': state,
      'city': city,
      'region': region,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
 
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
 
    setState(() => _editing = false);
  }
 
  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
 
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        actions: [
          if (!_editing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _editing = true),
            )
          else
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() => _editing = false);
                _loadProfile(); // Reload original data
              },
            ),
        ],
      ),
      backgroundColor: const Color(0xFFF8F9FB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Picture
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 56,
                      backgroundColor: Colors.green.shade100,
                      child: Text(
                        firstName.isNotEmpty ? firstName[0].toUpperCase() : '?',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                    ),
                    if (_editing)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildEditableField(
                label: 'First Name',
                value: firstName,
                onChanged: (val) => firstName = val,
                enabled: _editing,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildEditableField(
                label: 'Last Name',
                value: lastName,
                onChanged: (val) => lastName = val,
                enabled: _editing,
              ),
              const SizedBox(height: 16),
              _buildEditableField(
                label: 'Phone Number',
                value: phoneNumber,
                onChanged: (val) => phoneNumber = val,
                enabled: false, // Phone number shouldn't be editable
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              // State dropdown
              DropdownButtonFormField<String>(
                value: state.isNotEmpty ? state : null,
                decoration: InputDecoration(
                  labelText: 'State',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: !_editing,
                  fillColor: !_editing ? Colors.grey[100] : null,
                ),
                items: states.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: _editing
                    ? (String? newValue) {
                        setState(() {
                          state = newValue ?? '';
                          city = ''; // Reset city when state changes
                        });
                      }
                    : null,
                validator: (value) {
                  if (_editing && (value == null || value.isEmpty)) {
                    return 'Please select your state';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // City dropdown
              DropdownButtonFormField<String>(
                value: city.isNotEmpty ? city : null,
                decoration: InputDecoration(
                  labelText: 'City/District',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: !_editing,
                  fillColor: !_editing ? Colors.grey[100] : null,
                ),
                items: cities.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: _editing && state.isNotEmpty
                    ? (String? newValue) {
                        setState(() => city = newValue ?? '');
                      }
                    : null,
                validator: (value) {
                  if (_editing && state.isNotEmpty && (value == null || value.isEmpty)) {
                    return 'Please select your city';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildEditableField(
                label: 'Region/Village',
                value: region,
                onChanged: (val) => region = val,
                enabled: _editing,
              ),
              const SizedBox(height: 30),
              if (_editing)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Save Profile',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required String label,
    required String value,
    required Function(String) onChanged,
    required bool enabled,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: !enabled,
        fillColor: !enabled ? Colors.grey[100] : null,
      ),
      onChanged: onChanged,
      enabled: enabled,
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
