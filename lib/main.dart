import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/pages/home_page.dart';
import 'package:teamfinder_mobile/services/user_service.dart';
import 'pages/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ignore: prefer_const_constructors
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var auth = FirebaseAuth.instance;
  var isLogin = false;

  @override
  void initState() {
    checkIfLogin();
    super.initState();
  }

  checkIfLogin() async {
    auth.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        setState(() {
          isLogin = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=>UserService(),
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'TeamFinder',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          useMaterial3: true,
        ),
        home: isLogin ?  HomePage() : const LoginActivity()
      )
    );
  }
}
