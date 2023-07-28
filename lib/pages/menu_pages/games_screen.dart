import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/chat_ui/chat_home.dart';
import 'package:teamfinder_mobile/pages/menu_pages/add_new_games_screen.dart';
import 'package:teamfinder_mobile/pages/search_page.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:colorful_circular_progress_indicator/colorful_circular_progress_indicator.dart';
import 'package:teamfinder_mobile/services/data_service.dart';

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
        showcase.sort((a, b) =>
            b['playtime_forever'].compareTo(a['playtime_forever']) as int);
        ownedGames = gamesList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<ProviderService>(context,listen:true);
    return Theme(
      data:userService.darkTheme! ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: userService.darkTheme!? Brightness.light:Brightness.dark
          ),
          backgroundColor:userService.darkTheme!? const Color.fromRGBO(46, 46, 46, 1): Colors.white,
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
                              child: Material(
                                elevation: 5,
                                shadowColor: Colors.grey,
                                shape: CircleBorder(),
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Color.fromRGBO(222, 209, 242, 100),
                                  child:
                                      Icon(Icons.search, color: Colors.blueGrey),
                                ),
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
                            child: const Material(
                              elevation: 5,
                              shadowColor: Colors.grey,
                              shape: CircleBorder(),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Color.fromRGBO(222, 209, 242, 100),
                                child: Icon(Icons.question_answer,
                                    color: Colors.deepPurple),
                              ),
                            ),
                          ),
                        ]),
                  ]),
            ],
          ),
          elevation: 0.0,
          //systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: Column(
            children: [
              // const Divider(
              //   thickness: 4,
              // ),
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
                padding: const EdgeInsets.all(10.0),
                child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.2), // Shadow color
                      spreadRadius: 2, // How wide the shadow should be
                      blurRadius: 5, // How spread out the shadow should be
                      offset: const Offset(0, 2),// Offset in x and y direction
                      blurStyle: BlurStyle.inner 
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  elevation: 15, // Elevation level
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * .782,
                      child: CustomGrid(items: showcase),
                    ),
                  ),
                ),
              ),
              ),
            ],
          ),
        
        floatingActionButton: FloatingActionButton(
          splashColor: Colors.blueAccent,
          backgroundColor: const Color.fromARGB(
              255, 22, 125, 99), //Theme.of(context).accentColor
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            debugPrint('add new games page');
            //debugPrint(ownedGames.toString());
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => AddNewGames(
                        list: ownedGames,
                      )),
            );
          },
        ),
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
