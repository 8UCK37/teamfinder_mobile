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
import 'package:teamfinder_mobile/services/data_service.dart';
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
  late PageController _pageController;
  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    getFriendPosts();
    getFriendProfileData();
    getFriendTwitchInfo();
    getFriendDiscordInfo();
  }

  @override
  void dispose() {
    _pageController.dispose();
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
    final userService = Provider.of<ProviderService>(context,listen:true);
    return Theme(
      data: userService.darkTheme ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor:userService.darkTheme ? const Color.fromRGBO(46, 46, 46, 100): Colors.white,
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
                        backgroundColor: Color.fromRGBO(222, 209, 242, 100),
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
                      backgroundColor: Color.fromRGBO(222, 209, 242, 100),
                      child:
                          Icon(Icons.question_answer, color: Colors.deepPurple),
                    ),
                  ),
                ]),
              ]),
          elevation: 0.0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        bottomNavigationBar: SizedBox(
          height: 75,
          child: GNav(
              selectedIndex: selectedIndex,
              onTabChange: (value) {
                if(mounted){
                  setState(() {
                  selectedIndex = value;
                });
                }
              },
              //duration: const Duration(milliseconds: 150),
              gap: 5,
              tabs: [
                GButton(
                  onPressed: () {
                    //_tabController.animateTo(0);
                    _pageController.animateToPage(
                      0,
                      duration: const Duration(
                          milliseconds: 150), // Set the duration of the animation
                      curve: Curves.easeInCubic, // Set the easing curve for the animation
                    );
                  },
                  icon: Icons.receipt_long,
                  text: 'Posts',
                  iconColor:userService.darkTheme ?  Colors.grey: Colors.white,
                  textColor: Colors.deepPurple,
                  iconActiveColor: Colors.deepPurple,
                ),
                GButton(
                  onPressed: () {
                    //_tabController.animateTo(1);
                    _pageController.animateToPage(
                      1,
                      duration: const Duration(
                          milliseconds: 150), // Set the duration of the animation
                      curve: Curves.easeInCubic, // Set the easing curve for the animation
                    );
                  },
                  icon: Icons.sports_esports,
                  text: 'Games',
                  iconColor:userService.darkTheme ?  Colors.grey: Colors.white,
                  textColor: Colors.deepOrange,
                  iconActiveColor: Colors.deepOrange,
                ),
                GButton(
                  onPressed: () {
                    //_tabController.animateTo(2);
                    _pageController.animateToPage(
                      2,
                      duration: const Duration(
                          milliseconds: 150), // Set the duration of the animation
                      curve: Curves.easeInCubic, // Set the easing curve for the animation
                    );
                  },
                  icon: Icons.link,
                  text: 'Linked Acc',
                  iconColor:userService.darkTheme ?  Colors.grey: Colors.white,
                  textColor: Colors.blue,
                  iconActiveColor: Colors.blue,
                ),
                GButton(
                  onPressed: () {
                    //_tabController.animateTo(3);
                    _pageController.animateToPage(
                      3,
                      duration: const Duration(
                          milliseconds: 150), // Set the duration of the animation
                      curve: Curves.easeInCubic, // Set the easing curve for the animation
                    );
                  },
                  icon: Icons.people_outline,
                  text: 'Friends',
                  iconColor:userService.darkTheme ?  Colors.grey: Colors.white,
                  textColor: const Color.fromARGB(255, 152, 129, 14),
                  iconActiveColor: const Color.fromARGB(255, 152, 129, 14),
                ),
              ]),
        ),
        body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              if(mounted){
                setState(() => selectedIndex = index);
              }
            },
            children: [
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
      ),
    );
  }
}
