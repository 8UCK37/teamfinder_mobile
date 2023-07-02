
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:teamfinder_mobile/activity/home_screen.dart';


class LoginController extends GetxController {
  
  final _googleSignin = GoogleSignIn();
  var googleAccount = Rx<GoogleSignInAccount?>(null);

  login() async {
    googleAccount.value = await _googleSignin.signIn();
    
    if (googleAccount.value != null) {
      Get.to(() => const HomeActivity());
    }
  }
}
