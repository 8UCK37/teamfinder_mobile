import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../reusable_widgets/reusable_widgets.dart';
import '../utils/login_controller.dart';

class LoginActivity extends StatefulWidget {
  const LoginActivity({super.key});

  @override
  State<LoginActivity> createState() => _LoginActivityState();
}

final controller = Get.put(LoginController());

class _LoginActivityState extends State<LoginActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4B39EF), Color(0xFFEE8B60)],
            stops: [0, 1],
            begin: AlignmentDirectional(0.87, -1),
            end: AlignmentDirectional(-0.87, 1),
          ),
        ),
        alignment: const AlignmentDirectional(0, -1),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 70, 0, 32),
                child: Container(
                  width: 200,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: AlignmentDirectional(0, 0),
                  child: const Text('TeamFinder',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      )),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(250),
                child: Image.asset(
                  'assets/images/logo-no-background.png',
                  width: MediaQuery.sizeOf(context).width * 0.5,
                  height: 200,
                  fit: BoxFit.fill,
                ),
              ),
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
          ),
        ),
      ),
    );
  }

  Column buildHomeScreen() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundImage:
              Image.network(controller.googleAccount.value?.photoUrl ?? '')
                  .image,
        ),
        const Text(
          'Welcome to the Home Screen!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 123, 13, 13),
          ),
        ),
        Text(controller.googleAccount.value?.displayName ?? ''),
        // Other widgets
        const SizedBox(height: 16),
        ActionChip(
            avatar: const Icon(Icons.logout),
            label: const Text('Logout'),
            onPressed: () {
              controller.logOut();
            })
      ],
    );
  }

  TextButton loginButton() {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.blue,
      ),
      onPressed: () {
        controller.login();
      },
      child: Text('TextButton'),
    );
  }

  onTap() {
    controller.login();
  }
}
