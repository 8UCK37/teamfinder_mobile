import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/pojos/post_pojo.dart';
import 'package:teamfinder_mobile/widgets/post_widget.dart';
import '../services/user_service.dart';
import '../widgets/separator_widget.dart';

class ProfileTab extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> with TickerProviderStateMixin {
  List<PostPojo>? postList;
  @override
  void initState() {
    super.initState();
    getOwnPost();
  }

  @override
  void dispose() {
    // Unsubscribe the listener to avoid memory leaks
    super.dispose();
  }

  Future<void> getOwnPost() async {
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
      data: {'uid': user.uid.toString()},
      options: options,
    );
    if (response.statusCode == 200) {
      List<PostPojo> parsedPosts = postPojoFromJson(response.data);
      setState(() {
        postList = parsedPosts; // Update the state variable with the parsed list
      });
      
    }
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final userData = userService.user;
    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
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
                            userData['profileBanner']),
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
                            backgroundImage:
                                NetworkImage(userData['profilePicture']),
                            radius: 50.0,
                          ),
                        ),
                      ),
                      Padding(            
                        padding: const EdgeInsets.only(top: 185, left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(userData['name'],
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
                        const Icon(Icons.home, color: Colors.grey, size: 30.0),
                        const SizedBox(width: 10.0),
                        Text('Lives in ${userData['userInfo']['Country']}',
                            style: const TextStyle(fontSize: 16.0))
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    Row(
                      children: <Widget>[
                        const Icon(Icons.record_voice_over,
                            color: Colors.grey, size: 30.0),
                        const SizedBox(width: 10.0),
                        Text('Speaks ${userData['userInfo']['Language']}',
                            style: const TextStyle(fontSize: 16.0))
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    const Row(
                      children: <Widget>[
                        Icon(Icons.more_horiz, color: Colors.grey, size: 30.0),
                        SizedBox(width: 10.0),
                        Text('See your About Info',
                            style: TextStyle(fontSize: 16.0))
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: const Center(
                          child: Text('Edit Profile',
                              style: TextStyle(
                                  color: Colors.deepPurpleAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0))),
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
                            const Text('Your wall',
                                style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6.0),
                            if (postList != null)
                              Text(
                                  'You have ${postList!.length.toString()} posts',
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.grey[800])),
                          ],
                        ),
                        // const Text('Find Friends',
                        //     style:
                        //         TextStyle(fontSize: 16.0, color: Colors.blue)),
                        const CircleAvatar(
                          backgroundColor: Colors.deepPurpleAccent,
                          radius: 25,
                          child: Icon(
                            Icons.post_add,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    if (postList != null) // Add a null check here
                      for (PostPojo post in postList!) // Add a null check here i sound like cypher 'a trip here,this goes there' lol
                        Column(
                          children: <Widget>[
                            const SeparatorWidget(),
                            PostWidget(post: post),
                          ],
                        ),
                      const SeparatorWidget(),
                  ],
                ),
              ),
            ],
          )),
        ),
      //   const GNav(gap: 8, tabs: [
      //     GButton(
      //       icon: Icons.receipt_long,
      //       text: 'Posts',
      //       textColor: Colors.deepPurple,
      //     ),
      //     GButton(
      //       icon: Icons.sports_esports,
      //       text: 'Games',
      //       textColor: Colors.deepOrange,
      //     ),
      //     GButton(
      //       icon: Icons.link,
      //       text: 'Linked Acc',
      //       textColor: Colors.blue,
      //     ),
      //   ]
      //  ),
      ],
    );
  }
}
