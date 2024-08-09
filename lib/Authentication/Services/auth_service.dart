import 'package:firebase_auth/firebase_auth.dart';
class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get userChanges => _firebaseAuth.authStateChanges();

  Future<User?> signUpWithEmail(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  Future<User?> signInWithEmail(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification(User user) async {
    await user.sendEmailVerification();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<User?> handleGoogleSignIn() async {
    GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
    UserCredential userCredential = await FirebaseAuth.instance.signInWithProvider(googleAuthProvider);
    return userCredential.user;
  }
}
