import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../pojos/post_pojo.dart';
import '../widgets/online_widget.dart';
import '../widgets/post_widget.dart';
import '../widgets/separator_widget.dart';
import '../widgets/write_something_widget.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with SingleTickerProviderStateMixin {
  List<PostPojo>? postList;
  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  void _fetchPosts() async {
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
        if(mounted){
          setState(() {
          postList =parsedPosts; // Update the state variable with the parsed list
          
        });
        }
        
      } else {
        // Request failed
        debugPrint('Failed to hit Express backend endpoint');
      }
    } else {
      // User not logged in
      debugPrint('User is not logged in');
    }
  }

  Future<void> _handleRefresh() async {
  _fetchPosts();
  }



  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Divider(),
            const OnlineWidget(),
            const SeparatorWidget(),
            const WriteSomethingWidget(),
            if (postList != null) // Add a null check here
              for (PostPojo post in postList!) // Add a null check here
                Column(
                  children: <Widget>[
                    const SeparatorWidget(),
                    PostWidget(post: post),
                  ],
                ),
            const SeparatorWidget(),
          ],
        ),
      ),
    );
  }
}
