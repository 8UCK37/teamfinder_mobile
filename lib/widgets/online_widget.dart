import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:teamfinder_mobile/pojos/user_pojo.dart';
import 'package:http/http.dart' as http;

class OnlineWidget extends StatefulWidget {
  const OnlineWidget({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _OnlineWidgetState createState() => _OnlineWidgetState();
}

class _OnlineWidgetState extends State<OnlineWidget>
    with SingleTickerProviderStateMixin {
  late List<UserPojo>? friendList = [];
  @override
  void initState() {
    super.initState();

    _getFriendList();
  }

  void _getFriendList() async {
    final url = Uri.parse('http://${dotenv.env['server_url']}/friendData');
    final user = FirebaseAuth.instance.currentUser;
    //print('friend list called');
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
        List<UserPojo> parsedFriendList = userPojoListFromJson(res);
        setState(() {
          parsedFriendList.sort((a, b) {
            if (a.isConnected && !b.isConnected) {
              return -1; // a comes before b
            } else if (!a.isConnected && b.isConnected) {
              return 1; // b comes before a
            } else {
              return 0; // order remains the same
            }
          });
          friendList =
              parsedFriendList; // Update the state variable with the parsed list
        });
        // Use the postList for further processing or display
        // ignore: unused_local_variable
        
      } else {
        // Request failed
        //print('Failed to hit Express backend endpoint');
      }
    } else {
      // User not logged in
      //print('User is not logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          const SizedBox(width: 15.0),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 2.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
                border: Border.all(width: 1.0, color: Colors.blue)),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.video_call, size: 20, color: Colors.purple),
                SizedBox(width: 5.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Post', style: TextStyle(color: Colors.blue)),
                    Text('Video', style: TextStyle(color: Colors.blue)),
                  ],
                )
              ],
            ),
          ),
          if (friendList != null) // Add a null check here
          for (UserPojo user in friendList!) // Add a null check here
            friendBubble(user)
        ],
      ),
    );
  }

  Widget friendBubble(UserPojo user) {
    return Padding(
      padding: const EdgeInsets.only(left:8.0),
      child: Stack(
              children: <Widget>[
                CircleAvatar(
                  radius: 22.0,
                  backgroundImage: NetworkImage(user.profilePicture),
                ),
                if(user.isConnected)
                const Positioned(
                  right: 1.0,
                  bottom: 5.0,
                  child: CircleAvatar(
                    radius: 7.0,
                    backgroundColor: Color.fromARGB(255, 30, 135, 33),
                  ),
                ),
              ],
            ),
    );
  }
}
