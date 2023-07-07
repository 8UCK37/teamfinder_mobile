import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:teamfinder_mobile/chat_ui/pages/chat_screen.dart';
import 'package:teamfinder_mobile/pojos/user_pojo.dart';
import 'package:http/http.dart' as http;

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> with SingleTickerProviderStateMixin {
  late List<UserPojo>? friendList=[];

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
        List<UserPojo> parsedFriendList = userPojoFromJson(res);
        setState(() {
          friendList = parsedFriendList; // Update the state variable with the parsed list
        });
        // Use the postList for further processing or display
        // ignore: unused_local_variable
        for (var friend in parsedFriendList) {
          //print(friend);
          // ... Access other properties as needed
        }
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
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.deepPurple),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            color: Colors.deepPurple,
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            color: Colors.deepPurple,
            onPressed: () {},
          ),
        ],
        // ignore: avoid_unnecessary_containers
        title: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("All Friends",
                  style: TextStyle(color: Colors.deepPurple)),
              // ignore: avoid_unnecessary_containers
              Container(
                  // padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(
                'You have ${friendList!.length} Friends',
                style: const TextStyle(
                    fontSize: 12.0,
                    fontStyle: FontStyle.italic,
                    color: Colors.deepPurpleAccent),
              ))
            ],
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: friendList?.length,
        itemBuilder: (context, i) => Column(
          children: <Widget>[
            const Divider(
              height: 22.0,
            ),
            ListTile(
              leading: CircleAvatar(
                maxRadius: 25,
                backgroundImage: NetworkImage(friendList![i].profilePicture),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    friendList![i].name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'MOBILE',
                    style: TextStyle(color: Colors.green, fontSize: 16.0),
                  ),
                ],
              ),
              onTap: () {
                var route = MaterialPageRoute(
                    builder: (BuildContext context) => ChatScreen(
                        friendId: friendList![i].id,
                        name: friendList![i].name,
                        profileImage: friendList![i].profilePicture));
                Navigator.of(context).push(route);
              },
            ),
          ],
        ),
      ),
    );
  }
}
