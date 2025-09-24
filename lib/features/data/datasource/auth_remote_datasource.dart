

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String> signInWithGoogle() async {
    try {
       
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception(
          'Sign-In cancelled by user. Please try again if you wish to continue.',
        );
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        return user.uid;
      } else {
        throw Exception(
          'Authentication failed. No user information was returned. Please try signing in again.',
        );
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(
        'Authentication failed: ${e.message ?? "An unexpected error occurred. Please try again."}',
      );
    } catch (e) {
      throw Exception('Unexpected error occurred: $e. Please try again.');
    }
  }
}


