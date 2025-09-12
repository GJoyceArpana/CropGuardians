import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _verificationId;

  Future<void> verifyPhone(
    String phoneNumber,
    Function(String, int?) codeSentCallback,
    Function(FirebaseAuthException) failedCallback,
  ) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: failedCallback,
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        codeSentCallback(verificationId, resendToken);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
      timeout: const Duration(seconds: 60),
    );
  }

  Future<void> createOrUpdateUserProfile(User user, {String? password}) async {
    final userDoc = _firestore.collection('users').doc(user.uid);
    final doc = await userDoc.get();

    if (!doc.exists) {
      await userDoc.set({
        'uid': user.uid,
        'phoneNumber': user.phoneNumber ?? '',
        'email': user.email ?? '${user.phoneNumber}@cropguardians.com',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'firstName': '',
        'lastName': '',
        'state': '',
        'city': '',
        'region': '',
        'hasPassword': password != null,
      });
    } else {
      await userDoc.update({
        'phoneNumber': user.phoneNumber ?? '',
        'updatedAt': FieldValue.serverTimestamp(),
        'hasPassword': password != null,
      });
    }
  }

  // Verify OTP and link with email/password
  Future<User?> verifyAndLinkAccount(String smsCode, String password) async {
    if (_verificationId == null) {
      print("Error: _verificationId is null - OTP not verified or expired");
      return null;
    }

    try {
      // Create phone credential
      PhoneAuthCredential phoneCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      // Sign in with phone credential
      UserCredential phoneUserCredential = await _auth.signInWithCredential(phoneCredential);
      User? phoneUser = phoneUserCredential.user;
      
      if (phoneUser == null) {
        print("Phone user is null after signInWithCredential");
        return null;
      }

      // Create email credential and link to phone account
      final email = "${phoneUser.phoneNumber}@cropguardians.com";
      AuthCredential emailCredential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      // Link the email/password credential to the phone account
      UserCredential linkedUserCredential = await phoneUser.linkWithCredential(emailCredential);
      User? linkedUser = linkedUserCredential.user;

      if (linkedUser != null) {
        print("Account linked successfully. Creating user profile...");
        await createOrUpdateUserProfile(linkedUser, password: password);
        return linkedUser;
      } else {
        print("Account linking failed");
        return null;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'provider-already-linked') {
        print("Provider already linked - signing in normally");
        // If already linked, try normal sign in
        final phoneNumber = _auth.currentUser?.phoneNumber;
        if (phoneNumber != null) {
          return signInWithPhoneAndPassword(phoneNumber, password);
        }
      }
      print('Firebase Auth Exception: ${e.code} - ${e.message}');
      return null;
    } catch (e, stack) {
      print('Exception during verifyAndLinkAccount: $e');
      print(stack);
      return null;
    }
  }

  // Sign up with phone and password
  Future<User?> signUpWithPhoneAndPassword(String phoneNumber, String smsCode, String password) async {
    try {
      // First verify OTP and get phone authentication
      if (_verificationId == null) {
        // If verification ID is not set, we need to verify phone first
        // This is a simplified approach - in real app, you'd handle this differently
        print("Verification ID not found, cannot complete signup");
        return null;
      }

      // Verify OTP and link account
      return await verifyAndLinkAccount(smsCode, password);
    } catch (e) {
      print('Signup error: $e');
      return null;
    }
  }

  // Sign in with phone and password
  Future<User?> signInWithPhoneAndPassword(String phoneNumber, String password) async {
    try {
      final email = "$phoneNumber@cropguardians.com";
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      User? user = result.user;
      
      if (user != null) {
        await createOrUpdateUserProfile(user);
        return user;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        print('Invalid credentials: ${e.message}');
      } else {
        print('Login error: ${e.code} - ${e.message}');
      }
      return null;
    } catch (e) {
      print('Unexpected login error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<User?> get userChanges => _auth.authStateChanges();

  // Check if user has password set
  Future<bool> userHasPassword(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.exists && (doc.data()?['hasPassword'] ?? false);
    } catch (e) {
      print('Error checking password status: $e');
      return false;
    }
  }
}