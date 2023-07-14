import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
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
  dynamic ownedGames;
  @override
  void initState() {
    super.initState();
    getOwnedGamesFromDb();
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
    var response = await dio.get(
      'http://${dotenv.env['server_url']}/getOwnedgames',
      options: options,
    );
    if (response.statusCode == 200) {
      //debugPrint(response.data.toString());
      setState(() {
        ownedGames = jsonDecode(jsonDecode(response.data)[0]['games']);
        getSelectedGames(ownedGames);
      });
    }
  }

  Future<void> getSelectedGames(dynamic gamesList) async {
    Dio dio = Dio();

    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user!.getIdToken();
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    //debugPrint(user.uid.toString());
    var response = await dio.get(
      'http://${dotenv.env['server_url']}/getSelectedGames',
      options: options,
    );
    if (response.statusCode == 200) {
      //debugPrint(response.data.toString());
      dynamic res = jsonDecode(response.data)[0];
      //debugPrint(res.toString());
      setState(() {
        for (dynamic game in gamesList) {
            game['selected'] = false;
          for (dynamic appid in res['appid'].split(',')) {
            if (game['appid'].toString() == appid.toString()) {
              game['selected'] = true;
            } 
          }
        }
        ownedGames = gamesList;
      });
    }
  }
  final List<String> items = [
    'Card 1',
    'Card 2',
    'Card 3',
    'Card 4',
    'Card 5',
    'Card 6',
    'Card 7',
    'Card 8',
    'Card 9',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            Row(
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
                  Row(mainAxisAlignment: MainAxisAlignment.end, 
                  children: <Widget>[
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
                  ]
                ),
                
                ]
              ),
              const Divider(thickness: 4,)
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        
      ),
      body:  CustomGrid()
    );
  }


}
class CustomGrid extends StatelessWidget {
  final List<String> items = [
    'Card 1',
    'Card 2',
    'Card 3',
    'Card 4',
    'Card 5',
    'Card 6',
    'Card 7',
    'Card 8',
    'Card 9',
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Number of cards in a row
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemBuilder: (context, index) {
        return CustomCard(item: items[index]);
      },
    );
  }
}
class CustomCard extends StatelessWidget {
  final String item;

  const CustomCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
  elevation: 8,
  child: Center(
    child: CachedNetworkImage(
      imageUrl: "https://steamcdn-a.akamaihd.net/steam/apps/730/library_600x900.jpg", // Replace with your image URL
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
      fit: BoxFit.cover, // Adjust the fit property as needed
      width: double.infinity, // Adjust the width property as needed
      height: double.infinity, // Adjust the height property as needed
    ),
  ),
);
  }
}