import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:teamfinder_mobile/pojos/post_pojo.dart';
import 'package:http/http.dart' as http;

class UserService extends ChangeNotifier {
  Map<String, dynamic> user = {}; // Initialize as an empty map
  List<PostPojo>? feed;

  void updateSharedVariable(Map<String, dynamic> newValue) {
    user = newValue;
    notifyListeners();
  }

  void fetchPosts() async {
    final url = Uri.parse('http://${dotenv.env['server_url']}/getPost');
    final user = FirebaseAuth.instance.currentUser;
    debugPrint('fetch post called');
    if (user != null) {
      final idToken = await user.getIdToken();

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $idToken'},
      );

      if (response.statusCode == 200) {
        // Request successful
        var res = response.body;
        //print(res);
        // Parse the JSON response into a list of PostPojo objects
        List<PostPojo> parsedPosts = postPojoFromJson(res);
        feed = parsedPosts; // Update the state variable with the parsed list
        notifyListeners();
      }
    }
  }
}
