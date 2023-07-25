import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamfinder_mobile/pages/friend_list.dart';
import 'package:teamfinder_mobile/pages/menu_pages/games_screen.dart';
import 'package:teamfinder_mobile/pages/menu_pages/settings.dart';
import 'package:teamfinder_mobile/pages/onboarding_page.dart';
import '../services/auth_service.dart';
import '../services/data_service.dart';

class MenuTab extends StatelessWidget {
  final TabController tabController;

  MenuTab(this.tabController);

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<ProviderService>(context);
    final userData = userService.user;
    return SingleChildScrollView(
      // ignore: avoid_unnecessary_containers
      child: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 15.0),
            child: Text('Menu',
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
          ),
          Center(
            child: SizedBox(
              height: 80,
             width: MediaQuery.of(context).size.width*0.94,
              child: Card(
                elevation: 5,
                surfaceTintColor: Colors.amberAccent,
                shadowColor: Colors.deepPurpleAccent,
                child: Row(
                  children: <Widget>[
                    //const SizedBox(height:15,width: 15.0),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: CircleAvatar(
                        radius: 25.0,
                        backgroundImage: NetworkImage(userData['profilePicture']),
                      ),
                    ),
                    //const SizedBox(width: 20.0),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(userData['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 18.0)),
                              //const SizedBox(height: 5.0),
                              GestureDetector(
                                onTap: () => {tabController.animateTo(1)},
                                child: const Text(
                                  'See your profile',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //const SizedBox(width: 120),
                        Padding(
                          padding: EdgeInsets.only(left:MediaQuery.of(context).size.width*.3),
                          child: GestureDetector(
                            onTap: () => {AuthService().signOut(context)},
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Icon(Icons.logout,
                                    size: 30.0,
                                    color: Color.fromARGB(255, 182, 86, 86)),
                                
                                 Center(child: Text('Logout', style: TextStyle(fontSize: 15.0))),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Divider(height: 20.0),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const GamesPage()),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    height: 85.0,
                    padding: const EdgeInsets.only(left: 20.0),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.sports_esports,
                            color: Colors.deepPurpleAccent.shade200,
                            size: 30.0),
                        const SizedBox(height: 5.0),
                        const Text('Games',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    //TODO currently linked to onboarding page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ConcentricAnimationOnboarding()),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2 - 30,
                    height: 85.0,
                    padding: const EdgeInsets.only(left: 20.0),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.account_tree,
                            color: Colors.deepPurpleAccent.shade200,
                            size: 30.0),
                        const SizedBox(height: 5.0),
                        const Text('Linked accounts',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FriendList()),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    height: 85.0,
                    padding: const EdgeInsets.only(left: 20.0),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.person,
                            color: Colors.deepPurpleAccent.shade200,
                            size: 30.0),
                        const SizedBox(height: 5.0),
                        const Text('Friends',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    debugPrint('goto settings');

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsPage()),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2 - 30,
                    height: 85.0,
                    padding: const EdgeInsets.only(left: 20.0),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.settings,
                            color: Colors.deepPurpleAccent.shade200,
                            size: 30.0),
                        const SizedBox(height: 5.0),
                        const Text('Settings',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}
