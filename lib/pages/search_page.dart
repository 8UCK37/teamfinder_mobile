import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:teamfinder_mobile/chat_ui/chat_home.dart';
import 'package:teamfinder_mobile/friend_profile_ui/friend_profilehome.dart';
import 'package:teamfinder_mobile/pojos/user_pojo.dart';
import 'package:teamfinder_mobile/widgets/search_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _textController = TextEditingController();
  late List<UserPojo>? userList = [];
  String? userInp;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void searchUser() async {
    Dio dio = Dio();
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user!.getIdToken();
    // ignore: prefer_is_empty
    if (userInp?.length == 0) {
      setState(() {
        userList = [];
      });
      return;
    }
    debugPrint('from search userinp: $userInp');
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    var response = await dio.post(
      'http://${dotenv.env['server_url']}/searchFriend',
      data: {'searchTerm': userInp},
      options: options,
    );
    if (response.statusCode == 200) {
      debugPrint('user data searched');
      //debugPrint(response.data);
      setState(() {
        userList = userPojoListFromJson(response.data).where((userPojo) => userPojo.id != user.uid).toList();
      });
      debugPrint(userList.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Row(
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
                          debugPrint('goto chat');
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChatHome()),
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
          backgroundColor: Colors.white,
          elevation: 0.0,
          //systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, 1],
              colors: [
                Colors.deepPurple,
                Color.fromARGB(255, 185, 162, 162),
              ],
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.8),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: CustomSearchBar(
                          autoOpenOnInit: true,
                          textEditingController: _textController,
                          isOriginalAnimation: true,
                          enableKeyboardFocus: true,
                          durationInMilliSeconds: 450,
                          onChanged: (String typedTxt) {
                            debugPrint(typedTxt);
                            setState(() {
                              userInp = typedTxt;
                              searchUser();
                            });
                          },
                          onExpansionComplete: () {
                            debugPrint(
                                'do something just after searchbox is opened.');
                          },
                          onCollapseComplete: () {
                            debugPrint(
                                'do something just after searchbox is closed.');
                          },
                          onPressButton: (isSearchBarOpens) {
                            debugPrint(
                                'do something before animation started. It\'s the ${isSearchBarOpens ? 'opening' : 'closing'} animation');
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
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: ListView.builder(
                itemCount: userList?.length,
                itemBuilder: (context, i) => Column(
                  children: <Widget>[
                    const Divider(
                      height: 22.0,
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        maxRadius: 25,
                        backgroundImage:
                            NetworkImage(userList![i].profilePicture),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            userList![i].name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      onTap: () {
                        var route = MaterialPageRoute(
                            builder: (BuildContext context) =>
                                FriendProfileHome(
                                  friendId: userList![i].id,
                                  friendName: userList![i].name,
                                  friendProfileImage:
                                      userList![i].profilePicture,
                                ));
                        Navigator.of(context).push(route);
                      },
                    ),
                  ],
                ),
              ))
            ],
          ),
        ));
  }
}
