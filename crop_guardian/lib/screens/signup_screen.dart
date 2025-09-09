import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    // Implement your login logic here (API/network call)
    // Validate phone and password, then authenticate user
    // Example: Navigator.pushNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: const Text('Login'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text('Phone Number', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: InputDecoration(
                prefixText: '+91 ',
                hintText: 'Enter 10-digit mobile number',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                counterText: "",
                fillColor: Colors.grey[100],
                filled: true,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 4, left: 4),
              child: Text(
                "We'll use this number for verification",
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
            const SizedBox(height: 18),
            const Text('Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter your password',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                fillColor: Colors.grey[100],
                filled: true,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 4, left: 4),
              child: Text(
                "Minimum 6 characters required",
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: StadiumBorder(),
                ),
                child: const Text('Login', style: TextStyle(fontSize: 18)),
                onPressed: _login,
              ),
            ),
            const SizedBox(height: 18),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  // Implement forgot password logic
                  // Example: Navigator.pushNamed(context, '/forgot-password');
                },
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
