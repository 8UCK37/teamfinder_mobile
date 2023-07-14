import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:teamfinder_mobile/chat_ui/chat_home.dart';
import 'package:teamfinder_mobile/pages/search_page.dart';

class GamesPage extends StatefulWidget {
  const GamesPage({super.key});

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Unsubscribe the listener to avoid memory leaks
    super.dispose();
  }

  Future<void> getOwnedGamesFromDb() async {
    Dio dio = Dio();

    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user!.getIdToken();
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    //debugPrint(user.uid.toString());
    var response = await dio.post(
      'http://${dotenv.env['server_url']}/getPostById',
      data: {'uid': user.uid.toString()},
      options: options,
    );
    if (response.statusCode == 200) {
      setState(() {
        // Update the state variable with the parsed list
      });
    }
  }

  Future<void> getSelectedGames() async {
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Row(
                children: <Widget>[
                  Row(
                    children: [
                      Text('TeamFinder',
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                GestureDetector(
                  onTap: () {
                    debugPrint('search clicked');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchPage()),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 20,
                      child: Icon(Icons.search, color: Colors.black),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    debugPrint('goto chat');

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatHome()),
                    );
                  },
                  child: const CircleAvatar(
                    radius: 20,
                    child:
                        Icon(Icons.question_answer, color: Colors.deepPurple),
                  ),
                ),
              ]),
            ]),
        backgroundColor: Colors.white,
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
    );
  }
}
