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
  dynamic showcase;
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
        showcase = [];
        for (dynamic game in gamesList) {
          game['selected'] = false;
          for (dynamic appid in res['appid'].split(',')) {
            if (game['appid'].toString() == appid.toString()) {
              game['selected'] = true;
              showcase.add(game);
            }
          }
        }
        ownedGames = gamesList;
      });
    }
  }

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
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
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
                              MaterialPageRoute(
                                  builder: (context) => ChatHome()),
                            );
                          },
                          child: const CircleAvatar(
                            radius: 20,
                            child: Icon(Icons.question_answer,
                                color: Colors.deepPurple),
                          ),
                        ),
                      ]),
                ]),
            const Divider(
              thickness: 4,
            )
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 25,
          ),
          const Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Text('Your favourite games',
                  style: TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: SizedBox(
                height: MediaQuery.of(context).size.height * .80,
                child: CustomGrid(items: showcase)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(
            255, 22, 125, 99), //Theme.of(context).accentColor
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          debugPrint('add new games page');
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomGrid extends StatelessWidget {
  dynamic items;
  CustomGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: items?.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Number of cards in a row
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemBuilder: (context, index) {
        if (items != null) {
          return CustomCard(appid: items[index]['appid'].toString());
        }
        return null;
      },
    );
  }
}

class CustomCard extends StatelessWidget {
  final String appid;

  CustomCard({Key? key, required this.appid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: Colors.deepPurpleAccent,
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(8), // Adjust the border radius as needed
        child: CachedNetworkImage(
          imageUrl:
              "https://steamcdn-a.akamaihd.net/steam/apps/$appid/library_600x900.jpg", // Replace with your image URL
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.fill, // Adjust the fit property as needed
          //width: double.infinity, // Adjust the width property as needed
          //height: double.infinity, // Adjust the height property as needed
        ),
      ),
    );
  }
}