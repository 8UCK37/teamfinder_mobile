import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

class MenuTab extends StatelessWidget {
  final TabController tabController;

  MenuTab(this.tabController);
  
  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
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
          Row(
            children: <Widget>[
              const SizedBox(width: 15.0),
              CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(userData['profilePicture']),
              ),
              const SizedBox(width: 20.0),
              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(userData['name'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0)),
                      const SizedBox(height: 5.0),
                      GestureDetector(
                        onTap: () => {
                         tabController.animateTo(1)
                        },
                        child:const Text(
                        'See your profile',
                        style: TextStyle(color: Colors.grey),
                      ) ,
                      ),   
                    ],
                  ),
                  const SizedBox(width:80),
                  GestureDetector(
                    onTap: () => {AuthService().signOut(context)},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(Icons.logout, size: 40.0, color: Colors.grey[700]),
                        const SizedBox(width: 10.0),
                        const Text('Logout', style: TextStyle(fontSize: 17.0)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Divider(height: 20.0),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 20,
                  height: 85.0,
                  padding: const EdgeInsets.only(left: 20.0),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.sports_esports, color: Colors.blue, size: 30.0),
                      SizedBox(height: 5.0),
                      Text('Games',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 30,
                  height: 85.0,
                  padding: const EdgeInsets.only(left: 20.0),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.account_tree,
                          color: Colors.blue, size: 30.0),
                      SizedBox(height: 5.0),
                      Text('Linked accounts',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold))
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 20,
                  height: 85.0,
                  padding: const EdgeInsets.only(left: 20.0),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.person, color: Colors.blue, size: 30.0),
                      SizedBox(height: 5.0),
                      Text('Friends',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 30,
                  height: 85.0,
                  padding: const EdgeInsets.only(left: 20.0),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.settings, color: Colors.blue, size: 30.0),
                      SizedBox(height: 5.0),
                      Text('Settings',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold))
                    ],
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
