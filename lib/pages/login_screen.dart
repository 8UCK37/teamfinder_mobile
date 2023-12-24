import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sign_button/sign_button.dart';
import 'package:teamfinder_mobile/services/auth_service.dart';


class LoginActivity extends StatefulWidget {
  const LoginActivity({super.key});

  @override
  State<LoginActivity> createState() => _LoginActivityState();
}
class _LoginActivityState extends State<LoginActivity> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 218, 74, 69), Color.fromARGB(255, 80, 19, 11)],
              stops: [0, 1],
              begin: AlignmentDirectional(0.87, -1),
              end: AlignmentDirectional(-0.87, 1),
            ),
          ),
          alignment: const AlignmentDirectional(0, -1),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 70,
                decoration: BoxDecoration(
                  //border:Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: const AlignmentDirectional(0, 0),
                child: const Text('CallOut',
                    style: TextStyle(
                      fontFamily: 'Caveat',
                      color: Colors.white,
                      fontSize: 45,
                      fontWeight: FontWeight.w600,
                    )),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(250),
                child: Image.asset(
                  'assets/images/megaphone.png',
                  width: MediaQuery.sizeOf(context).width * 0.5,
                  height: 200,
                  fit: BoxFit.fill,
                ),
              ),
             const SizedBox(
                    height: 20,
                  ),
              SignInButton(
                  buttonType: ButtonType.google,
                  onPressed: () {
                    AuthService().signInWithGoogle(context);
                  }),
            ],
          ),
        ),
      ),
    );
  }

}
