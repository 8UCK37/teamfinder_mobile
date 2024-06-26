import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/friend_profile_ui/friend_friendList.dart';
import 'package:teamfinder_mobile/friend_profile_ui/friend_linkedAcc.dart';
import 'package:teamfinder_mobile/friend_profile_ui/friend_posts.dart';
import 'package:teamfinder_mobile/friend_profile_ui/friend_games_showcase.dart';
import 'package:teamfinder_mobile/services/data_service.dart';
import 'package:teamfinder_mobile/services/friend_profile_service.dart';
import '../widgets/misc/teamfinder_appbar.dart';

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
    with AutomaticKeepAliveClientMixin<FriendProfileHome> {

  late PageController _pageController;
  int selectedIndex = 0;


  @override
  bool get wantKeepAlive => true;

  
  @override
  void initState() {
    super.initState();
    erasePreviousProfile();
    _pageController = PageController();
    getFriendStatus();
    getFriendPosts();
    getFriendProfileData();
    getFriendTwitchInfo();
    getFriendDiscordInfo();
    getFriendShowcase();
    getFriendfriendList();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void erasePreviousProfile() {
    final profileService =
        Provider.of<FriendProfileService>(context, listen: false);
    profileService.erasePreviousProfile();
  }

  Future<void> getFriendStatus() async {
    final profileService =
        Provider.of<FriendProfileService>(context, listen: false);
    profileService.getFriendStatus(widget.friendId.toString());
  }

  Future<void> getFriendProfileData() async {
    final profileService =
        Provider.of<FriendProfileService>(context, listen: false);
    profileService.getFriendProfileData(widget.friendId.toString());
  }

  void getFriendPosts() {
    final profileService =
        Provider.of<FriendProfileService>(context, listen: false);
    profileService.getFriendsPosts(widget.friendId.toString());
  }

  Future<void> getFriendSteamInfo() async {
    final profileService =
        Provider.of<FriendProfileService>(context, listen: false);
    if (profileService.friendProfile?.steamId != null) {
      profileService.getSteamInfo(profileService.friendProfile!.steamId!);
    }
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

  Future<void> getFriendShowcase() async {
    final profileService =
        Provider.of<FriendProfileService>(context, listen: false);
    profileService.getShowCase(widget.friendId.toString());
  }

  Future<void> getFriendfriendList() async {
    final profileService =
        Provider.of<FriendProfileService>(context, listen: false);
    profileService.getFriendList(widget.friendId.toString());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final userService = Provider.of<ProviderService>(context, listen: true);
    final profileService =
        Provider.of<FriendProfileService>(context, listen: true);
    return Theme(
      data: userService.darkTheme! ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: TeamFinderAppBar(
          titleText: "${widget.friendName!.split(" ")[0]}'s Profile",
          isDark: userService.darkTheme!,
          implyLeading: true,
          height: 55,
          showNotificationCount: false,
          titleStyle: const TextStyle(
              color: Colors.deepPurple,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ),
        bottomNavigationBar: SizedBox(
          height: 75,
          child: GNav(
              selectedIndex: selectedIndex,
              onTabChange: (value) {
                if (mounted) {
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
                          milliseconds:
                              150), // Set the duration of the animation
                      curve: Curves
                          .easeInCubic, // Set the easing curve for the animation
                    );
                  },
                  icon: Icons.receipt_long,
                  text: 'Posts',
                  iconColor: userService.darkTheme!
                      ? Colors.grey
                      : const Color.fromARGB(255, 52, 52, 52),
                  textColor: Colors.deepPurple,
                  iconActiveColor: Colors.deepPurple,
                ),
                GButton(
                  onPressed: () {
                    //_tabController.animateTo(1);
                    _pageController.animateToPage(
                      1,
                      duration: const Duration(
                          milliseconds:
                              150), // Set the duration of the animation
                      curve: Curves
                          .easeInCubic, // Set the easing curve for the animation
                    );
                  },
                  icon: Icons.sports_esports,
                  text: 'Games',
                  iconColor: userService.darkTheme!
                      ? Colors.grey
                      : const Color.fromARGB(255, 52, 52, 52),
                  textColor: Colors.deepOrange,
                  iconActiveColor: Colors.deepOrange,
                ),
                GButton(
                  onPressed: () {
                    //_tabController.animateTo(2);
                    _pageController.animateToPage(
                      2,
                      duration: const Duration(
                          milliseconds:
                              150), // Set the duration of the animation
                      curve: Curves
                          .easeInCubic, // Set the easing curve for the animation
                    );
                  },
                  icon: Icons.link,
                  text: 'Linked Acc',
                  iconColor: userService.darkTheme!
                      ? Colors.grey
                      : const Color.fromARGB(255, 52, 52, 52),
                  textColor: Colors.blue,
                  iconActiveColor: Colors.blue,
                ),
                GButton(
                  onPressed: () {
                    //_tabController.animateTo(3);
                    _pageController.animateToPage(
                      3,
                      duration: const Duration(
                          milliseconds:
                              150), // Set the duration of the animation
                      curve: Curves
                          .easeInCubic, // Set the easing curve for the animation
                    );
                  },
                  icon: Icons.people_outline,
                  text: 'Friends',
                  iconColor: userService.darkTheme!
                      ? Colors.grey
                      : const Color.fromARGB(255, 52, 52, 52),
                  textColor: const Color.fromARGB(255, 152, 129, 14),
                  iconActiveColor: const Color.fromARGB(255, 152, 129, 14),
                ),
              ]),
        ),
        body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              if (mounted) {
                setState(() => selectedIndex = index);
              }
            },
            children: [
              FriendProfilePosts(
                friendId: widget.friendId,
                friendStatus: profileService.friendStatus,
                friendName: widget.friendName,
                friendProfileImage: widget.friendProfileImage,
              ),
              const FriendGamesShowCase(),
              const FriendLinkedAcc(),
              const FriendsFriendList()
            ]),
      ),
    );
  }
  
  
}
