import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/pojos/post_pojo.dart';
import 'package:teamfinder_mobile/pojos/user_pojo.dart';
import 'package:teamfinder_mobile/services/data_service.dart';
import 'package:teamfinder_mobile/services/friend_profile_service.dart';
import 'package:teamfinder_mobile/widgets/post_widgets/post_widget.dart';
import '../utils/language_chip_helper.dart';
import '../widgets/misc/separator_widget.dart';

class FriendProfilePosts extends StatefulWidget {
  final String? friendName;
  final String friendId;
  final String? friendProfileImage;
  final String? friendStatus;

  const FriendProfilePosts({
    super.key,
    required this.friendId,
    required this.friendStatus,
    this.friendName,
    this.friendProfileImage,
  });
  @override
  // ignore: library_private_types_in_public_api
  _FriendProfilePostsState createState() => _FriendProfilePostsState();
}

class _FriendProfilePostsState extends State<FriendProfilePosts>
    with TickerProviderStateMixin {
  List<PostPojo>? postList;
  UserPojo? friendProfile;
  final ScrollController _scrollController = ScrollController();
  dynamic twitchData;
  dynamic discordData;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    // Unsubscribe the listener to avoid memory leaks
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    final profileService =
        Provider.of<FriendProfileService>(context, listen: false);
    profileService.getFriendProfileData(widget.friendId.toString());
    profileService.getFriendsPosts(widget.friendId.toString());
    profileService.getTwitchInfo(widget.friendId.toString());
    profileService.getDiscordInfo(widget.friendId.toString());
  }

  Widget statusDependentwidget() {
    final profileService =
        Provider.of<FriendProfileService>(context, listen: true);
    if (profileService.friendStatus == 'accepted') {
      return const Padding(
        padding: EdgeInsets.all(10),
        child: CircleAvatar(
          backgroundColor: Colors.deepPurpleAccent,
          radius: 15,
          backgroundImage: AssetImage("assets/images/help.png"),
        ),
      );
    } else if (profileService.friendStatus == 'pending') {
      _animationController.forward();
      return FadeTransition(
        opacity: _fadeAnimation,
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.amberAccent,
                radius: 15,
                backgroundImage: AssetImage("assets/images/hourglass.png"),
              ),
            ],
          ),
        ),
      );
    } else {
      return GestureDetector(
          onTap: () {
            debugPrint(
                "send request to ${widget.friendName} with id ${widget.friendId}");
            // profileService.updateFriendStatus("pending");
            profileService.sendRequest(widget.friendId);
            MotionToast(
              icon: Icons.rocket_launch,
              primaryColor: Colors.purple,
              displaySideBar: false,
              displayBorder: true,
              title: const Text(
                'Success!!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              description: const Text(
                'Friend Request sent',
              ),
            ).show(context);
          },
          child: const Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(
              Icons.person_add,
              color: Colors.blue,
              size: 30,
            ),
          ));
    }
  }
  

  String convertlistTolangString(UserInfo userInfo) {
    String selectedLangString = '';
    if (userInfo.language != null) {
      for (String index in userInfo.language!.split(",")) {
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
    final profileService =
        Provider.of<FriendProfileService>(context, listen: true);
    final userService = Provider.of<ProviderService>(context, listen: true);
    postList = profileService.friendPostList;
    friendProfile = profileService.friendProfile;
    twitchData = profileService.twitchData;
    discordData = profileService.discordData;
    if (friendProfile == null) {
      return Container();
    } else {
      return RefreshIndicator(
        onRefresh: _handleRefresh,
        child: Scaffold(
          body: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Column(
                        children: [
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
                                    friendProfile!.profileBanner),
                                fit: BoxFit
                                    .cover, // Set the fit property to determine how the image should be fitted
                              ),
                            ),
                          ),
                          SafeArea(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, left: 110),
                                  child: SizedBox(
                                    width: 167,
                                    child: Text(friendProfile!.name,
                                        style: const TextStyle(
                                            overflow: TextOverflow.clip,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                statusDependentwidget(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      //const SizedBox(height: 20.0),
                      Row(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 5.0, top: 150),
                              child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(friendProfile!.profilePicture),
                                radius: 50.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(
                      color: userService.darkTheme!
                          ? const Color.fromARGB(255, 74, 74, 74)
                          : Colors.grey),
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
                                const SizedBox(width: 10.0),
                                Text('${friendProfile!.userInfo!.country}',
                                    style: const TextStyle(fontSize: 16.0))
                              ],
                            ),
                            const SizedBox(width: 15.0),
                            Row(
                              children: <Widget>[
                                Image.asset(
                                  "assets/images/speaking_right.png",
                                  scale: 3.5,
                                ),
                                const SizedBox(width: 10.0),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  child: Container(
                                    constraints:
                                        const BoxConstraints(maxWidth: 248),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        friendProfile!.userInfo != null
                                            ? convertlistTolangString(
                                                friendProfile!.userInfo!)
                                            : 'no language preference set',
                                        style: const TextStyle(
                                            color:
                                                Color.fromARGB(255, 3, 67, 120),
                                            fontSize: 16.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        ExpansionTile(
                          title: Text("See ${friendProfile!.name}'s About Info",
                                style: const TextStyle(fontSize: 16.0)),
                          leading:const Icon(Icons.psychology_alt),
                          trailing: const Icon(
                            color: Colors.blue,
                            Icons.expand_more,
                          ),
                          childrenPadding: const EdgeInsets.only(left: 25),
                          children: const [
                            ListTile(
                              title: Text("There's really nothing to show here"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: userService.darkTheme!
                        ? const Color.fromARGB(255, 74, 74, 74)
                        : Colors.grey,
                    height: 0.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Linked accounts',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 60, 159, 209),
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        Row(
                          children: [
                            Visibility(
                              visible: friendProfile?.steamId != null,
                              child: Image.asset(
                                'assets/images/icons8_steam_48.png', // Replace with your PNG image asset path
                                width: 32,
                                height: 32,
                              ),
                            ),
                            Visibility(
                              visible: friendProfile?.steamId == null,
                              child: const Icon(
                                  color: Color.fromARGB(255, 81, 80, 80),
                                  FontAwesomeIcons.steam),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: SizedBox(
                                child: Icon(
                                  FontAwesomeIcons.twitch,
                                  color: twitchData != "not logged in"
                                      ? const Color.fromRGBO(145, 70, 250, 100)
                                      : const Color.fromARGB(
                                            255, 81, 80, 80),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: SizedBox(
                                child: Icon(
                                  FontAwesomeIcons.discord,
                                  color: discordData != null
                                      ? const Color.fromRGBO(114, 137, 218, 1)
                                      : const Color.fromARGB(
                                            255, 81, 80, 80),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Divider(
                      color: userService.darkTheme!
                          ? const Color.fromARGB(255, 74, 74, 74)
                          : Colors.grey,
                      height: 40.0),
                  // ignore: avoid_unnecessary_containers
                  Container(
                    //padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "${friendProfile!.name}'s wall",
                                    style: const TextStyle(
                                        color: Colors.teal,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 6.0),
                                  if (postList != null)
                                    Padding(
                                      padding: const EdgeInsets.only(left:3),
                                      child: RichText(
                                        text: TextSpan(
                                            style: TextStyle(
                                              color: userService.darkTheme!? Colors.white:Colors.black,
                                              fontSize: 16.0,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: "${friendProfile!.name.split(' ')[0]} has ",
                                              ),
                                              TextSpan(
                                                text: postList!.length.toString(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green,
                                                ),
                                              ),
                                              const TextSpan(
                                                text: " posts",
                                              )
                                            ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            // const Text('Find Friends',
                            //     style:
                            //         TextStyle(fontSize: 16.0, color: Colors.blue)),
                          ],
                        ),
                        const SizedBox(height: 25),
                        if (postList != null) // Add a null check here
                          for (PostPojo post
                              in postList!) // Add a null check here i sound like cypher 'a trip here,this goes there' lol
                            Column(
                              children: <Widget>[
                                SeparatorWidget(
                                    color: userService.darkTheme!
                                        ? const Color.fromARGB(255, 74, 74, 74)
                                        : const Color.fromARGB(
                                            255, 182, 182, 182)),
                                PostWidget(post: post),
                              ],
                            ),
                      ],
                    ),
                  ),
                  SeparatorWidget(),
                ],
              )),
        ),
      );
    }
  }
}
