import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Handles Firebase Authentication and Google Sign-In.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // ── Stream ────────────────────────────────────────────────────────────────

  /// Emits the current Firebase [User?] whenever auth state changes.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ── Getters ───────────────────────────────────────────────────────────────

  /// The currently signed-in Firebase user, or null if not signed in.
  User? get currentUser => _auth.currentUser;

  bool get isLoggedIn => _auth.currentUser != null;

  // ── Sign-In ───────────────────────────────────────────────────────────────

  /// Triggers Google Sign-In flow and signs into Firebase.
  /// Returns the [UserCredential] on success, null if the user cancelled.
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the sign-in
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw Exception('Sign-in failed: ${e.message}');
    }
  }

  // ── Sign-Out ──────────────────────────────────────────────────────────────

  /// Signs out from both Google and Firebase.
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
