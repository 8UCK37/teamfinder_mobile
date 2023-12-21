import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// ignore: unused_import
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/pojos/post_pojo.dart';
import 'package:teamfinder_mobile/utils/language_chip_helper.dart';
import 'package:teamfinder_mobile/widgets/create_post_bottomsheet.dart';
import 'package:teamfinder_mobile/widgets/post_widget.dart';
import '../pages/edit_profileinfo_page..dart';
import '../services/data_service.dart';
import '../widgets/separator_widget.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> with TickerProviderStateMixin {
  List<PostPojo>? postList;
  dynamic twitchData;
  dynamic discordData;

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
    final userService = Provider.of<ProviderService>(context, listen: false);
    userService.reloadUser(context);
    userService.getOwnPost();
  }

  String convertlistTolangString(Map<String, dynamic> userInfo) {
    String selectedLangString = '';
    if (userInfo['Language'] != null) {
      for (String index in userInfo['Language'].split(",")) {
        if (selectedLangString.isEmpty) {
          selectedLangString = Language.values[int.parse(index) - 1].label;
        } else {
          selectedLangString =
              "$selectedLangString, ${Language.values[int.parse(index) - 1].label}";
        }
      }
    }
    return selectedLangString;
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<ProviderService>(context, listen: true);
    final userData = userService.user;
    postList = userService.ownPosts;
    twitchData = userService.twitchData;
    discordData = userService.discordData;
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: Scaffold(
        floatingActionButton: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const CreatePost(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));

                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              ),
            );
          },
          child: const Material(
            elevation: 20,
            shape: CircleBorder(),
            child: ClipOval(
              child: CircleAvatar(
                backgroundColor: Colors.deepPurpleAccent,
                radius: 25,
                child: Icon(
                  Icons.post_add,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height:
                          200.0, // Set the desired fixed height for the banner
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0),
                        ),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            cacheKey:userService.bannerImagecacheKey,
                            userData['profileBanner'] ?? ''),
                          fit: BoxFit
                              .cover, // Set the fit property to determine how the image should be fitted
                        ),
                      ),
                    ),
                    //const SizedBox(height: 20.0),
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0, top: 150),
                            child: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                  cacheKey:userService.profileImagecacheKey,
                                  userData['profilePicture'] ?? ''),
                              radius: 50.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 200, left: 10),
                          // ignore: sized_box_for_whitespace
                          child: Container(
                            //decoration: BoxDecoration(border: Border.all(color: Colors.green)),
                            width: MediaQuery.of(context).size.width - 120,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(userData['name'] ?? 'person doe',
                                        style: const TextStyle(
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.bold)),
                                    Text(userData['bio'] ?? 'No Bio Given',
                                        softWrap: true,
                                        style: const TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.normal))
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/images/icons8_share.png",
                                      scale: 3.5,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const Divider(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: <Widget>[
                              Image.asset(
                                "assets/images/icons8_location.png",
                                scale: 3.5,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: Text(
                                    userData['userInfo']?['Country'] ??
                                        'No Info Given',
                                    style: const TextStyle(fontSize: 16.0)),
                              )
                            ],
                          ),
                          const SizedBox(width: 15.0),
                          Row(
                            children: <Widget>[
                              // const Icon(Icons.record_voice_over,
                              //     color: Colors.blue, size: 30.0),
                              Image.asset(
                                "assets/images/speaking_right.png",
                                scale: 3.5,
                              ),

                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: Text(
                                    userData['userInfo'] != null
                                        ? convertlistTolangString(
                                            userData['userInfo'])
                                        : 'no internet',
                                    style: const TextStyle(fontSize: 16.0)),
                              )
                            ],
                          ),
                          const SizedBox(width: 15.0),
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => const EditProfileInfo()),
                          // );
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const EditProfileInfo(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(0.0, 1.0);
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;

                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));

                                var offsetAnimation = animation.drive(tween);

                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        child: Container(
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: Colors.deepPurpleAccent.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: const Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.edit, color: Colors.deepPurpleAccent),
                              Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text('Edit Profile',
                                    style: TextStyle(
                                        color: Colors.deepPurpleAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0)),
                              ),
                            ],
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(thickness: 1.0, height: 15),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              const Text('Linked accounts',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Color.fromARGB(255, 60, 159, 209))),
                              const SizedBox(height: 6.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      child: Icon(
                                        FontAwesomeIcons.steam,
                                        color: userData['steamId'] != null
                                            ? const Color.fromRGBO(
                                                29, 92, 234, 85)
                                            : Colors.black,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: SizedBox(
                                        child: Icon(
                                          FontAwesomeIcons.twitch,
                                          color: twitchData!= null && twitchData != "not logged in" 
                                              ? const Color.fromRGBO(
                                                  145, 70, 250, 100)
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: SizedBox(
                                          child: Icon(
                                        FontAwesomeIcons.discord,
                                        color: discordData != null
                                            ? const Color.fromARGB(
                                                255, 114, 137, 218)
                                            : Colors.black,
                                      )),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 45.0),
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.only(left: 15.0),
                              child: Text('Your wall',
                                  style: TextStyle(
                                      fontSize: 22.0,
                                      color: Colors.cyan,
                                      fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 6.0),
                            if (postList != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Text(
                                    'You have ${postList!.length.toString()} posts',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: userService.darkTheme!
                                            ? Colors.white
                                            : Colors.grey[800])),
                              ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(
                      height: 20,
                    ),
                    const SizedBox(height: 25),
                    if (postList != null) // Add a null check here
                      for (PostPojo post
                          in postList!) // Add a null check here i sound like cypher 'a trip here,this goes there' lol
                        Column(
                          children: <Widget>[
                            //const SeparatorWidget(),
                            PostWidget(
                              post: post,
                            ),
                            SeparatorWidget(
                                color: userService.darkTheme!
                                    ? const Color.fromARGB(255, 74, 74, 74)
                                    : Colors.grey[800]),
                          ],
                        ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
