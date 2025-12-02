import 'package:firebase_auth/firebase_auth.dart';
import 'package:yegna_eqif_new/core/utils/app_logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      AppLogger.error('Sign up failed', e);
      return null;
    }
  }

  // Register with email and password
  Future<User?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      if (user != null) {
        // Create a new document for the user with uid
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'name': 'No name', // Default name
          'profilePic': 'http://www.gravatar.com/avatar/?d=mp',
        });
      }

      return user;
    } catch (e) {
      AppLogger.error('Sign in failed', e);
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      AppLogger.error('Sign out failed', e);
      return;
    }
  }

  // Stream to listen to authentication state changes
  Stream<User?> get user {
    return _auth.authStateChanges();
  }
}
