import 'package:flutter/material.dart';

Image logoWidget(String imageName, context) {
  double screenHeight = MediaQuery.of(context).size.height;
  // ignore: unused_local_variable
  double maxHeight = screenHeight * 0.8; // Adjust the percentage as needed

  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    height:240,
    width:240,
    color: Colors.white,
  );
}

Container signInButton(BuildContext context, bool isLogin, Function onTap) {
  return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
          onPressed: () {
            onTap();
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape:MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
          child: Text(
            isLogin ? "Log In" : "Sign Up",
            style: const TextStyle(
                color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 16),
          ),
          ),
  );

  

}

