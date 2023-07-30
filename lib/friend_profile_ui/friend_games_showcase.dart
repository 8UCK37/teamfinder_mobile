import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorful_circular_progress_indicator/colorful_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flipcard/gesture_flip_card.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/services/friend_profile_service.dart';

class FriendGamesShowCase extends StatefulWidget {

  const FriendGamesShowCase({super.key});

  @override
  State<FriendGamesShowCase> createState() => _FriendGamesShowCaseState();
}

class _FriendGamesShowCaseState extends State<FriendGamesShowCase> {
  dynamic ownedGames = [];
  dynamic showcase = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Unsubscribe the listener to avoid memory leaks
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    final profileService =
        Provider.of<FriendProfileService>(context, listen: false);
    profileService.getShowCase(profileService.friendProfile!.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    final profileService = Provider.of<FriendProfileService>(context, listen: true);
    showcase = profileService.showcase;
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.only(left:10.0,right:18),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(profileService.friendProfile!.profilePicture)
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                showcase.length == 0
                                    ? "${profileService.friendProfile!.name} has no favourite games"
                                    : "${profileService.friendProfile!.name}'s favourite games",
                                style:const TextStyle(
                                    color: Colors.deepPurpleAccent,
                                    fontWeight: FontWeight.bold,),   
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Material(
                //color: Colors.deepOrange,
                elevation: 15, // Elevation level
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Expanded(
                    child: showcase.length != 0
                        ? Column(
                            children: [
                              CustomGrid(items: showcase!),
                            ],
                          )
                        :  Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Sadly there's nothing to see here!!😪",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22)),
                                ],
                              ),
                              Container(
                                height: 200,
                                width: 200,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/loneliness.png"))),
                              )
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
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
