import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/pages/splash_screen.dart';
import 'package:teamfinder_mobile/services/notification_observer.dart';
import '../pages/login_screen.dart';

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
      Navigator.pushReplacement(
        context,
        // ignore: prefer_const_constructors
        MaterialPageRoute(builder: (context) => SplashFuturePage()),
      );
    }
  }

  Future<void> signOut(BuildContext context) async {
    final notiObserver =
        Provider.of<NotificationWizard>(context, listen: false);
    notiObserver.updateNotiList([]);
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
