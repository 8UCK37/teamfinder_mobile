// ignore_for_file: unnecessary_overrides, duplicate_ignore

import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorful_circular_progress_indicator/colorful_circular_progress_indicator.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/chat_ui/chat_home.dart';
import 'package:teamfinder_mobile/pages/menu_pages/games_screen.dart';
import 'package:teamfinder_mobile/pages/search_page.dart';
import 'package:teamfinder_mobile/services/data_service.dart';
import 'package:teamfinder_mobile/widgets/search_bar.dart';

class AddNewGames extends StatefulWidget {
  final List<dynamic> list;
  const AddNewGames({super.key, required this.list});

  @override
  State<AddNewGames> createState() => _AddNewGamesState();
}

// ignore: duplicate_ignore
class _AddNewGamesState extends State<AddNewGames>
    with TickerProviderStateMixin {
  dynamic ownedGames;
  dynamic ownedGamesCopy;
  late String selected;
  bool isKeyboardVisible = false;
  final TextEditingController _textController = TextEditingController();
  bool searchOpened = false;
  late String searchTerm;
  @override
  void initState() {
    super.initState();
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
      ownedGamesCopy = widget.list;
    });
  }

  // ignore: unnecessary_overrides
  @override
  void dispose() {
    if(!mounted){
      _textController.dispose();
    }
    super.dispose();
  }

  void searchGames() {
    if (searchTerm == '') {
      setState(() {
        ownedGames = ownedGamesCopy;
      });
    } else {
      ownedGames = ownedGamesCopy
          .where((game) =>
              game['name'].toString().toLowerCase().contains(searchTerm))
          .toList();
    }
  }

  void buildSelectedString() async {
    setState(() {
      selected = '';
      //debugPrint(selected);
      for (dynamic game in ownedGames) {
        if (game['selected']) {
          if (selected == '') {
            selected += game['appid'].toString();
          } else {
            // ignore: prefer_interpolation_to_compose_strings
            selected += ',' + game['appid'].toString();
          }
        }
      }
    });
    //debugPrint(selected);
    Dio dio = Dio();
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user!.getIdToken();
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    var response = await dio.post(
      'http://${dotenv.env['server_url']}/gameSelect',
      data: {'appid': selected},
      options: options,
    );
    if (response.statusCode == 200) {
      debugPrint('saved fav games');
      _displaySuccessMotionToast();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<ProviderService>(context, listen: true);
    return Theme(
      data: userService.darkTheme! ? ThemeData.dark() : ThemeData.light(),
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const GamesPage()));
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: userService.darkTheme!
                  ? const Color.fromRGBO(46, 46, 46, 100)
                  : Colors.white,
              title: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Row(
                          children: <Widget>[
                            Row(
                              children: [
                                Text('CallOut',
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
                                      backgroundColor:
                                          Color.fromRGBO(222, 209, 242, 100),
                                      child: Icon(Icons.search,
                                          color: Colors.blueGrey),
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
                                    backgroundColor:
                                        Color.fromRGBO(222, 209, 242, 100),
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
              //systemOverlayStyle: SystemUiOverlayStyle.light,
            ),
            body: Column(children: [
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
                      setState(() {
                        searchTerm = typedTxt;
                        searchGames();
                      });
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
              SizedBox(
                height: MediaQuery.of(context).size.height - 200,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: CustomGrid(items: ownedGames),
                ),
              ),
            ]),
            floatingActionButton: FloatingActionButton(
              splashColor: Colors.lightGreen,
              backgroundColor: const Color.fromARGB(
                  255, 22, 125, 99), //Theme.of(context).accentColor
              child: const Icon(
                Icons.save,
                color: Colors.white,
              ),
              onPressed: () {
                debugPrint('save');
                buildSelectedString();
              },
            )),
      ),
    );
  }

  void _displaySuccessMotionToast() {
    MotionToast toast = MotionToast.success(
      toastDuration: const Duration(seconds: 3),
      title: const Text(
        'Sucess!!',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      description: const Text(
        'Your fav games are saved',
        style: TextStyle(fontSize: 12),
      ),
      layoutOrientation: ToastOrientation.ltr,
      animationType: AnimationType.fromLeft,
      dismissable: true,
    );
    toast.show(context);
  }
}

// ignore: must_be_immutable
class CustomGrid extends StatefulWidget {
  dynamic items;
  CustomGrid({super.key, required this.items});
  @override
  _CustomGrid createState() => _CustomGrid();
}

class _CustomGrid extends State<CustomGrid>
    with SingleTickerProviderStateMixin {
  //late List<dynamic> ownedgames;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: widget.items?.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Number of cards in a row
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemBuilder: (context, index) {
        if (widget.items != null) {
          return CustomCard(
            game: widget.items[index],
            onChecked: () {
              setState(() {
                if (widget.items[index]['selected']) {
                  //debugPrint(widget.items[index]['selected'].toString());
                  widget.items[index]['selected'] = false;
                  //debugPrint(widget.items[index]['selected'].toString());
                } else {
                  //debugPrint(widget.items[index]['selected'].toString());
                  widget.items[index]['selected'] = true;
                  //debugPrint(widget.items[index]['selected'].toString());
                }
              });
            },
          );
        }
        return null;
      },
    );
  }
}

class CustomCard extends StatelessWidget {
  final dynamic game;
  final Function onChecked;

  const CustomCard({Key? key, required this.game, required this.onChecked})
      : super(key: key);

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
              placeholder: (context, url) => const Center(
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: ColorfulCircularProgressIndicator(
                    colors: [
                      Colors.blue,
                      Colors.red,
                      Colors.amber,
                      Colors.green
                    ],
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
          Positioned(
            bottom: 65,
            left: 65,
            child: Checkbox(
              side: game['selected']
                  ? null
                  : const BorderSide(
                      color: Color.fromARGB(255, 255, 17, 0), width: 2.0),
              activeColor: Colors.green,
              value: game['selected'],
              onChanged: (value) {
                onChecked();
              },
            ),
          ),
        ]),
      ),
    );
  }
}
