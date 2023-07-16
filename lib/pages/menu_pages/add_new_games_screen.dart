import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:teamfinder_mobile/chat_ui/chat_home.dart';
import 'package:teamfinder_mobile/pages/search_page.dart';
import 'package:teamfinder_mobile/widgets/search_bar.dart';

class AddNewGames extends StatefulWidget {
  final List<dynamic> list;
  AddNewGames({required this.list});

  @override
  State<AddNewGames> createState() => _AddNewGamesState();
}

class _AddNewGamesState extends State<AddNewGames>
    with TickerProviderStateMixin {
  dynamic ownedGames;
  final TextEditingController _textController = TextEditingController();
  bool searchOpened = false;
  @override
  void initState() {
    super.initState();
    //testOwned();
    searchOpened = false;
    setState(() {
      widget.list.sort((a, b) {
        if (a['selected'] && !b['selected']) {
          return -1; // a comes before b
        } else if (!a['selected'] && b['selected']) {
          return 1; // b comes before a
        } else {
          return 0; // order remains the same
        }
      });
      ownedGames = widget.list;
    });
  }

  void testOwned() {
    for (dynamic game in ownedGames) {
      debugPrint(game.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
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
                              child: Icon(Icons.question_answer,
                                  color: Colors.deepPurple),
                            ),
                          ),
                        ),
                      ]),
                ]),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        //systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Column(children: [
        // const Divider(
        //   thickness: 4,
        // ),
        const Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Text('Here are the games you own...',
                style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        Row(
          children: [
            CustomSearchBar(
              enableBoxShadow: true,
              searchBoxWidth: MediaQuery.of(context).size.width * .80,
              autoOpenOnInit: false,
              textEditingController: _textController,
              isOriginalAnimation: true,
              enableKeyboardFocus: true,
              durationInMilliSeconds: 450,
              onChanged: (String typedTxt) {
                debugPrint(typedTxt);
              },
              onExpansionComplete: () {
                debugPrint('do something just after searchbox is opened.');
              },
              onCollapseComplete: () {
                debugPrint('do something just after searchbox is closed.');
                
              },
              onPressButton: (isSearchBarOpens) {
                debugPrint(
                    'do something before animation started. It\'s the ${isSearchBarOpens ? 'opening' : 'closing'} animation');
                setState(() {
                  if (isSearchBarOpens) {
                    searchOpened = true;
                  } else {
                    Future.delayed(const Duration(milliseconds: 140), () {
                      searchOpened = false;
                    });
                  }
                });
              },
              trailingWidget: const Icon(
                Icons.search,
                size: 20,
                color: Colors.black,
              ),
              secondaryButtonWidget: const Icon(
                Icons.close,
                size: 20,
                color: Colors.black,
              ),
              buttonWidget: const Icon(
                Icons.search,
                size: 20,
                color: Colors.black,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SizedBox(
              height: MediaQuery.of(context).size.height *
                  (searchOpened ? 0.3 : 0.72),
              child: CustomGrid(items: ownedGames)),
        ),
      ]),
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

  const CustomCard({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor:
          game['selected'] ? Colors.deepPurpleAccent : Colors.deepOrange,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: game['selected'] ? Colors.blue : Colors.redAccent,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(8), // Adjust the border radius as needed
        child: Stack(children: <Widget>[
          Container(
            width: 110,
            child: CachedNetworkImage(
              imageUrl:
                  "https://steamcdn-a.akamaihd.net/steam/apps/${game['appid']}/library_600x900.jpg", // Replace with your image URL
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.fill, // Adjust the fit property as needed
              //width: double.infinity, // Adjust the width property as needed
              //height: double.infinity, // Adjust the height property as needed
            ),
          ),
          Positioned(
            bottom: 70,
            left: 70,
            child: Checkbox(
              activeColor: Colors.green,
              value: game['selected'],
              onChanged: (value) {
                // Handle checkbox onChanged event
              },
            ),
          ),
        ]),
      ),
    );
  }
}
