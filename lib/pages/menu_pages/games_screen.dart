import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:teamfinder_mobile/pages/menu_pages/add_new_games_screen.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:colorful_circular_progress_indicator/colorful_circular_progress_indicator.dart';
import 'package:teamfinder_mobile/services/data_service.dart';
import '../../utils/router_animation.dart';
import '../../widgets/custom_appbar.dart';

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
      //debugPrint(response.toString());
      if (response.data.length > 2) {
        setState(() {
          ownedGames = jsonDecode(jsonDecode(response.data)[0]['games']);
          getSelectedGames(ownedGames);
        });
      }
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
      dynamic res;
      if (response.data.length > 2) {
        res = jsonDecode(response.data)[0];
      } else {
        res=[];
      }

      //debugPrint(res.toString());
      setState(() {
        showcase = [];
        for (dynamic game in gamesList) {
          game['selected'] = false;
          if(res.length!=0){
            for (dynamic appid in res['appid'].split(',')) {
            if (game['appid'].toString() == appid.toString()) {
              game['selected'] = true;
              showcase.add(game);
            }
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
    final userService = Provider.of<ProviderService>(context, listen: true);
    return Theme(
      data: userService.darkTheme! ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: TeamFinderAppBar(
          titleText: "Games",
          isDark: userService.darkTheme!,
          implyLeading: true,
          height: 55,
          showNotificationCount: false,
        ),
        body: Column(
          children: [
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
              padding: const EdgeInsets.fromLTRB(10.0, 10, 10, 0),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: CustomGrid(items: showcase),
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
            if (ownedGames != null) {
              AnimatedRouter.slideToPageBottomReplace(context, AddNewGames(
                          list: ownedGames,
                        ));
            } else {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                title: 'No games found',
                text: 'Sorry, but you have to link Steam first',
              );
            }
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
