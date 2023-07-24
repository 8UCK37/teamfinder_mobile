import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorful_circular_progress_indicator/colorful_circular_progress_indicator.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_flip_card/flipcard/gesture_flip_card.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class FriendGamesShowCase extends StatefulWidget {
  final String? friendName;
  final String friendId;
  final String? friendProfileImage;

  const FriendGamesShowCase({
    super.key,
    required this.friendId,
    this.friendName,
    this.friendProfileImage,
  });

  @override
  State<FriendGamesShowCase> createState() => _FriendGamesShowCaseState();
}

class _FriendGamesShowCaseState extends State<FriendGamesShowCase> {
  dynamic ownedGames;
  dynamic showcase;

  @override
  void initState() {
    super.initState();
    getShowCase();
  }

  @override
  void dispose() {
    // Unsubscribe the listener to avoid memory leaks
    super.dispose();
  }

  Future<void> getShowCase() async {
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
      'http://${dotenv.env['server_url']}/getFrndOwnedGames',
      data: {'frnd_id': widget.friendId},
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
    var response = await dio.post(
      'http://${dotenv.env['server_url']}/getFrndSelectedGames',
      data: {'frnd_id': widget.friendId},
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
        showcase.sort((a, b) =>
            b['playtime_forever'].compareTo(a['playtime_forever']) as int);
        ownedGames = gamesList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 75,
        child: GNav(duration: const Duration(milliseconds: 250), gap: 5, tabs: [
          const GButton(
            icon: Icons.receipt_long,
            text: 'Posts',
            textColor: Colors.deepPurple,
            iconActiveColor: Colors.deepPurple,
          ),
          GButton(
            onPressed: () {
              
            },
            icon: Icons.sports_esports,
            text: 'Games',
            textColor: Colors.deepOrange,
            iconActiveColor: Colors.deepOrange,
          ),
          GButton(
            onPressed: () {},
            icon: Icons.link,
            text: 'Linked Acc',
            textColor: Colors.blue,
            iconActiveColor: Colors.blue,
          ),
          const GButton(
            icon: Icons.people_outline,
            text: 'Friends',
            textColor: Color.fromARGB(255, 152, 129, 14),
            iconActiveColor: Color.fromARGB(255, 152, 129, 14),
          ),
        ]),
      ),
      body: Column(
        children: [
          // const Divider(
          //   thickness: 4,
          // ),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Text("${widget.friendName!}'s favourite games",
                  style: const TextStyle(
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
          return CustomCard(game: items[index]);
        }
        return null;
      },
    );
  }
}

class CustomCard extends StatelessWidget {
  final dynamic game;

  CustomCard({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureFlipCard(
        animationDuration: const Duration(milliseconds: 250),
        frontWidget: CustomCardFront(appid: game['appid'].toString()),
        backWidget: CustomCardBack(
          game: game,
        ));
  }
}

class CustomCardFront extends StatelessWidget {
  final String appid;

  CustomCardFront({Key? key, required this.appid}) : super(key: key);

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
          placeholder: (context, url) => const Center(
            child: SizedBox(
              height: 40,
              width: 40,
              child: ColorfulCircularProgressIndicator(
                colors: [Colors.blue, Colors.red, Colors.amber, Colors.green],
                strokeWidth: 5,
                indicatorHeight: 5,
                indicatorWidth: 5,
              ),
            ),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

class CustomCardBack extends StatelessWidget {
  final dynamic game;

  CustomCardBack({Key? key, required this.game}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: Colors.deepPurpleAccent,
      child: ClipRRect(
          borderRadius:
              BorderRadius.circular(8), // Adjust the border radius as needed
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(children: <Widget>[
              const Text('Total Play-Time'),
              Text(
                  '${(game['playtime_forever'] / 60).toStringAsFixed(2)} hours')
            ]),
          )),
    );
  }
}
