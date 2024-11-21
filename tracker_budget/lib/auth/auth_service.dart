import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up method (existing code)
  Future<String?> signUp(String email, String password, String username) async {
    try {
      // Create user with email and password
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the Firebase User
      User? user = result.user;

      // If user is not null, save username to Firestore
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'username': username,
          'email': email,
          'createdAt': Timestamp.now(),
        });
      }

      return null; // No error, return null
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'The email address is already in use by another account.';
      }
      return 'Error: ${e.message}';
    } catch (e) {
      return 'An unexpected error occurred.';
    }
  }

  // Custom sign-in method (your provided code)
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user; // Return the authenticated user
    } on FirebaseAuthException catch (e) {
      print('Error: ${e.message}'); // Print error to console
      return null; // Return null on failure
    }
  }

  // Sign out method (existing code)
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Optionally, you could have a method to check if the user is logged in
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
