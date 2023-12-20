import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/pages/home_page.dart';
import 'package:teamfinder_mobile/services/data_service.dart';
import 'package:teamfinder_mobile/services/friend_profile_service.dart';
import 'package:teamfinder_mobile/services/notification_observer.dart';
import 'chat_ui/camera_ui/CameraScreen.dart';
import 'dependency_injection.dart';
import 'global.dart';
import 'pages/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  // ignore: prefer_const_constructors
  runApp(MyApp());
  DependencyInjection.init();
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProviderService>(
            create: (context) => ProviderService()),
        ChangeNotifierProvider<FriendProfileService>(
            create: (context) => FriendProfileService()),
        ChangeNotifierProvider<NotificationWizard>(
            create: (context) => NotificationWizard()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TeamFinder',
        
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          useMaterial3: true,
        ),
        home: isLogin ? const HomePage() : const LoginActivity(),
        navigatorKey: GlobalVariable.navState,
      ),
    );
  }
}
