import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teamfinder_mobile/chat_ui/chat_home.dart';
import 'package:teamfinder_mobile/pages/search_page.dart';
import 'package:teamfinder_mobile/pojos/post_pojo.dart';
import 'package:teamfinder_mobile/pojos/user_pojo.dart';
import 'package:teamfinder_mobile/widgets/post_widget.dart';
import '../widgets/separator_widget.dart';

class FriendProfilePage extends StatefulWidget {
  final String friendName;
  final String friendId;
  final String friendProfileImage;

  const FriendProfilePage({
    super.key,
    required this.friendId,
    required this.friendName,
    required this.friendProfileImage,
  });
  @override
  // ignore: library_private_types_in_public_api
  _FriendProfilePageState createState() => _FriendProfilePageState();
}

class _FriendProfilePageState extends State<FriendProfilePage>
    with TickerProviderStateMixin {
  List<PostPojo>? postList;
  UserPojo? friendProfile;
  @override
  void initState() {
    super.initState();
    getProfileData();
    getFriendsPosts();
  }

  @override
  void dispose() {
    // Unsubscribe the listener to avoid memory leaks
    super.dispose();
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
        postList =parsedPosts; // Update the state variable with the parsed list
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (friendProfile == null){
      return Container();
      }
    else {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
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
                            MaterialPageRoute(builder: (context) => ChatHome()),
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
          backgroundColor: Colors.white,
          elevation: 0.0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      CachedNetworkImage(
                          imageUrl: friendProfile!.profileBanner,
                          placeholder: (contex, url) => Shimmer.fromColors(
                                baseColor: Colors.purpleAccent,
                                highlightColor: Colors.white,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0.0),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(8.0),
                                      bottomRight: Radius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ),
                          errorWidget: (context, url, error) =>
                              Image.asset('assets/images/error-404.png')),
                      //const SizedBox(height: 20.0),
                      Row(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 5.0, top: 200),
                              child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(friendProfile!.profilePicture),
                                radius: 50.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 255, left: 10),
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
                          children: <Widget>[
                            const Icon(Icons.home,
                                color: Colors.grey, size: 30.0),
                            const SizedBox(width: 10.0),
                            Text('Lives in ${friendProfile!.userInfo!.country}',
                                style: const TextStyle(fontSize: 16.0))
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        Row(
                          children: <Widget>[
                            const Icon(Icons.record_voice_over,
                                color: Colors.grey, size: 30.0),
                            const SizedBox(width: 10.0),
                            Text('Speaks ${friendProfile!.userInfo!.language}',
                                style: const TextStyle(fontSize: 16.0))
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        const Row(
                          children: <Widget>[
                            Icon(Icons.more_horiz,
                                color: Colors.grey, size: 30.0),
                            SizedBox(width: 10.0),
                            Text('See your About Info',
                                style: TextStyle(fontSize: 16.0))
                          ],
                        ),
                        const SizedBox(height: 15.0),
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
                                    style:const TextStyle(
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
            const GNav(gap: 8, tabs: [
              GButton(
                icon: Icons.receipt_long,
                text: 'Posts',
                textColor: Colors.deepPurple,
              ),
              GButton(
                icon: Icons.sports_esports,
                text: 'Games',
                textColor: Colors.deepOrange,
              ),
              GButton(
                icon: Icons.link,
                text: 'Linked Acc',
                textColor: Colors.blue,
              ),
            ]),
          ],
        ),
      );
    }
  }
}
