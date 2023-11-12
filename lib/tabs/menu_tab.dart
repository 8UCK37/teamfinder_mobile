import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:teamfinder_mobile/pages/friend_list.dart';
import 'package:teamfinder_mobile/pages/menu_pages/games_screen.dart';
import 'package:teamfinder_mobile/pages/menu_pages/linked_acc.dart';
import 'package:teamfinder_mobile/pages/menu_pages/settings.dart';
import '../services/auth_service.dart';
import '../services/data_service.dart';

class MenuTab extends StatelessWidget {
  final TabController tabController;

  const MenuTab(this.tabController, {super.key});

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
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: SizedBox(
                height: 80,
                //width: MediaQuery.of(context).size.width*0.94,
                child: Card(
                  elevation: 5,
                  surfaceTintColor: Colors.amberAccent,
                  shadowColor: userService.darkTheme!
                      ? Colors.transparent
                      : Colors.deepPurpleAccent,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>{tabController.animateTo(1)},
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                // ignore: avoid_unnecessary_containers
                                child: Container(
                                  //decoration: BoxDecoration(border: Border.all(color: Colors.green)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0,top:7.5,bottom:7.5),
                                        child: CircleAvatar(
                                          radius: 25.0,
                                          backgroundImage: NetworkImage(
                                              userData['profilePicture']),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(userData['name'],
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0)),
                                            //const SizedBox(height: 5.0),
                                            const Text(
                                              'See your profile',
                                              style: TextStyle(
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // ignore: avoid_unnecessary_containers
                      Container(
                        //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                        child: GestureDetector(
                          onTap: () => {
                            //AuthService().signOut(context);
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.confirm,
                              text: 'Do you want to logout',
                              confirmBtnText: 'Yes',
                              cancelBtnText: 'No',
                              confirmBtnColor: Colors.white,
                              backgroundColor: Colors.black,
                              confirmBtnTextStyle: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              barrierColor:
                                  const Color.fromARGB(107, 0, 0, 0),
                              titleColor: Colors.white,
                              textColor: Colors.white,
                              onConfirmBtnTap: () {
                                AuthService().signOut(context);
                              },
                            )
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.logout,
                                    size: 30.0,
                                    color:
                                        Color.fromARGB(255, 182, 86, 86)),
                                Center(
                                    child: Text('Logout',
                                        style: TextStyle(fontSize: 15.0))),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Divider(
                height: 20.0,
                color: userService.darkTheme!
                    ? const Color.fromARGB(255, 74, 74, 74)
                    : Colors.grey),
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
                          builder: (context) => const GamesPage()),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OwnLinkedAccounts()),
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
                          builder: (context) => SettingsPage(
                              isDarkCurrent: userService.darkTheme!)),
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
