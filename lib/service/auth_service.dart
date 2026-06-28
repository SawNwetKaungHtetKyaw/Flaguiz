import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  /// Call once before using Google Sign-In
  Future<void> init() async {
    await _googleSignIn.initialize(
      serverClientId: '916738715936-844qlradgiq0k9i7cbe8c5st2mlp1kcs.apps.googleusercontent.com',
    );
  }

  // Google Login
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  // Delete account
  Future<void> deleteAccount() async {
  final user = _auth.currentUser;

  if (user == null) return;

  // ignore: unnecessary_nullable_for_final_variable_declarations
  final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();

  if (googleUser == null) {
    throw Exception("Re-authentication canceled by user.");
  }

  final googleAuth = googleUser.authentication; 

  final credential = GoogleAuthProvider.credential(
    idToken: googleAuth.idToken,
  );

  await user.reauthenticateWithCredential(credential);

  await user.delete();

  await logout();
}

  User? get currentUser => _auth.currentUser;
}
