import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _verificationId;

  // Start phone authentication (send OTP)
  Future<void> verifyPhone(
    String phoneNumber,
    Function(String, int?) codeSentCallback,
    Function(FirebaseAuthException) failedCallback,
  ) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Automatic sign-in (Android only)
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: failedCallback,
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId; // Store verificationId for OTP verification
        codeSentCallback(verificationId, resendToken);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  // Sign in with OTP (sms code)
  Future<User?> signInWithOtp(String smsCode) async {
    if (_verificationId == null) return null;

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: smsCode,
    );

    try {
      UserCredential result = await _auth.signInWithCredential(credential);
      return result.user;
    } catch (e) {
      print('OTP Sign-in error: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Stream for auth state changes (e.g. user logged in/out)
  Stream<User?> get userChanges => _auth.authStateChanges();
}
