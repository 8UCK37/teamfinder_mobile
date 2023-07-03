import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


import '../activity/home_screen.dart';
import '../activity/login_screen.dart';

class AuthService {
  Future<void> signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // Check if the user is successfully signed in
    if (userCredential.user != null) {
      
      // Navigate to the HomeScreenWidget
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        // ignore: prefer_const_constructors
        MaterialPageRoute(builder: (context) => HomeScreenWidget()),
      );
    }
  }

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();

    // Navigate to the SignInScreen or any other screen you want
    // ignore: use_build_context_synchronously
    Navigator.push(
        context,
        // ignore: prefer_const_constructors
        MaterialPageRoute(builder: (context) => LoginActivity()),
      );
  }
}
