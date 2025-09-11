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
      setState(() {
        firstName = data['firstName'] ?? '';
        lastName = data['lastName'] ?? '';
        phoneNumber = data['phoneNumber'] ?? _auth.currentUser!.phoneNumber ?? '';
        state = data['state'] ?? '';
        city = data['city'] ?? '';
        region = data['region'] ?? '';
        _loading = false;
      });
    } else {
      setState(() {
        phoneNumber = _auth.currentUser!.phoneNumber ?? '';
        _loading = false;
      });
    }
  }
  
  Future<void> _saveProfile() async {
    await _userDocRef.set({
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'state': state,
      'city': city,
      'region': region,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated')));
  }
  
  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20),
      ),
      backgroundColor: const Color(0xFFF8F9FB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            // Profile Picture
            Center(
              child: CircleAvatar(
                radius: 56,
                backgroundColor: Colors.green.shade100,
                child: Text(
                  firstName.isNotEmpty ? firstName[0].toUpperCase() : '?',
                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 32),
                ),
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              decoration: const InputDecoration(labelText: 'First Name'),
              controller: TextEditingController(text: firstName),
              onChanged: (val) => firstName = val,
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(labelText: 'Last Name'),
              controller: TextEditingController(text: lastName),
              onChanged: (val) => lastName = val,
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(labelText: 'Phone Number'),
              controller: TextEditingController(text: phoneNumber),
              onChanged: (val) => phoneNumber = val,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(labelText: 'State'),
              controller: TextEditingController(text: state),
              onChanged: (val) => state = val,
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(labelText: 'City/District'),
              controller: TextEditingController(text: city),
              onChanged: (val) => city = val,
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(labelText: 'Region'),
              controller: TextEditingController(text: region),
              onChanged: (val) => region = val,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
