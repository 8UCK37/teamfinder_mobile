import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:teamfinder_mobile/chat_ui/pages/chat_screen.dart';
import 'package:http/http.dart' as http;
import '../../pojos/user_pojo.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> with SingleTickerProviderStateMixin {
  late List<UserPojo> activeConvoList=[];

  @override
  void initState() {
    super.initState();

    _getActiveConvo();
  }

  Future<void> _getActiveConvo() async {
    final url = Uri.parse('http://${dotenv.env['server_url']}/getChats');
    final user = FirebaseAuth.instance.currentUser;
    List<dynamic> uniqueConvId = [];
    List<dynamic> uniqueConv = [];

    if (user != null) {
      final idToken = await user.getIdToken();

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $idToken'},
      );

      if (response.statusCode == 200) {
        // Request successful
        // var res = response.body;
        // List<UserPojo> parsedactiveConvoList = userPojoFromJson(res);
        debugPrint('succ');
        final res = jsonDecode(response.body);
        res.forEach((data) {
          if (data['chat_type'] == 'received') {
            if (!uniqueConvId.contains(data['sender'])) {
              uniqueConvId.add(data['sender']);
              uniqueConv.add(UserPojo.fromJson(data));
            }
          }
          if (data['chat_type'] == 'sent') {
            if (!uniqueConvId.contains(data['receiver'])) {
              uniqueConvId.add(data['receiver']);
              uniqueConv.add(UserPojo.fromJson(data));
            }
          }
        });

        setState(() {
          activeConvoList = List<UserPojo>.from(uniqueConv);
          debugPrint(uniqueConv.toString());
        });
       
      } else {
        // Request failed
        debugPrint('Failed to hit Express backend endpoint');
      }
    } else {
      // User not logged in
      debugPrint('User is not logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint(messageData.length.toString());
    return ListView.builder(
      itemCount: activeConvoList.length,
      itemBuilder: (context, i) => Column(
        children: <Widget>[
          const SizedBox(
            height: 15,
          ),
          //const Divider(height: 22.0,),
          ListTile(
            leading: CircleAvatar(
              maxRadius: 25,
              backgroundImage: NetworkImage(activeConvoList![i].profilePicture),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  activeConvoList![i].name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                  //messageData[i].time,
                  '',
                  style: const TextStyle(color: Colors.grey, fontSize: 16.0),
                ),
              ],
            ),
            subtitle: Container(
              padding: const EdgeInsets.only(top: 5.0),
              child: const Text(
                //messageData[i].message,
                'Tap to open',
                style: TextStyle(color: Colors.grey, fontSize: 15.0),
              ),
            ),
            onTap: () {
              var route = MaterialPageRoute(
                  builder: (BuildContext context) => ChatScreen(
                      friendId:activeConvoList![i].id,
                      name: activeConvoList![i].name,
                      profileImage: activeConvoList![i].profilePicture));
              Navigator.of(context).push(route);
            },
          ),
        ],
      ),
    );
  }
}
