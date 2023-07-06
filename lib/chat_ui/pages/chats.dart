import 'package:flutter/material.dart';
import 'package:teamfinder_mobile/models/chat_model.dart';
import 'package:teamfinder_mobile/chat_ui/pages/chat_screen.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {

  @override
  Widget build(BuildContext context) {
    // debugPrint(messageData.length.toString());
    return ListView.builder(
      itemCount: messageData.length,
      itemBuilder: (context,i) => Column(
        children: <Widget>[
          SizedBox(height: 15,),
          //const Divider(height: 22.0,),
          ListTile(
            leading: CircleAvatar(
              maxRadius: 25,
              backgroundImage: NetworkImage(messageData[i].imageUrl),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
              Text(
              messageData[i].name,
                style: const TextStyle(
                fontWeight: FontWeight.bold
              ),
              ),
              Text(
                messageData[i].time,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0
                  ),
                ),
              ],
            ),
            subtitle: Container(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                messageData[i].message,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15.0
                  ),
                ),
            ),
            onTap: (){
              var route = MaterialPageRoute(
                builder: (BuildContext context) => ChatScreen(name: messageData[i].name, profileImage: messageData[i].imageUrl)
              );
              Navigator.of(context).push(route);
            },
          ),
        ],
      ),
    );
  }
}