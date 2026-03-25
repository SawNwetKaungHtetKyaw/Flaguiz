import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User cancelled

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      print('Google sign-in error: $e');
      try {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) return null; // User cancelled

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        return userCredential.user;
      } catch (e) {
        print("Retry failed: $e");
        return null;
      }
    }
  }

  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) return;

    // 🔥 Re-authenticate with Google
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception("Re-auth cancelled");

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await user.reauthenticateWithCredential(credential);

    await user.delete();

    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  // Current user
  User? get currentUser => _auth.currentUser;
}
