import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../services/user_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // String? userName = FirebaseAuth.instance.currentUser?.displayName;
  // String? userPhoto = FirebaseAuth.instance.currentUser?.photoURL;
  var user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    _hitExpressEndpoint();
  }

  void _hitExpressEndpoint() async {
    final url = Uri.parse('http://192.168.101.6:3000/micCheck');
    final user = FirebaseAuth.instance.currentUser;
    
    if (user != null) {
      final idToken = await user.getIdToken();

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $idToken'},
      );

      if (response.statusCode == 200) {
        // Request successful
        print(response.body);
      } else {
        // Request failed
        print('Failed to hit Express backend endpoint');
      }
    } else {
      // User not logged in
      print('User is not logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final userData = userService.user;
    return Scaffold(
      body: Column(
        children: [
          Expanded(flex: 2, child: _TopPortion(userPhoto: userData['profilePicture'],userBanner: userData['profileBanner'],)),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    userData['name'] ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton.extended(
                        onPressed: () {},
                        heroTag: 'follow',
                        elevation: 0,
                        label: const Text("Follow"),
                        icon: const Icon(Icons.person_add_alt_1),
                      ),
                      const SizedBox(width: 16.0),
                      FloatingActionButton.extended(
                        onPressed: () {},
                        heroTag: 'mesage',
                        elevation: 0,
                        backgroundColor: Colors.red,
                        label: const Text("Message"),
                        icon: const Icon(Icons.message_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const _ProfileInfoRow()
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const GNav(
        gap: 10,
        tabs: [
          GButton(
            icon: Icons.receipt_long,
            text: 'Posts',
            ),
          GButton(
            icon: Icons.sports_esports,
            text: 'Games',
            ),
          GButton(
            icon: Icons.diversity_3,
            text: 'Friends',
            ),
          GButton(
            icon: Icons.link,
            text: 'Linked Acc',
            ),
        ]) ,
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({Key? key}) : super(key: key);

  final List<ProfileInfoItem> _items = const [
    ProfileInfoItem("Posts", 900),
    ProfileInfoItem("Followers", 120),
    ProfileInfoItem("Following", 200),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _items
            .map((item) => Expanded(
                  child: Row(
                    children: [
                      if (_items.indexOf(item) != 0) const VerticalDivider(),
                      Expanded(child: _singleItem(context, item)),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.value.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Text(
            item.title,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
}

class ProfileInfoItem {
  final String title;
  final int value;
  const ProfileInfoItem(this.title, this.value);
}

class _TopPortion extends StatelessWidget {
  final String? userPhoto;
  final String? userBanner;
  const _TopPortion({Key? key, this.userPhoto,this.userBanner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color(0xff0043ba), Color(0xff006df1)],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(5),
            ),
            image: DecorationImage(
              image: NetworkImage(userBanner?? 'https://cdn-icons-png.flaticon.com/512/4885/4885780.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20), // Added left margin of 25
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(userPhoto ??
                            'https://cdn-icons-png.flaticon.com/512/4885/4885780.png'),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 5,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
