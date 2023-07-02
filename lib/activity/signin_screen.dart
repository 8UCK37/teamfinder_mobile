import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:teamfinder_mobile/activity/home_screen.dart';
import 'package:teamfinder_mobile/utils/colors.dart';
import 'package:teamfinder_mobile/utils/login_controller.dart';

import '../reusable_widgets/reusable_widgets.dart';

class SignInActivity extends StatefulWidget {
  const SignInActivity({super.key});

  @override
  State<SignInActivity> createState() => _SignInActivityState();
}

class _SignInActivityState extends State<SignInActivity> {
  final controller = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        hexStringToColor("CB2B93"),
        hexStringToColor("9546C4"),
        hexStringToColor("5E61F4"),
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).size.height * 0.2, 20, 0),
              child: Column(
                children: <Widget>[
                  logoWidget("assets/images/logo-no-background.png", context),
                  const SizedBox(
                    height: 20,
                  ),
                  //signInButton(context, true, onTap)
                  Obx(() {
                    if (controller.googleAccount.value == null) {
                      return signInButton(context, true, onTap);
                    } else {
                      return buildHomeScreen();
                    }
                  })
                ],
              ))),
    ));
  }

  onTap() {
    print('tapped');
    // GoogleSignIn().signIn();
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => const HomeActivity()));
    controller.login();
  }

  Column buildHomeScreen() {
    return Column(
      children: [
        const Text(
          'Welcome to the Home Screen!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 123, 13, 13),
          ),
        ),
        Text(controller.googleAccount.value?.displayName?? ''),
        // Other widgets
      ],
    );
  }
}
