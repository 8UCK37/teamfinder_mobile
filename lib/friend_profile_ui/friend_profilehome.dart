import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/chat_ui/chat_home.dart';
import 'package:teamfinder_mobile/friend_profile_ui/friend_freindList.dart';
import 'package:teamfinder_mobile/friend_profile_ui/friend_linkedAcc.dart';
import 'package:teamfinder_mobile/friend_profile_ui/friend_posts.dart';
import 'package:teamfinder_mobile/friend_profile_ui/friend_games_showcase.dart';
import 'package:teamfinder_mobile/pages/search_page.dart';
import 'package:teamfinder_mobile/services/friend_profile_service.dart';

class FriendProfileHome extends StatefulWidget {
  final String? friendName;
  final String friendId;
  final String? friendProfileImage;

  const FriendProfileHome({
    super.key,
    required this.friendId,
    this.friendName,
    this.friendProfileImage,
  });

  @override
  State<FriendProfileHome> createState() => _FriendProfileHomeState();
}

class _FriendProfileHomeState extends State<FriendProfileHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    getFriendPosts();
    getFriendProfileData();
    getFriendTwitchInfo();
    getFriendDiscordInfo();
    _tabController = TabController(vsync: this, length: 4);
    if (mounted) {
      _tabController.addListener(() {
        setState(() {
          // Update the selected index of GNav when the tabs change
          _tabController.index = _tabController.index;
        });
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> getFriendProfileData() async {
    final profileService =
        Provider.of<FriendProfileService>(context, listen: false);
    profileService.getFriendProfileData(widget.friendId.toString());
  }

  Future<void> getFriendPosts() async {
    final profileService =
        Provider.of<FriendProfileService>(context, listen: false);
    profileService.getFriendsPosts(widget.friendId.toString());
  }

  Future<void> getFriendTwitchInfo() async {
    final profileService =
        Provider.of<FriendProfileService>(context, listen: false);
    profileService.getTwitchInfo(widget.friendId.toString());
  }

  Future<void> getFriendDiscordInfo() async {
    final profileService =
        Provider.of<FriendProfileService>(context, listen: false);
    profileService.getDiscordInfo(widget.friendId.toString());
  }

  @override
  Widget build(BuildContext context) {
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
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
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
                    child:
                        Icon(Icons.question_answer, color: Colors.deepPurple),
                  ),
                ),
              ]),
            ]),
        backgroundColor: Colors.white,
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      bottomNavigationBar: SizedBox(
        height: 75,
        child: GNav(
            selectedIndex: _tabController.index,
            duration: const Duration(milliseconds: 250),
            gap: 5,
            tabs: [
              GButton(
                onPressed: () {
                  _tabController.animateTo(0);
                },
                icon: Icons.receipt_long,
                text: 'Posts',
                textColor: Colors.deepPurple,
                iconActiveColor: Colors.deepPurple,
              ),
              GButton(
                onPressed: () {
                  _tabController.animateTo(1);
                },
                icon: Icons.sports_esports,
                text: 'Games',
                textColor: Colors.deepOrange,
                iconActiveColor: Colors.deepOrange,
              ),
              GButton(
                onPressed: () {
                  _tabController.animateTo(2);
                },
                icon: Icons.link,
                text: 'Linked Acc',
                textColor: Colors.blue,
                iconActiveColor: Colors.blue,
              ),
              GButton(
                onPressed: () {
                  _tabController.animateTo(3);
                },
                icon: Icons.people_outline,
                text: 'Friends',
                textColor: const Color.fromARGB(255, 152, 129, 14),
                iconActiveColor: const Color.fromARGB(255, 152, 129, 14),
              ),
            ]),
      ),
      body: TabBarView(controller: _tabController, children: [
        FriendProfilePosts(
          friendId: widget.friendId,
          friendName: widget.friendName,
          friendProfileImage: widget.friendProfileImage,
        ),
        FriendGamesShowCase(
          friendId: widget.friendId,
          friendName: widget.friendName,
          friendProfileImage: widget.friendProfileImage,
        ),
        const FriendLinkedAcc(),
        const FriendsFriendList()
      ]),
    );
  }
}
