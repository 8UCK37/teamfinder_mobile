import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:teamfinder_mobile/pojos/post_pojo.dart';
import 'package:teamfinder_mobile/pojos/user_pojo.dart';
import 'package:teamfinder_mobile/widgets/post_widget.dart';
import '../widgets/separator_widget.dart';

class FriendProfilePosts extends StatefulWidget {
  final String? friendName;
  final String friendId;
  final String? friendProfileImage;

  const FriendProfilePosts({
    super.key,
    required this.friendId,
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
  final GlobalKey _linkedAccWidgetKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    getProfileData();
    getFriendsPosts();
  }

  @override
  void dispose() {
    // Unsubscribe the listener to avoid memory leaks
    _scrollController.dispose();
    super.dispose();
  }

  void scrollToWidget(GlobalKey key) {
    // Determine the target widget's position
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    final targetOffset = renderBox.localToGlobal(Offset.zero);

    // Check if the target widget is already visible within the viewport
    final double targetY = targetOffset.dy;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double scrollPosition = _scrollController.offset;
    final double maxScrollPosition = _scrollController.position.maxScrollExtent;

    if (targetY >= scrollPosition &&
        targetY < (scrollPosition + screenHeight)) {
      // The target widget is already visible, so no need to scroll
      return;
    }

    // Ensure the target position is within the bounds of the scrollable content
    final double targetScrollOffset = targetY > maxScrollPosition
        ? maxScrollPosition
        : targetY < 0
            ? 0
            : targetY;

    // Scroll to the target widget
    _scrollController.animateTo(
      targetScrollOffset,
      duration: const Duration(milliseconds: 500), // Animation duration
      curve: Curves.easeInOut, // Animation curve
    );
  }

  Future<void> getProfileData() async {
    Dio dio = Dio();
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user!.getIdToken();
    debugPrint(widget.friendId.toString());
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    var response = await dio.post(
      'http://${dotenv.env['server_url']}/getUserInfo',
      data: {'id': widget.friendId},
      options: options,
    );
    if (response.statusCode == 200) {
      debugPrint('friend data fetched');
      //debugPrint(response.data);
      setState(() {
        friendProfile = userPojoListFromJson(response.data)[0];
      });
      debugPrint(friendProfile.toString());
    }
  }

  Future<void> getFriendsPosts() async {
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
      'http://${dotenv.env['server_url']}/getPostById',
      data: {'uid': widget.friendId.toString()},
      options: options,
    );
    if (response.statusCode == 200) {
      List<PostPojo> parsedPosts = postPojoFromJson(response.data);
      setState(() {
        postList =
            parsedPosts; // Update the state variable with the parsed list
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (friendProfile == null) {
      return Container();
    } else {
      return Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                  controller: _scrollController,
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
                                    friendProfile!.profileBanner),
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
                                  padding: const EdgeInsets.only(
                                      left: 5.0, top: 150),
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        friendProfile!.profilePicture),
                                    radius: 50.0,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 185, left: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(friendProfile!.name,
                                        style: const TextStyle(
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.bold)),
                                  ],
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: <Widget>[
                                    const Icon(Icons.person_pin_circle,
                                        color: Colors.green, size: 32.0),
                                    const SizedBox(width: 10.0),
                                    Text('${friendProfile!.userInfo!.country}',
                                        style: const TextStyle(fontSize: 16.0))
                                  ],
                                ),
                                const SizedBox(height: 15.0),
                                Row(
                                  children: <Widget>[
                                    const Icon(Icons.record_voice_over,
                                        color: Colors.blue, size: 30.0),
                                    const SizedBox(width: 10.0),
                                    Text('${friendProfile!.userInfo!.language}',
                                        style: const TextStyle(fontSize: 16.0))
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 15.0),
                            Row(
                              children: <Widget>[
                                const Icon(Icons.more_horiz,
                                    color: Colors.grey, size: 30.0),
                                const SizedBox(width: 10.0),
                                Text("See ${friendProfile!.name}'s About Info",
                                    style: const TextStyle(fontSize: 16.0))
                              ],
                            ),
                            const SizedBox(height: 15.0),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 0.0,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  key: _linkedAccWidgetKey,
                                  children: const <Widget>[
                                    Text('Linked accounts',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 60, 159, 209))),
                                    SizedBox(height: 6.0),
                                    Padding(
                                      padding: EdgeInsets.only(left: 15.0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            child: Icon(FontAwesomeIcons.steam),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 15.0),
                                            child: SizedBox(
                                              child:
                                                  Icon(FontAwesomeIcons.twitch),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 15.0),
                                            child: SizedBox(
                                              child: Icon(
                                                  FontAwesomeIcons.discord),
                                            ),
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
                      const Divider(height: 40.0),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("${friendProfile!.name}'s wall",
                                        style: const TextStyle(
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 6.0),
                                    if (postList != null)
                                      Text(
                                          "${friendProfile!.name.split(' ')[0]} has ${postList!.length.toString()} posts",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.grey[800])),
                                  ],
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
                                    const SeparatorWidget(),
                                    PostWidget(post: post),
                                  ],
                                ),
                          ],
                        ),
                      ),
                      const SeparatorWidget(),
                    ],
                  )),
            ),
          ],
        ),
      );
    }
  }
}
