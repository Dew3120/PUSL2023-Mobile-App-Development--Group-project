import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;

  //  Demo bypass 
  // Lets us log in with hard-coded demo credentials so the app looks like
  // a returning user session during report screenshots, without creating a
  // real Firebase user. Nothing is sent to Firebase in this path.
  static const String demoUsername = 'dewmith';
  static const String demoPassword = '12345';
  static const String demoDisplayName = 'Dewmith';
  static const String demoEmail = 'dewmith@mycartier.demo';
  static const String demoPhone = '+94 77 456 7890';

  static String? _demoName;

  static bool get isDemoUser => _demoName != null;
  static String? get demoName => _demoName;

  static void signInAsDemo() {
    _demoName = demoDisplayName;
  }

  static void clearDemoUser() {
    _demoName = null;
  }

  static User? get currentUser => _auth.currentUser;

  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  static Future<UserCredential> signIn(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  static Future<UserCredential> signUp(String email, String password) =>
      _auth.createUserWithEmailAndPassword(email: email, password: password);

  /// Updates the current user's display name (used as the profile greeting).
  static Future<void> updateDisplayName(String name) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await user.updateDisplayName(name);
    await user.reload();
  }

  /// Friendly name shown in profile greetings. Falls back to the
  /// portion of the email before the "@" if no display name is set.
  static String displayNameOrEmailPrefix() {
    if (_demoName != null) return _demoName!;
    final user = _auth.currentUser;
    if (user == null) return 'Guest';
    final name = user.displayName;
    if (name != null && name.trim().isNotEmpty) return name.trim();
    final email = user.email ?? '';
    if (email.contains('@')) return email.split('@').first;
    return 'Member';
  }

  static Future<void> sendVerificationEmail() =>
      _auth.currentUser!.sendEmailVerification();

  static Future<void> sendPasswordReset(String email) =>
      _auth.sendPasswordResetEmail(email: email);

  static Future<void> signOut() async {
    clearDemoUser();
    await _auth.signOut();
  }

  static String parseError(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return 'No account found with this email.';
        case 'wrong-password':
        case 'invalid-credential':
          return 'Incorrect email or password.';
        case 'email-already-in-use':
          return 'An account already exists with this email.';
        case 'weak-password':
          return 'Password must be at least 6 characters.';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';
        case 'network-request-failed':
          return 'No internet connection. Please try again.';
        default:
          return 'Something went wrong. Please try again.';
      }
    }
    return 'Something went wrong. Please try again.';
  }
}
